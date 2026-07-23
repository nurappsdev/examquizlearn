import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nailed_quiz_app/features/profile/subscription/controllers/subscription_controller.dart';
import 'package:nailed_quiz_app/features/profile/subscription/views/subscription_view.dart';

void main() {
  test('subscription screen detects YourPlan origin from route arguments', () {
    expect(
      subscriptionScreenOpenedFromYourPlan({
        subscriptionScreenOriginKey: subscriptionScreenYourPlanOrigin,
      }),
      isTrue,
    );
    expect(subscriptionScreenOpenedFromYourPlan(null), isFalse);
    expect(
      subscriptionScreenOpenedFromYourPlan({
        subscriptionScreenOriginKey: 'choose_plan',
      }),
      isFalse,
    );
  });

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

  test(
    'applePayAppAccountTokenFromUserId pads hex user id into UUID without changing user id bytes',
    () {
      final token = applePayAppAccountTokenFromUserId(
        '64b7f4e52f8f9f9d3c0a1234',
      );

      expect(token, '00000000-64b7-f4e5-2f8f-9f9d3c0a1234');
      expect(
        token,
        matches(
          RegExp(
            r'^0[0-9a-f]{7}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
          ),
        ),
      );
    },
  );

  test(
    'applePayAppAccountTokenFromUserId preserves backend user id example',
    () {
      final token = applePayAppAccountTokenFromUserId(
        '6a535a08a4f38d58d6732141',
      );

      expect(token, '00000000-6a53-5a08-a4f3-8d58d6732141');
    },
  );

  test(
    'applePayAppAccountTokenFromUserId returns existing UUID without changing version',
    () {
      const userId = '01234567-89ab-fdef-2123-456789abcdef';

      expect(applePayAppAccountTokenFromUserId(userId), userId);
    },
  );

  test('applePayAppAccountTokenFromUserId rejects missing user id', () {
    expect(applePayAppAccountTokenFromUserId(''), isNull);
  });
}
