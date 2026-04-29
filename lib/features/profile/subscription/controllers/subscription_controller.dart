import 'dart:convert';

import 'package:get/get.dart';

import '../../../../core/service/api_client.dart';
import '../../../../core/service/api_constants.dart';

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

class SubscriptionController extends GetxController {
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _plans = <SubscriptionPlan>[].obs;
  final _checkoutLoadingPlanId = ''.obs;
  final _checkoutErrorMessage = ''.obs;
  final _checkoutUrl = ''.obs;
  final _selectedCheckoutPlanId = ''.obs;

  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  List<SubscriptionPlan> get plans => _plans.toList(growable: false);
  String get checkoutLoadingPlanId => _checkoutLoadingPlanId.value;
  String get checkoutErrorMessage => _checkoutErrorMessage.value;
  String get checkoutUrl => _checkoutUrl.value;
  String get selectedCheckoutPlanId => _selectedCheckoutPlanId.value;

  @override
  void onInit() {
    super.onInit();
    fetchPlans();
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
    } catch (_) {
      _errorMessage.value =
          'Failed to load subscription plans. Please try again.';
    } finally {
      _isLoading.value = false;
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
    } catch (_) {
      _checkoutErrorMessage.value =
          'Failed to create checkout session. Please try again.';
    } finally {
      _checkoutLoadingPlanId.value = '';
    }
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
