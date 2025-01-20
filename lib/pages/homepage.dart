import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manganjawa/controller/navigation_controller.dart';
import 'package:manganjawa/pages/home.dart';
import 'package:manganjawa/pages/orders_page.dart';
import 'package:manganjawa/pages/profile_page.dart';
import 'package:manganjawa/widget/bottom_navbar.dart';

class Homepage extends GetView<NavigationController> {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope( // Add this to handle back button
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
              children: const [
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