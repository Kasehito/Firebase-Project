import 'package:get/get.dart';

class NavigationController extends GetxController {

  final _selectedIndex = 0.obs;
  
  int get selectedIndex => _selectedIndex.value;
  
  void changeIndex(int index) {
    _selectedIndex.value = index;
  }

  final List<String> pages = [
    '/home'
    '/ordersPage', 
    '/profilePage'
  ];

  void navigateToPage(int index) {
    changeIndex(index);
  }
}