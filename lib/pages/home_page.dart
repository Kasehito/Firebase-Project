import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:manganjawa/auth/auth_services/auth_service.dart';
import 'package:manganjawa/pages/pages_controller/menu_controller.dart';
import 'package:manganjawa/pages/menu_editor_page.dart';
import 'package:manganjawa/pages/widget/category_card.dart';
import 'package:manganjawa/pages/pages_controller/orders_controller.dart';
import 'package:manganjawa/pages/widget/home_container.dart';
import 'package:manganjawa/pages/widget/menu_card.dart';

class Home extends StatelessWidget {
  final TableMenuController menuController = Get.put(TableMenuController());
  final AuthService authService = Get.find<AuthService>();

  Home({super.key});

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Icons.lunch_dining;
      case 'minuman':
        return HugeIcons.strokeRoundedSoftDrink01;
      case 'snack':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  void _navigateToMenuEditor(BuildContext context,
      {String? id,
      String? name,
      String? description,
      String? category,
      double? price,
      int? stock}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuEditor(
          onSave: (nama, kategori, deskripsi, harga, stok) {
            if (id == null) {
              menuController.addMenu(nama, kategori, deskripsi, harga, stok);
            } else {
              menuController.updateMenu(
                  id, nama, kategori, deskripsi, harga, stok);
            }
          },
          initialName: name,
          initialDescription: description,
          initialCategory: category,
          initialPrice: price,
          initialStock: stock,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: authService.isAdmin
          ? FloatingActionButton(
              onPressed: () => _navigateToMenuEditor(context),
              backgroundColor: const Color(0xFFFF9F1C),
              child: const Icon(Icons.add),
            )
          : null,
      body: HomeContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mangan Jawa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() => Row(
                          children: [
                            CategoryCard(
                              color: const Color(0xFFF5D4C1),
                              icon: Icons.lunch_dining,
                              label: 'Makanan',
                              isSelected:
                                  menuController.selectedCategory.value ==
                                      'makanan',
                              onTap: () {
                                menuController.selectedCategory.value =
                                    'makanan';
                                menuController.filterMenuByCategory('makanan');
                              },
                            ),
                            const SizedBox(width: 16),
                            CategoryCard(
                              color: const Color(0xFFFDEBC8),
                              icon: HugeIcons.strokeRoundedSoftDrink01,
                              label: 'Minuman',
                              isSelected:
                                  menuController.selectedCategory.value ==
                                      'minuman',
                              onTap: () {
                                menuController.selectedCategory.value =
                                    'minuman';
                                menuController.filterMenuByCategory('minuman');
                              },
                            ),
                            const SizedBox(width: 16),
                            CategoryCard(
                              color: const Color(0xFFD0F1EB),
                              icon: Icons.cookie,
                              label: 'Snack',
                              isSelected:
                                  menuController.selectedCategory.value ==
                                      'snack',
                              onTap: () {
                                menuController.selectedCategory.value = 'snack';
                                menuController.filterMenuByCategory('snack');
                              },
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            //Menu Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Food Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      menuController.selectedCategory.value = '';
                      menuController.filterMenuByCategory('');
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Color(0xFFFF9F1C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Menu
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => ListView.builder(
                    itemCount: menuController.filteredMenuList.length,
                    itemBuilder: (context, index) {
                      final menu = menuController.filteredMenuList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: MenuCard(
                          name: menu.nama,
                          description: menu.deskripsi,
                          price: menu.harga,
                          stock: menu.stok,
                          icon: _getIconForCategory(menu.kategori),
                          onEdit: authService.isAdmin
                              ? () {
                                  _navigateToMenuEditor(
                                    context,
                                    id: menu.id,
                                    name: menu.nama,
                                    description: menu.deskripsi,
                                    category: menu.kategori,
                                    price: menu.harga,
                                    stock: menu.stok,
                                  );
                                }
                              : null,
                          onDelete: authService.isAdmin
                              ? () => menuController.deleteMenu(menu.id!)
                              : null,
                          onAddToOrder: () {
                            final OrdersController ordersController =
                                Get.find<OrdersController>();
                            ordersController.addToOrder(menu);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
