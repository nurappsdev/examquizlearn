import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart' hide FirebaseService;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/helpers/dependency_injection.dart';
import 'core/routes/app_pages.dart';
import 'core/service/firebase_option.dart';
import 'core/service/firebase_service.dart';
import 'core/themes/light_theme.dart';

void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wire up FCM listeners + local-notification channel BEFORE runApp,
  // otherwise foreground messages and data-only payloads silently drop.
  final firebaseService = FirebaseService();
  await firebaseService.initializeNotifications();
  await firebaseService.setupFirebaseMessaging();

  FirebaseApp app = Firebase.app();
  print('Firebase initialized-------------------: ${app.name}');
  // Initialization logic
  DependencyInjection di = DependencyInjection();
  di.dependencies();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(),
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: ControllerBinder(),
          debugShowCheckedModeBanner: false,
          title: 'NAILEDit! General Contractor Exam Prep',
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          theme: light(),
          themeMode: ThemeMode.light,
        );
      },
    );
  }
}
class ControllerBinder extends Bindings {
  /// GLOBAL controller ====>
  @override
  void dependencies() {}
}
