import 'package:get/get.dart';
import 'package:manganjawa/auth/account/controller/login_controller.dart';
import 'package:manganjawa/auth/account/services/auth_service.dart';
import 'package:manganjawa/controller/navigation_controller.dart';
import 'package:manganjawa/controller/profile_contoller.dart';

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
