import 'package:get/get.dart';
import 'package:manganjawa/auth/auth_pages/login.dart';
import 'package:manganjawa/auth/auth_pages/register.dart';
import 'package:manganjawa/bindings/navigation_binding.dart';
import 'package:manganjawa/pages/admin_page.dart';
import 'package:manganjawa/pages/home_page.dart';
import 'package:manganjawa/pages/bottom_navigation.dart';
import 'package:manganjawa/pages/orders_page.dart';
import 'package:manganjawa/pages/profile_page.dart';

class MyRoutes {
  // Route names as static constants
  static const String login = '/login';
  static const String signup = '/signup';
  static const String bottomNavigation = '/bottomNavigation';
  static const String home = '/home';
  static const String ordersPage = '/ordersPage';
  static const String profilePage = '/profilePage';
  static const String adminPage = '/adminPage';

  // List of GetPages for GetX navigation
  static final pageRoutes = [
    GetPage(
      name: login,
      page: () => LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signup,
      page: () => RegisterPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: bottomNavigation,
      page: () => BottomNavigation(),
      binding: NavigationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => Home(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: ordersPage,
      page: () => OrdersPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profilePage,
      page: () => ProfilePage(),
      binding: NavigationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: adminPage,
      page: () => AdminPage(),
      transition: Transition.fadeIn,
    ),
  ];
}
