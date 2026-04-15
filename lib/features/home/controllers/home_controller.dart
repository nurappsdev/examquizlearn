import 'package:get/get.dart';

class HomeController extends GetxController {
  final _selectedCategoryIndex = 0.obs;
  int get selectedCategoryIndex => _selectedCategoryIndex.value;
  set selectedCategoryIndex(int index) => _selectedCategoryIndex.value = index;

  void changeCategory(int index) {
    _selectedCategoryIndex.value = index;
  }
}
