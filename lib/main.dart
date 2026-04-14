import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/helpers/dependency_injection.dart';
import 'core/routes/app_pages.dart';
import 'core/themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          title: 'Service App',
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
