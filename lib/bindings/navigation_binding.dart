import 'package:get/get.dart';
import 'package:manganjawa/auth/account/login_controller/login_controller.dart';
import 'package:manganjawa/pages/pages_controller/navigation_controller.dart';
import 'package:manganjawa/pages/pages_controller/profile_contoller.dart';
import 'package:manganjawa/services/auth_service.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
      fenix: true,
    );
    Get.lazyPut<LoginController>(
      () => LoginController(),
      fenix: true,
    );
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService());
    }
  }
}
