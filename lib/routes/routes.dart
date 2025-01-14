import 'package:get/get.dart';
import 'package:manganjawa/pages/auth/login.dart';
import 'package:manganjawa/pages/auth/register.dart';
import 'package:manganjawa/pages/home/home.dart';

class MyRoutes {
  // Route names as static constants
  static const String login = '/login';
  static const String home = '/home';
  static const String signup = '/signup';

  // List of GetPages for GetX navigation
  static final pageRoutes = [
    GetPage(
      name: login,
      page: () => LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signup,
      page: () => RegisterPage(),
      transition: Transition.fadeIn,
    ),
  ];
}
