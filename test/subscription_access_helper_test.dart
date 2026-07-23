import 'package:flutter_test/flutter_test.dart';
import 'package:nailed_quiz_app/core/helpers/prefs_helper.dart';
import 'package:nailed_quiz_app/core/helpers/subscription_access_helper.dart';
import 'package:nailed_quiz_app/core/utils/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('markPlanPendingForNewAccount clears stale selected plan state', () async {
    SharedPreferences.setMockInitialValues({
      AppConstants.hasSelectedPlan: true,
    });

    await SubscriptionAccessHelper.markPlanPendingForNewAccount();

    expect(await PrefsHelper.getBool(AppConstants.hasSelectedPlan), isFalse);
  });
}
