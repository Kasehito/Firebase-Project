import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages_models/menu_model.dart';
import '../pages_models/orders_model.dart';
import '../../services/notification_service.dart';

class OrdersController extends GetxController {
  final RxList<OrderModel> ordersList = <OrderModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late NotificationService _notificationService;

  @override
  void onInit() {
    super.onInit();
    // Try to find NotificationService, if not found, create new instance
    try {
      _notificationService = Get.find<NotificationService>();
    } catch (e) {
      _notificationService = Get.put(NotificationService(), permanent: true);
    }
  }

  Future<void> addToOrder(MenuModel menu) async {
    try {
      final menuDoc = await _firestore.collection('menu').doc(menu.id).get();
      
      if (!menuDoc.exists) {
        Get.snackbar(
          'Error',
          'Menu item not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final currentStock = menuDoc.data()?['stok'] as int;
      
      final existingOrderIndex = ordersList.indexWhere((order) => order.menuId == menu.id);
      final requestedQuantity = existingOrderIndex != -1 ? 
          ordersList[existingOrderIndex].quantity + 1 : 1;
          
      if (currentStock < requestedQuantity) {
        Get.snackbar(
          'Out of Stock',
          'Not enough stock available for ${menu.nama}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Update the orders list
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

      // Update stock in Firestore
      await _firestore.collection('menu').doc(menu.id).update({
        'stok': currentStock - 1
      });

      // Show notification using try-catch to handle potential notification errors
      try {
        await _notificationService.showLocalNotification(
          title: 'Added to Cart',
          body: '${menu.nama} has been added to your cart',
        );
      } catch (notificationError) {
        print('Notification error: $notificationError');
        // Continue execution even if notification fails
      }

      Get.snackbar(
        'Success',
        '${menu.nama} added to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } catch (e) {
      print('Error adding to order: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> removeOrder(String menuId) async {
    try {
      final existingOrderIndex = ordersList.indexWhere((order) => order.menuId == menuId);
      
      if (existingOrderIndex != -1) {
        final existingOrder = ordersList[existingOrderIndex];
        
        // Update stock in Firestore (increase by 1)
        await _firestore.collection('menu').doc(menuId).update({
          'stok': FieldValue.increment(1)
        });

        if (existingOrder.quantity > 1) {
          ordersList[existingOrderIndex] = OrderModel(
            id: existingOrder.id,
            menuId: existingOrder.menuId,
            menuName: existingOrder.menuName,
            quantity: existingOrder.quantity - 1,
            price: existingOrder.price,
            createdAt: existingOrder.createdAt,
          );
          
          // Show notification for reducing quantity
          try {
            await _notificationService.showLocalNotification(
              title: 'Cart Updated',
              body: 'Reduced quantity of ${existingOrder.menuName}',
            );
          } catch (notificationError) {
            print('Notification error: $notificationError');
          }
        } else {
          ordersList.removeAt(existingOrderIndex);
          
          // Show notification for removing item
          try {
            await _notificationService.showLocalNotification(
              title: 'Item Removed',
              body: '${existingOrder.menuName} removed from cart',
            );
          } catch (notificationError) {
            print('Notification error: $notificationError');
          }
        }
      }
    } catch (e) {
      print('Error removing from order: $e');
      Get.snackbar(
        'Error',
        'Failed to remove item from order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  double get totalAmount {
    return ordersList.fold(0, (sum, order) => sum + (order.price * order.quantity));
  }

  Future<void> checkout() async {
    try {
      // Use a batch to perform all updates atomically
      final batch = _firestore.batch();
      bool hasError = false;

      // Check stock availability for all items first
      for (var order in ordersList) {
        final menuDoc = await _firestore.collection('menu').doc(order.menuId).get();
        
        if (!menuDoc.exists) {
          Get.snackbar(
            'Error',
            'Menu ${order.menuName} not found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          hasError = true;
          break;
        }

        final currentStock = menuDoc.data()?['stok'] as int;
        if (currentStock < order.quantity) {
          Get.snackbar(
            'Out of Stock',
            'Not enough stock for ${order.menuName}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          hasError = true;
          break;
        }
      }

      if (!hasError) {
        // Process all orders
        for (var order in ordersList) {
          final menuRef = _firestore.collection('menu').doc(order.menuId);
          batch.update(menuRef, {
            'stok': FieldValue.increment(-order.quantity)
          });
        }

        // Commit the batch
        await batch.commit();
        
        // Show checkout completion notification
        try {
          await _notificationService.showLocalNotification(
            title: 'Order Completed',
            body: 'Your order has been successfully placed!',
          );
        } catch (notificationError) {
          print('Notification error: $notificationError');
        }
        
        // Clear orders after successful checkout
        ordersList.clear();
        
        Get.snackbar(
          'Success',
          'Checkout completed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error during checkout: $e');
      Get.snackbar(
        'Error',
        'Failed to complete checkout',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}