import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:manganjawa/pages/home_page.dart';
import 'package:manganjawa/pages/orders_page.dart';
import 'package:manganjawa/pages/pages_controller/navigation_controller.dart';
import 'package:manganjawa/pages/profile_page.dart';
import 'package:manganjawa/pages/widget/bottom_navbar.dart';

class BottomNavigation extends GetView<NavigationController> {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // handle back button
      onWillPop: () async {
        if (controller.selectedIndex != 0) {
          controller.changeIndex(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Obx(() => IndexedStack(
              index: controller.selectedIndex,
              children: [
                Home(),
                OrdersPage(),
                ProfilePage(),
              ],
            )),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
