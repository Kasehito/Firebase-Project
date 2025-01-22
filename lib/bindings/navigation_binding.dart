import 'package:get/get.dart';
import 'package:manganjawa/auth/auth_controller/login_controller.dart';
import 'package:manganjawa/pages/pages_controller/navigation_controller.dart';
import 'package:manganjawa/pages/pages_controller/orders_controller.dart';
import 'package:manganjawa/pages/pages_controller/profile_contoller.dart';
import 'package:manganjawa/auth/auth_services/auth_service.dart';
import 'package:manganjawa/services/notification_service.dart';

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
   Get.lazyPut<OrdersController>(
      () => OrdersController(),
      fenix: true,
    );
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService());
    }
    if (!Get.isRegistered<NotificationService>()) {
      Get.put(NotificationService(), permanent: true);
    }
  }
}
