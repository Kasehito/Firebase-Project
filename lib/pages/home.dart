import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:manganjawa/pages/pages_models/menu_model.dart';
import 'package:manganjawa/pages/pages_controller/menu_controller.dart';
import 'package:manganjawa/widgets/home_container.dart';
import 'package:manganjawa/widgets/category_card.dart';
import 'package:manganjawa/widgets/menu_card.dart';
import 'package:manganjawa/widgets/edit_delete_dialog.dart';
import 'package:manganjawa/widgets/edit_menu_dialog.dart';
import 'package:manganjawa/widgets/add_menu_dialog.dart';

class Home extends StatelessWidget {
  final TableMenuController menuController = Get.put(TableMenuController());

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenuDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange, // Sesuaikan warna sesuai kebutuhan
      ),
      body: HomeContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 709,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 111,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Mangan Jawa',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w700,
                                height: 1.28,
                                letterSpacing: -0.50,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              CategoryCard(
                                color: Color(0xFFF5D4C1),
                                icon: Icons.fastfood,
                                label: 'Makanan',
                              ),
                              SizedBox(width: 16),
                              CategoryCard(
                                color: Color(0xFFFDEBC8),
                                icon: Icons.local_drink,
                                label: 'Minuman',
                              ),
                              SizedBox(width: 16),
                              CategoryCard(
                                color: Color(0xFFD0F1EB),
                                icon: Icons.cake,
                                label: 'Snack',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Food Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w700,
                          height: 1.28,
                          letterSpacing: -0.50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Obx(
                        () => ListView.builder(
                          itemCount: menuController.menuList.length,
                          itemBuilder: (context, index) {
                            final menu = menuController.menuList[index];
                            return GestureDetector(
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
                                          onSave: (name, description, price,
                                              stock) {
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
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: MenuCard(
                                  name: menu.nama,
                                  description: menu.deskripsi,
                                  price: menu.harga,
                                  stock: menu.stok,
                                  icon: _getIconForCategory(menu.kategori),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.fastfood;
      case 'Minuman':
        return Icons.local_drink;
      case 'Snack':
        return Icons.cake;
      default:
        return Icons.fastfood;
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
}
