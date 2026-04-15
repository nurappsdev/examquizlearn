import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/views/home_view.dart';
import '../../../core/utils/app_colors.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        switch (controller.currentIndex) {
          case 0:
            return const HomeView();
          case 1:
            return const Center(child: Text('Learning', style: TextStyle(color: Colors.white)));
          case 2:
            return const Center(child: Text('Profile', style: TextStyle(color: Colors.white)));
          default:
            return const HomeView();
        }
      }),
      bottomNavigationBar: Obx(() {
        return Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xff17A15D),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex,
              onTap: (index) => controller.changeIndex(index),
              backgroundColor: Colors.transparent,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withOpacity(0.5),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.psychology_outlined),
                  label: 'Brain',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
