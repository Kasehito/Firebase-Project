import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages_models/menu_model.dart';
import '../pages_models/orders_model.dart';
import '../../services/notification_service.dart';

class OrdersController extends GetxController {
  final RxList<OrderModel> ordersList = <OrderModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late NotificationService _notificationService;

  @override
  void onInit() async {
    super.onInit();
    try {
      _notificationService = Get.find<NotificationService>();
    } catch (e) {
      _notificationService = Get.put(NotificationService(), permanent: true);
    }
    await _notificationService.initialize();
    loadSavedOrders();
    listenToOrders();
  }

  void listenToOrders() {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      _firestore
          .collection('users')
          .doc(userId)
          .collection('menu')  // Using 'menu' as per your database structure
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          ordersList.value = snapshot.docs
              .map((doc) => OrderModel.fromJson({
                    ...doc.data(),
                    'id': doc.id,
                  }))
              .toList();
        },
        onError: (error) {
          print('Error listening to orders: $error');
        },
      );
    }
  }

  Future<void> loadSavedOrders() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('menu')  // Using 'menu' as per your database structure
            .orderBy('createdAt', descending: true)
            .get();

        ordersList.value = snapshot.docs
            .map((doc) => OrderModel.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList();
      }
    } catch (e) {
      print('Error loading saved orders: $e');
    }
  }

  Future<void> addToOrder(MenuModel menu) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'Please login to add items to menu');
        return;
      }

      // Check stock first
      final menuDoc = await _firestore.collection('menu').doc(menu.id).get();
      if (!menuDoc.exists) {
        Get.snackbar('Error', 'Menu item not found');
        return;
      }

      final currentStock = menuDoc.data()?['stok'] as int;
      if (currentStock <= 0) {
        Get.snackbar('Error', 'Item out of stock');
        return;
      }

      // Reference to user's menu collection
      final userMenuRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('menu');

      // Start a transaction
      await _firestore.runTransaction((transaction) async {
        // Check for existing order
        final existingOrderQuery = await userMenuRef
            .where('menuId', isEqualTo: menu.id)
            .get();

        if (existingOrderQuery.docs.isNotEmpty) {
          // Update existing order
          final existingDoc = existingOrderQuery.docs.first;
          final currentQuantity = existingDoc.data()['quantity'] as int;
          
          await userMenuRef.doc(existingDoc.id).update({
            'quantity': currentQuantity + 1,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Create new order
          await userMenuRef.add({
            'menuId': menu.id,
            'menuName': menu.nama,
            'quantity': 1,
            'price': menu.harga,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        // Update stock
        await _firestore
            .collection('menu')
            .doc(menu.id)
            .update({
          'stok': FieldValue.increment(-1)
        });
      });

      // Show notification
      await _notificationService.showLocalNotification(
        title: 'Added to Menu',
        body: '${menu.nama} has been added',
      );
    } catch (e) {
      print('Error adding to order: $e');
      Get.snackbar('Error', 'Failed to add item to menu');
    }
  }

  Future<void> removeOrder(String menuId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final userMenuRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('menu');

      final orderQuery = await userMenuRef
          .where('menuId', isEqualTo: menuId)
          .get();

      if (orderQuery.docs.isNotEmpty) {
        final orderDoc = orderQuery.docs.first;
        final currentQuantity = orderDoc.data()['quantity'] as int;
        final menuName = orderDoc.data()['menuName'] as String;

        // Start transaction
        await _firestore.runTransaction((transaction) async {
          if (currentQuantity > 1) {
            // Decrease quantity
            await userMenuRef.doc(orderDoc.id).update({
              'quantity': currentQuantity - 1,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          } else {
            // Remove item
            await userMenuRef.doc(orderDoc.id).delete();
          }

          // Update stock
          await _firestore
              .collection('menu')
              .doc(menuId)
              .update({
            'stok': FieldValue.increment(1)
          });
        });

        // Show notification
        await _notificationService.showLocalNotification(
          title: 'Menu Updated',
          body: currentQuantity > 1
              ? 'Decreased quantity of $menuName'
              : '$menuName removed from menu',
        );
      }
    } catch (e) {
      print('Error removing from order: $e');
      Get.snackbar('Error', 'Failed to remove item from menu');
    }
  }

  Future<void> checkout() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'Please login to checkout');
        return;
      }

      if (ordersList.isEmpty) {
        Get.snackbar('Error', 'Menu is empty');
        return;
      }

      // Start batch write
      final batch = _firestore.batch();
      final userMenuRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('menu');
      
      // Create order history
      final orderHistoryRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('orderHistory')
          .doc();

      batch.set(orderHistoryRef, {
        'orderId': orderHistoryRef.id,
        'items': ordersList.map((item) => item.toJson()).toList(),
        'totalAmount': totalAmount,
        'status': 'completed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Delete all items in menu
      final menuItems = await userMenuRef.get();
      for (var doc in menuItems.docs) {
        batch.delete(doc.reference);
      }

      // Commit the batch
      await batch.commit();

      // Clear local list
      ordersList.clear();

      // Show notification
      await _notificationService.showLocalNotification(
        title: 'Order Completed',
        body: 'Your order has been successfully placed!',
      );

      Get.snackbar('Success', 'Order placed successfully');
    } catch (e) {
      print('Error during checkout: $e');
      Get.snackbar('Error', 'Checkout failed');
    }
  }

  double? get totalAmount {
    if (ordersList.isEmpty) return null;
    return ordersList.fold<double>(
        0, (sum, order) => sum + (order.price * order.quantity));
  }
}