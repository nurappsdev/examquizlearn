import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nailed_quiz_app/features/profile/subscription/controllers/subscription_controller.dart';

void main() {
  test(
    'SubscriptionPlan reads App Store product id from subscription payload',
    () {
      final plan = SubscriptionPlan.fromJson({
        'id': 'backend-plan-id',
        'name': 'Monthly',
        'code': 'monthly_plan',
        'price': 9.99,
        'appleProductId': 'com.nailedit.monthly',
      });

      expect(plan.appStoreProductId, 'com.nailedit.monthly');
    },
  );

  test('SubscriptionPlan falls back to code for App Store product id', () {
    final plan = SubscriptionPlan.fromJson({
      'id': 'backend-plan-id',
      'name': 'Monthly',
      'code': 'monthly_plan',
      'price': 9.99,
    });

    expect(plan.appStoreProductId, 'monthly_plan');
  });

  test('applePayCompletedPayload includes purchase verification data', () {
    final purchase = PurchaseDetails(
      purchaseID: 'purchase-123',
      productID: 'com.nailedit.monthly',
      verificationData: PurchaseVerificationData(
        localVerificationData: 'local-receipt',
        serverVerificationData: 'server-receipt',
        source: 'app_store',
      ),
      transactionDate: '1721280000000',
      status: PurchaseStatus.purchased,
    );

    expect(applePayCompletedPayload(purchase), {
      'paymentProvider': 'apple_pay',
      'status': 'purchased',
      'purchaseId': 'purchase-123',
      'productId': 'com.nailedit.monthly',
      'transactionDate': '1721280000000',
      'verificationData': {
        'source': 'app_store',
        'localVerificationData': 'local-receipt',
        'serverVerificationData': 'server-receipt',
      },
    });
  });
}
