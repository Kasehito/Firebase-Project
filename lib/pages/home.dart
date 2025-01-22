import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manganjawa/pages/pages_controller/menu_controller.dart';
import 'package:manganjawa/widgets/add_menu_dialog.dart';
import 'package:manganjawa/widgets/category_card.dart';
import 'package:manganjawa/pages/pages_controller/orders_controller.dart';
import 'package:manganjawa/widgets/edit_delete_dialog.dart';
import 'package:manganjawa/widgets/edit_menu_dialog.dart';
import 'package:manganjawa/widgets/home_container.dart';
import 'package:manganjawa/widgets/menu_card.dart';

class Home extends StatelessWidget {
  final TableMenuController menuController = Get.put(TableMenuController());

  Home({super.key});

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Icons.fastfood;
      case 'minuman':
        return Icons.local_drink;
      case 'snack':
        return Icons.cake;
      default:
        return Icons.restaurant;
    }
  }

  void _showAddMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddMenuDialog(
        onAdd: (nama, kategori, deskripsi, harga, stok) {
          menuController.addMenu(nama, kategori, deskripsi, harga, stok);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenuDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFFF9F1C),
      ),
      body: HomeContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    child: Row(
                      children: [
                        CategoryCard(
                          color: const Color(0xFFF5D4C1),
                          icon: Icons.fastfood,
                          label: 'Makanan',
                          onTap: () {
                            menuController.selectedCategory.value = 'makanan';
                            menuController.filterMenuByCategory('makanan');
                          },
                        ),
                        const SizedBox(width: 16),
                        CategoryCard(
                          color: const Color(0xFFFDEBC8),
                          icon: Icons.local_drink,
                          label: 'Minuman',
                          onTap: () {
                            menuController.selectedCategory.value = 'minuman';
                            menuController.filterMenuByCategory('minuman');
                          },
                        ),
                        const SizedBox(width: 16),
                        CategoryCard(
                          color: const Color(0xFFD0F1EB),
                          icon: Icons.cake,
                          label: 'Snack',
                          onTap: () {
                            menuController.selectedCategory.value = 'snack';
                            menuController.filterMenuByCategory('snack');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 16),
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
                        child: GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditDeleteDialog(
                                onEdit: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditMenuDialog(
                                      initialName: menu.nama,
                                      initialDescription: menu.deskripsi,
                                      initialPrice: menu.harga,
                                      initialStock: menu.stok,
                                      onSave:
                                          (name, description, price, stock) {
                                        menuController.updateMenu(
                                          menu.id!,
                                          name,
                                          menu.kategori,
                                          description,
                                          price,
                                          stock,
                                        );
                                      },
                                    ),
                                  );
                                },
                                onDelete: () {
                                  menuController.deleteMenu(menu.id!);
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                          child: MenuCard(
                            name: menu.nama,
                            description: menu.deskripsi,
                            price: menu.harga,
                            stock: menu.stok,
                            icon: _getIconForCategory(menu.kategori),
                            onAddToOrder: () {
                              final OrdersController ordersController =
                                  Get.find<OrdersController>();
                              ordersController.addToOrder(menu);
                              Get.snackbar(
                                'Success',
                                '${menu.nama} added to cart',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
