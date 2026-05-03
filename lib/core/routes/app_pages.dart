import 'package:examtest/features/auth/reset_password/views/reset_password_view.dart';
import 'package:get/get.dart';
import '../../features/auth/personal_info_auth/bindings/personal_info_binding.dart';
import '../../features/auth/personal_info_auth/views/personal_info_view.dart';
import '../../features/educational_content/bindings/educational_content_binding.dart';
import '../../features/educational_content/views/text_content_list_view.dart';
import '../../features/educational_content/views/text_content_detail_view.dart';
import '../../features/profile/subscription/bindings/subscription_binding.dart';
import '../../features/profile/subscription/views/manage_subscription_view.dart';
import '../../features/profile/subscription/views/subscription_view.dart';
import '../routes/app_routes.dart';
import '../themes/light_theme.dart';
import '../../features/profile/views/add_bio_view.dart';
import '../../features/profile/views/add_contact_info_view.dart';
import '../../features/profile/views/add_education_view.dart';
import '../../features/profile/views/admin_support_view.dart';
import '../../features/profile/views/change_password_view.dart';
import '../../features/profile/views/html_content_view.dart';
import '../../features/profile/views/settings_view.dart';
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
import '../../features/profile/personal_info/bindings/personal_info_binding.dart';
import '../../features/profile/personal_info/views/personal_info_view.dart';
import '../../features/main/bindings/main_binding.dart';
import '../../features/main/views/main_view.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/views/home_view.dart';
import '../../features/carpentry/bindings/carpentry_binding.dart';
import '../../features/carpentry/views/carpentry_alternative_view.dart';
import '../../features/quiz/bindings/quiz_binding.dart';
import '../../features/quiz/views/quiz_view.dart';
import '../../features/quiz/views/quiz_info_view.dart';
import '../../features/quiz/views/quiz_result_view.dart';
import '../../features/educational_content/views/tutorial_list_view.dart';
import '../../features/educational_content/views/video_play_view.dart';
import '../../features/profile/bindings/profile_binding.dart';
import '../../features/profile/views/profile_view.dart';
import '../../features/profile/views/profile_info_view.dart';
import '../../features/profile/edit_profile/bindings/edit_profile_binding.dart';
import '../../features/profile/edit_profile/views/edit_profile_view.dart';

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
      page: () => const CarpentryAlternativeView(),
      transition: Transition.topLevel,
      binding: CarpentryBinding(),
    ),
    GetPage(
      name: AppRoutes.carpentryAlternative,
      page: () => const CarpentryAlternativeView(),
      transition: Transition.topLevel,
      binding: CarpentryBinding(),
    ),
    GetPage(
      name: AppRoutes.quiz,
      page: () => const QuizView(),
      transition: Transition.topLevel,
      binding: QuizBinding(),
    ),
    GetPage(
      name: AppRoutes.quizInfo,
      page: () => const QuizInfoView(),
      transition: Transition.topLevel,
      binding: QuizBinding(),
    ),
    GetPage(
      name: AppRoutes.quizResult,
      page: () => const QuizResultView(),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: AppRoutes.tutorialList,
      page: () => const TutorialListView(),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: AppRoutes.videoPlay,
      page: () => const VideoPlayView(),
      transition: Transition.topLevel,
    ),

    GetPage(
      name: AppRoutes.textContentList,
      page: () => const TextContentListView(),
      transition: Transition.topLevel,
      binding: EducationalContentBinding(),
    ),

    GetPage(
      name: AppRoutes.textContentDetail,
      page: () => const TextContentDetailView(),
      transition: Transition.topLevel,
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      transition: Transition.topLevel,
      binding: ProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.profileInfo,
      page: () => const ProfileInfoView(),
      transition: Transition.topLevel,
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      transition: Transition.topLevel,
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.subscriptionScreen,
      page: () => SubscriptionScreen(),
      transition: Transition.topLevel,
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: AppRoutes.manageSubscription,
      page: () => const ManageSubscriptionView(),
      transition: Transition.topLevel,
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: AppRoutes.adminSupport,
      page: () => const AdminSupportView(),
      transition: Transition.topLevel,
    ),

    GetPage(
      name: AppRoutes.profileInfoProfile,
      page: () =>  PersonalInfoViewProfile(),
      transition: Transition.topLevel,
      binding: PersonalInfoProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordView(),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: AppRoutes.aboutUs,
      page: () => const HtmlContentView(
        title: 'About us',
        htmlContent: 'Lorem ipsum dolor sit amet consectetur. Enim massa aenean ac odio leo habitasse tortor tempor. Ut id urna odio dui leo congue. Ultrices pharetra ornare nam faucibus. Integer id varius consectetur non.<br><br>Lorem ipsum dolor sit amet consectetur. Enim massa aenean ac odio leo habitasse tortor tempor. Ut id urna odio dui leo congue. Ultrices pharetra ornare nam faucibus. Integer id varius consectetur non.<br><br>Lorem ipsum dolor sit amet consectetur. Enim massa aenean ac odio leo habitasse tortor tempor. Ut id urna odio dui leo congue. Ultrices pharetra ornare nam faucibus. Integer id varius consectetur non.',
      ),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const HtmlContentView(
        title: 'Privacy Policy',
        htmlContent: '<h1>Privacy Policy</h1><p>Your privacy is important to us...</p>',
      ),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: AppRoutes.termsOfService,
      page: () => const HtmlContentView(
        title: 'Terms of service',
        htmlContent: '<h1>Terms of Service</h1><p>By using our app, you agree to...</p>',
      ),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: AppRoutes.addBio,
      page: () => const AddBioView(),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: AppRoutes.addContactInfo,
      page: () => const AddContactInfoView(),
      transition: Transition.topLevel,
    ),
    GetPage(
      name: AppRoutes.addEducation,
      page: () => const AddEducationView(),
      transition: Transition.topLevel,
    ),
    ];
    }
