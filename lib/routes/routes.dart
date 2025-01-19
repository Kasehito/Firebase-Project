import 'package:get/get.dart';
import 'package:manganjawa/auth/account/login.dart';
import 'package:manganjawa/auth/account/register.dart';
import 'package:manganjawa/bindings/navigation_binding.dart';
import 'package:manganjawa/pages/detail_page.dart';
import 'package:manganjawa/pages/home.dart';
import 'package:manganjawa/pages/homepage.dart';
import 'package:manganjawa/pages/orders_page.dart';
import 'package:manganjawa/pages/profile_page.dart';

class MyRoutes {
  // Route names as static constants
  static const String login = '/login';
  static const String signup = '/signup';
  static const String homePage = '/homePage';
  static const String home = '/home';
  static const String ordersPage = '/ordersPage';
  static const String profilePage = '/profilePage';
  static const String detailPage = '/detailPage';

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
      name: homePage,
      page: () => Homepage(),
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
      name: detailPage,
      page: () => DetailPage(),
      transition: Transition.fadeIn,
    ),
  ];
}
