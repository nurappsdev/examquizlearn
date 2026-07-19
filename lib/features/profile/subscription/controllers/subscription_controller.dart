import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/helpers/helpers.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_constants.dart';
import '../../../../core/widgets/payment_webview.dart';

class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.code,
    required this.price,
    required this.currency,
    required this.durationDays,
    required this.billingInterval,
    required this.billingIntervalCount,
    required this.trialPeriodDays,
    required this.description,
    required this.hasAllAccess,
    required this.appStoreProductId,
  });

  final String id;
  final String name;
  final String code;
  final double price;
  final String currency;
  final int durationDays;
  final String billingInterval;
  final int billingIntervalCount;
  final int trialPeriodDays;
  final String description;
  final bool hasAllAccess;
  final String appStoreProductId;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: _stringValue(json, ['id', '_id']),
      name: _stringValue(json, ['name', 'title']),
      code: _stringValue(json, ['code', 'planType']),
      price: _doubleValue(json['price']),
      currency: _stringValue(json, ['currency'], fallback: 'USD'),
      durationDays: _intValue(json['durationDays']),
      billingInterval: _stringValue(json, [
        'billingInterval',
      ], fallback: 'month'),
      billingIntervalCount: _intValue(
        json['billingIntervalCount'],
        fallback: 1,
      ),
      trialPeriodDays: _intValue(json['trialPeriodDays']),
      description: _stringValue(json, ['description']),
      hasAllAccess: json['hasAllAccess'] == true,
      appStoreProductId: _stringValue(json, [
        'appleProductId',
        'iosProductId',
        'appStoreProductId',
        'storeKitProductId',
      ], fallback: _stringValue(json, ['code', 'id', '_id'])),
    );
  }

  String get displayName => name.isEmpty ? code : name;

  String get billingLabel {
    if (price <= 0) {
      return trialPeriodDays > 0 ? '$trialPeriodDays day trial' : 'Free';
    }

    final interval = billingIntervalCount > 1
        ? '$billingIntervalCount ${billingInterval}s'
        : billingInterval;
    return '/ $interval';
  }

  String get durationLabel {
    if (durationDays <= 0) {
      return 'Access duration varies';
    }

    return '$durationDays days access';
  }

  static String _stringValue(
    Map<String, dynamic> source,
    List<String> keys, {
    String fallback = '',
  }) {
    for (final key in keys) {
      final value = source[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return fallback;
  }

  static int _intValue(dynamic value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }

    return fallback;
  }

  static double _doubleValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }
}

Map<String, dynamic> applePayCompletedPayload(PurchaseDetails purchase) {
  return {
    'paymentProvider': 'apple_pay',
    'status': purchase.status.name,
    'purchaseId': purchase.purchaseID,
    'productId': purchase.productID,
    'transactionDate': purchase.transactionDate,
    'verificationData': {
      'source': purchase.verificationData.source,
      'localVerificationData': purchase.verificationData.localVerificationData,
      'serverVerificationData':
          purchase.verificationData.serverVerificationData,
    },
  };
}

class SubscriptionController extends GetxController {
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _plans = <SubscriptionPlan>[].obs;
  final _checkoutLoadingPlanId = ''.obs;
  final _checkoutErrorMessage = ''.obs;
  final _checkoutUrl = ''.obs;
  final _selectedCheckoutPlanId = ''.obs;
  final _applePayLoadingPlanId = ''.obs;
  final _applePayErrorMessage = ''.obs;
  final _pendingApplePayProductId = ''.obs;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  List<SubscriptionPlan> get plans =>
      _plans.where((plan) => plan.price > 0).toList(growable: false);

  SubscriptionPlan? get freePlan =>
      _plans.firstWhereOrNull((plan) => plan.price <= 0);

  bool get isStartingFreeTrial =>
      _isLoading.value ||
      (freePlan != null && _checkoutLoadingPlanId.value == freePlan!.id);
  String get checkoutLoadingPlanId => _checkoutLoadingPlanId.value;
  String get checkoutErrorMessage => _checkoutErrorMessage.value;
  String get checkoutUrl => _checkoutUrl.value;
  String get selectedCheckoutPlanId => _selectedCheckoutPlanId.value;
  String get applePayLoadingPlanId => _applePayLoadingPlanId.value;
  String get applePayErrorMessage => _applePayErrorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
      _handlePurchaseUpdates,
    );
    fetchPlans();
  }

  @override
  void onClose() {
    _purchaseSubscription?.cancel();
    super.onClose();
  }

  Future<void> fetchPlans() async {
    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      final response = await ApiClient.getData(
        ApiConstants.subscriptionPlansEndPoint,
      );

      if (!_isSuccess(response)) {
        _errorMessage.value = _responseMessage(
          response.body,
          fallback: 'Failed to load subscription plans. Please try again.',
        );
        return;
      }

      _plans.assignAll(_extractPlans(response.body));
      _printPlans();
    } catch (_) {
      _errorMessage.value =
          'Failed to load subscription plans. Please try again.';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> startFreeTrial() async {
    if (_plans.isEmpty) {
      await fetchPlans();
    }

    final plan = freePlan;
    if (plan == null) {
      ToastMessageHelper.errorMessageShowToster(
        'Free trial plan is not available right now.',
      );
      return;
    }

    await createCheckoutSession(plan);

    if (_checkoutErrorMessage.value.isNotEmpty) {
      ToastMessageHelper.errorMessageShowToster(_checkoutErrorMessage.value);
    }
  }

  Future<void> createCheckoutSession(SubscriptionPlan plan) async {
    if (plan.id.isEmpty) {
      _selectedCheckoutPlanId.value = plan.id;
      _checkoutUrl.value = '';
      _checkoutErrorMessage.value =
          'This plan is missing an ID. Please refresh and try again.';
      return;
    }

    _selectedCheckoutPlanId.value = plan.id;
    _checkoutLoadingPlanId.value = plan.id;
    _checkoutErrorMessage.value = '';
    _checkoutUrl.value = '';

    try {
      final body = jsonEncode({'planId': plan.id});
      final response = await ApiClient.postData(
        ApiConstants.subscriptionCheckoutEndPoint,
        body,
      );

      if (!_isSuccess(response)) {
        _checkoutErrorMessage.value = _responseMessage(
          response.body,
          fallback: 'Failed to create checkout session. Please try again.',
        );
        return;
      }

      final checkoutUrl = _extractCheckoutUrl(response.body);
      if (checkoutUrl.isEmpty) {
        _checkoutErrorMessage.value =
            'Checkout session was created but no checkout URL was returned.';
        return;
      }

      _checkoutUrl.value = checkoutUrl;

      // Navigate to PaymentWebView
      final result = await Get.to(() => PaymentWebView(url: checkoutUrl));

      if (result == 'success') {
        // Handle success
        ToastMessageHelper.successMessageShowToster(
          'Payment successful! Redirecting...',
        );

        // Give the backend a moment to process the webhook/transaction
        await Future.delayed(const Duration(seconds: 2));

        // Refresh plans to update local state
        await fetchPlans();

        // Navigate to MainView and clear stack
        Get.offAllNamed(AppRoutes.main);
      } else if (result == 'cancel') {
        _checkoutErrorMessage.value = 'Payment was cancelled.';
      }
    } catch (_) {
      _checkoutErrorMessage.value =
          'Failed to create checkout session. Please try again.';
    } finally {
      _checkoutLoadingPlanId.value = '';
    }
  }

  Future<void> startApplePay(SubscriptionPlan plan) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      _setApplePayError(plan, 'Apple pay is only available on iOS.');
      return;
    }

    final productId = plan.appStoreProductId.trim();
    if (productId.isEmpty) {
      _setApplePayError(plan, 'This plan is missing an App Store product ID.');
      return;
    }

    _selectedCheckoutPlanId.value = plan.id;
    _applePayLoadingPlanId.value = plan.id;
    _applePayErrorMessage.value = '';
    _pendingApplePayProductId.value = productId;

    try {
      final isAvailable = await InAppPurchase.instance.isAvailable();
      if (!isAvailable) {
        _setApplePayError(
          plan,
          'Apple pay sandbox is not available on this device.',
        );
        return;
      }

      final response = await InAppPurchase.instance.queryProductDetails({
        productId,
      });
      if (response.error != null) {
        _setApplePayError(plan, response.error!.message);
        return;
      }

      if (response.productDetails.isEmpty) {
        _setApplePayError(
          plan,
          'App Store product "$productId" was not found. Check sandbox product setup.',
        );
        return;
      }

      final purchaseParam = PurchaseParam(
        productDetails: response.productDetails.first,
        applicationUserName: plan.id.isEmpty ? null : plan.id,
      );
      final didStart = await InAppPurchase.instance.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!didStart) {
        _setApplePayError(
          plan,
          'Apple pay sandbox could not be opened. Please try again.',
        );
      }
    } catch (_) {
      _setApplePayError(
        plan,
        'Apple pay sandbox could not be opened. Please try again.',
      );
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!_isPendingApplePayPurchase(purchase)) {
        continue;
      }

      switch (purchase.status) {
        case PurchaseStatus.pending:
          _applePayErrorMessage.value = '';
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _completeApplePayPurchase(purchase);
          break;
        case PurchaseStatus.error:
          _applePayErrorMessage.value =
              purchase.error?.message ?? 'Apple pay failed. Please try again.';
          await _completePurchaseIfNeeded(purchase);
          _clearApplePayLoading();
          break;
        case PurchaseStatus.canceled:
          _applePayErrorMessage.value = 'Apple pay was cancelled.';
          await _completePurchaseIfNeeded(purchase);
          _clearApplePayLoading();
          break;
      }
    }
  }

  bool _isPendingApplePayPurchase(PurchaseDetails purchase) {
    final pendingProductId = _pendingApplePayProductId.value;
    return pendingProductId.isNotEmpty &&
        purchase.productID == pendingProductId;
  }

  Future<void> _completeApplePayPurchase(PurchaseDetails purchase) async {
    debugPrint(
      'Apple pay completed payload-----------------------------: ${jsonEncode(applePayCompletedPayload(purchase))}',
    );
    await _completePurchaseIfNeeded(purchase);
    ToastMessageHelper.successMessageShowToster('Apple pay successful!');
    await Future.delayed(const Duration(seconds: 2));
    await fetchPlans();
    _clearApplePayLoading();
    Get.offAllNamed(AppRoutes.main);
  }

  Future<void> _completePurchaseIfNeeded(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await InAppPurchase.instance.completePurchase(purchase);
    }
  }

  void _setApplePayError(SubscriptionPlan plan, String message) {
    _selectedCheckoutPlanId.value = plan.id;
    _applePayErrorMessage.value = message;
    _clearApplePayLoading();
  }

  void _clearApplePayLoading() {
    _applePayLoadingPlanId.value = '';
    _pendingApplePayProductId.value = '';
  }

  void _printPlans() {
    debugPrint('===== Subscription Plans (total: ${_plans.length}) =====');
    for (var i = 0; i < _plans.length; i++) {
      final plan = _plans[i];
      debugPrint(
        'Plan ${i + 1}: '
        'id=${plan.id}, '
        'name=${plan.name}, '
        'code=${plan.code}, '
        'price=${plan.price}, '
        'currency=${plan.currency}, '
        'durationDays=${plan.durationDays}, '
        'billingInterval=${plan.billingInterval}, '
        'billingIntervalCount=${plan.billingIntervalCount}, '
        'trialPeriodDays=${plan.trialPeriodDays}, '
        'hasAllAccess=${plan.hasAllAccess}, '
        'description=${plan.description}',
      );
    }
    debugPrint('=================================================');
  }

  bool _isSuccess(Response response) {
    final statusCode = response.statusCode ?? 0;
    return statusCode >= 200 && statusCode < 300;
  }

  List<SubscriptionPlan> _extractPlans(dynamic body) {
    final data = body is Map ? body['data'] : body;
    final list = _findList(data);
    return list
        .whereType<Map>()
        .map(
          (plan) => SubscriptionPlan.fromJson(Map<String, dynamic>.from(plan)),
        )
        .toList();
  }

  List<dynamic> _findList(dynamic value) {
    if (value is List) {
      return value;
    }

    if (value is Map) {
      for (final key in ['docs', 'items', 'results', 'plans', 'data']) {
        final nested = value[key];
        if (nested is List) {
          return nested;
        }
      }
    }

    return const [];
  }

  String _responseMessage(dynamic body, {required String fallback}) {
    if (body is Map && body['message'] != null) {
      return body['message'].toString();
    }

    return fallback;
  }

  String _extractCheckoutUrl(dynamic body) {
    if (body is! Map) {
      return '';
    }

    final data = body['data'];
    if (data is Map && data['url'] is String) {
      return data['url'].toString().trim();
    }

    return '';
  }
}
