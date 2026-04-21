import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/views/home_view.dart';
import '../../educational_content/views/educational_content_view.dart';
import '../../profile/views/profile_view.dart';
import '../../../core/widgets/custom_bottom_bar.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(() {
          switch (controller.currentIndex) {
            case 0:
              return const HomeView();
            case 1:
              return const EducationalContentView();
            case 2:
              return const ProfileView();
            default:
              return const HomeView();
          }
        }),
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
