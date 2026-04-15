import 'package:get/get.dart';

class MainController extends GetxController {
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  set currentIndex(int index) => _currentIndex.value = index;

  void changeIndex(int index) {
    _currentIndex.value = index;
  }
}
