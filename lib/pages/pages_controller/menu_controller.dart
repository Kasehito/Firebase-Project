import 'dart:io';
import 'package:get/get.dart';

import 'package:manganjawa/pages/pages_models/menu_model.dart';
import 'package:manganjawa/services/menu_service.dart';

class TableMenuController extends GetxController {
  final MenuService _menuService = MenuService();
  final RxList<MenuModel> menuList = <MenuModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToMenuChanges();
  }

  void _listenToMenuChanges() {
    _menuService.getMenus().listen((menus) {
      menuList.value = menus;
    });
  }

  Future<void> addMenu(
    String nama,
    String kategori,
    String deskripsi,
    double harga,
    int stok,
  ) async {
    try {
      isLoading.value = true;
      MenuModel menu = MenuModel(
        nama: nama,
        kategori: kategori,
        deskripsi: deskripsi,
        harga: harga,
        stok: stok,
        createdAt: DateTime.now(),
      );
      await _menuService.addMenu(menu);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMenu(
    String id,
    String nama,
    String kategori,
    String deskripsi,
    double harga,
    int stok,
  ) async {
    try {
      isLoading.value = true;
      MenuModel menu = MenuModel(
        id: id,
        nama: nama,
        kategori: kategori,
        deskripsi: deskripsi,
        harga: harga,
        stok: stok,
        createdAt: DateTime.now(),
      );

      print('Calling updateMenu with ID: $id');

      await _menuService.updateMenu(menu);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMenu(
    String id,
  ) async {
    try {
      isLoading.value = true;
      await _menuService.deleteMenu(id);
    } finally {
      isLoading.value = false;
    }
  }
}
