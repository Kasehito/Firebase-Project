import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages_models/menu_model.dart';
import '../pages_models/orders_model.dart';

class OrdersController extends GetxController {
  final RxList<OrderModel> ordersList = <OrderModel>[].obs;

  void addToOrder(MenuModel menu) {
    final existingOrderIndex =
        ordersList.indexWhere((order) => order.menuId == menu.id);

    if (existingOrderIndex != -1) {
      OrderModel existingOrder = ordersList[existingOrderIndex];
      ordersList[existingOrderIndex] = OrderModel(
        id: existingOrder.id,
        menuId: menu.id!,
        menuName: menu.nama,
        quantity: existingOrder.quantity + 1,
        price: menu.harga,
        createdAt: DateTime.now(),
      );
    } else {
      ordersList.add(OrderModel(
        menuId: menu.id!,
        menuName: menu.nama,
        quantity: 1,
        price: menu.harga,
        createdAt: DateTime.now(),
      ));
    }
  }

  void removeOrder(String menuId) {
    final existingOrderIndex =
        ordersList.indexWhere((order) => order.menuId == menuId);
    if (existingOrderIndex != -1) {
      final existingOrder = ordersList[existingOrderIndex];
      if (existingOrder.quantity > 1) {
        ordersList[existingOrderIndex] = OrderModel(
          id: existingOrder.id,
          menuId: existingOrder.menuId,
          menuName: existingOrder.menuName,
          quantity: existingOrder.quantity - 1,
          price: existingOrder.price,
          createdAt: existingOrder.createdAt,
        );
      } else {
        ordersList.removeAt(existingOrderIndex);
      }
    }
  }

  double get totalAmount {
    return ordersList.fold(
        0, (sum, order) => sum + (order.price * order.quantity));
  }

  // Method for handling checkout
  Future<void> checkout() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Looping untuk setiap pesanan yang ada
    for (var order in ordersList) {
      final menuDoc = _firestore.collection('menus').doc(order.menuId);

      try {
        // Mengambil data menu berdasarkan ID
        DocumentSnapshot docSnapshot = await menuDoc.get();
        if (docSnapshot.exists) {
          final currentStok = docSnapshot['stok'];

          if (currentStok >= order.quantity) {
            // Jika stok cukup, mengurangi stok di Firestore
            final updatedStok = currentStok - order.quantity;

            await menuDoc.update({'stok': updatedStok});

            // Menampilkan pesan setelah stok berhasil diupdate
            print(
                'Stok menu ${order.menuName} berhasil diupdate: $updatedStok');
          } else {
            // Jika stok tidak cukup
            Get.snackbar(
              'Out of Stock',
              'Menu ${order.menuName} tidak cukup stok!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          // Jika menu tidak ditemukan
          print('Menu tidak ditemukan: ${order.menuId}');
        }
      } catch (e) {
        // Jika ada error
        print('Error saat mengambil atau mengupdate data menu: $e');
      }
    }

    // Hapus semua order setelah checkout berhasil
    ordersList.clear();
    print('Checkout selesai, semua item telah dihapus.');
  }
}
