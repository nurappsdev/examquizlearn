import 'package:get/get.dart';
import 'app_routes.dart';
import '../../features/splash/bindings/splash_binding.dart';
import '../../features/splash/views/splash_view.dart';
import '../../features/auth/signin/bindings/signin_binding.dart';
import '../../features/auth/signin/views/signin_view.dart';
import '../../features/auth/signup/bindings/signup_binding.dart';
import '../../features/auth/signup/views/signup_view.dart';
import '../../features/auth/verification/bindings/verification_binding.dart';
import '../../features/auth/verification/views/verification_view.dart';
import '../../features/auth/otp/bindings/otp_binding.dart';
import '../../features/auth/otp/views/otp_view.dart';
import '../../features/auth/reset_password/bindings/reset_password_binding.dart';
import '../../features/auth/reset_password/views/reset_password_view.dart';
import '../../features/profile/personal_info/bindings/personal_info_binding.dart';
import '../../features/profile/personal_info/views/personal_info_view.dart';
import '../../features/main/bindings/main_binding.dart';
import '../../features/main/views/main_view.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/views/home_view.dart';
import '../../features/carpentry/bindings/carpentry_binding.dart';
import '../../features/carpentry/views/carpentry_view.dart';

class AppPages {
  static const String initial = AppRoutes.splash;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      transition: Transition.topLevel,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.signin,
      page: () => const SigninView(),
      transition: Transition.topLevel,
      binding: SigninBinding(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupView(),
      transition: Transition.topLevel,
      binding: SignupBinding(),
    ),
    GetPage(
      name: AppRoutes.verification,
      page: () => const VerificationView(),
      transition: Transition.topLevel,
      binding: VerificationBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpView(),
      transition: Transition.topLevel,
      binding: OtpBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordView(),
      transition: Transition.topLevel,
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.personalInfo,
      page: () => const PersonalInfoView(),
      transition: Transition.topLevel,
      binding: PersonalInfoBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainView(),
      transition: Transition.topLevel,
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      transition: Transition.topLevel,
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.carpentry,
      page: () => const CarpentryView(),
      transition: Transition.topLevel,
      binding: CarpentryBinding(),
    ),
  ];
}
