import '../routes/app_routes.dart';
import '../service/api_client.dart';
import '../service/api_constants.dart';
import '../utils/app_constant.dart';
import 'prefs_helper.dart';

class SubscriptionAccessHelper {
  const SubscriptionAccessHelper._();

  /// Decides where a signed-in user should land based on their access.
  ///
  /// - Access granted -> main
  /// - Access denied and the user already used a trial/subscription
  ///   (e.g. expired trial) -> subscription plans, so they must purchase
  /// - Access denied with no subscription history -> choose plan screen,
  ///   since they never finished picking free trial vs paid subscription
  /// - Invalid token -> signin
  static Future<String> resolveStartRoute() async {
    final accessResponse =
        await ApiClient.getData(ApiConstants.topicProgressEndPoint);
    final statusCode = accessResponse.statusCode ?? 0;

    if (statusCode == 401) {
      await PrefsHelper.remove(AppConstants.bearerToken);
      return AppRoutes.signin;
    }

    if (statusCode != 403) {
      return AppRoutes.main;
    }

    return await _hasSubscriptionHistory()
        ? AppRoutes.choosePlan
        : AppRoutes.subscriptionScreen;
  }

  static Future<bool> _hasSubscriptionHistory() async {
    final response = await ApiClient.getData(ApiConstants.subscriptionMeEndPoint);
    final statusCode = response.statusCode ?? 0;

    if (statusCode < 200 || statusCode >= 300) {
      return false;
    }

    final body = response.body;
    return body is Map && body['data'] is Map;
  }
}
