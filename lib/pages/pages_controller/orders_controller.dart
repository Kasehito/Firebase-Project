import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages_models/menu_model.dart';
import '../pages_models/orders_model.dart';
import '../../services/notification_service.dart';

class OrdersController extends GetxController {
  final RxList<OrderModel> ordersList = <OrderModel>[].obs;
  final RxList<QueryDocumentSnapshot> orderHistoryDocs =
      <QueryDocumentSnapshot>[].obs;
  final Rx<DocumentSnapshot?> lastDocument = Rx<DocumentSnapshot?>(null);
  final RxBool isLoadingMore = false.obs;
  final int limitPerPage = 10;
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

  @override
  void onClose() {
    super.onClose();
  }

  void listenToOrders() {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      _firestore
          .collection('users')
          .doc(userId)
          .collection('menu')
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
            .collection('menu')
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
    int retryCount = 0;
    const maxRetries = 3;
    const timeout = Duration(seconds: 10);

    while (retryCount < maxRetries) {
      try {
        final userId = _auth.currentUser?.uid;
        if (userId == null) {
          Get.snackbar('Error', 'Please login to add items to menu');
          return;
        }

        // Use timeout for the entire operation
        final result = await Future.any([
          _processOrder(userId, menu),
          Future.delayed(timeout)
              .then((_) => throw TimeoutException('Operation timed out')),
        ]);

        // If successful, show notification and return
        await _notificationService.showLocalNotification(
          title: 'Added to Menu',
          body: '${menu.nama} has been added',
        );
        return;
      } on TimeoutException {
        retryCount++;
        if (retryCount >= maxRetries) {
          Get.snackbar(
            'Error',
            'Operation timed out. Please try again later',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;
        }
        // Wait before retrying
        await Future.delayed(Duration(seconds: 1 * retryCount));
        continue;
      } catch (e) {
        print('Error adding to order: $e');
        Get.snackbar(
          'Error',
          'Failed to add item to menu. Please try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        break;
      }
    }
  }

  Future<void> _processOrder(String userId, MenuModel menu) async {
    // Check stock first
    final menuDoc = await _firestore.collection('menu').doc(menu.id).get();
    if (!menuDoc.exists) {
      throw Exception('Menu item not found');
    }

    final currentStock = menuDoc.data()?['stok'] as int;
    if (currentStock <= 0) {
      throw Exception('Item out of stock');
    }

    // Reference to user's menu collection
    final userMenuRef =
        _firestore.collection('users').doc(userId).collection('menu');

    // Start a transaction
    return _firestore.runTransaction((transaction) async {
      final existingOrderQuery =
          await userMenuRef.where('menuId', isEqualTo: menu.id).get();

      if (existingOrderQuery.docs.isNotEmpty) {
        final existingDoc = existingOrderQuery.docs.first;
        final currentQuantity = existingDoc.data()['quantity'] as int;

        transaction.update(userMenuRef.doc(existingDoc.id), {
          'quantity': currentQuantity + 1,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        final newOrderRef = userMenuRef.doc();
        transaction.set(newOrderRef, {
          'menuId': menu.id,
          'menuName': menu.nama,
          'quantity': 1,
          'price': menu.harga,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      transaction.update(
        _firestore.collection('menu').doc(menu.id),
        {'stok': FieldValue.increment(-1)},
      );
    }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw TimeoutException('Transaction timed out');
      },
    );
  }

  Future<void> removeOrder(String menuId) async {
    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final userId = _auth.currentUser?.uid;
        if (userId == null) return;

        final userMenuRef =
            _firestore.collection('users').doc(userId).collection('menu');
        final orderQuery =
            await userMenuRef.where('menuId', isEqualTo: menuId).get();

        if (orderQuery.docs.isNotEmpty) {
          final orderDoc = orderQuery.docs.first;
          final currentQuantity = orderDoc.data()['quantity'] as int;
          final menuName = orderDoc.data()['menuName'] as String;

          // Start transaction with timeout
          await _firestore.runTransaction((transaction) async {
            if (currentQuantity > 1) {
              transaction.update(userMenuRef.doc(orderDoc.id), {
                'quantity': currentQuantity - 1,
                'updatedAt': FieldValue.serverTimestamp(),
              });
            } else {
              transaction.delete(orderDoc.reference);
            }

            transaction.update(
              _firestore.collection('menu').doc(menuId),
              {'stok': FieldValue.increment(1)},
            );
          }).timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException('Transaction timed out');
            },
          );

          await _notificationService.showLocalNotification(
            title: 'Menu Updated',
            body: currentQuantity > 1
                ? 'Decreased quantity of $menuName'
                : '$menuName removed from menu',
          );
          return; // Success - exit the retry loop
        }
      } on TimeoutException {
        retryCount++;
        if (retryCount >= maxRetries) {
          Get.snackbar(
            'Error',
            'Operation timed out. Please try again later',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;
        }
        // Wait before retrying
        await Future.delayed(Duration(seconds: 1 * retryCount));
        continue;
      } catch (e) {
        print('Error removing from order: $e');
        Get.snackbar(
          'Error',
          'Failed to remove item from menu',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        break;
      }
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
      final userMenuRef =
          _firestore.collection('users').doc(userId).collection('menu');

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

  Future<void> loadInitialOrderHistory() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orderHistory')
          .orderBy('createdAt', descending: true)
          .limit(limitPerPage)
          .get();

      orderHistoryDocs.value = querySnapshot.docs;
      lastDocument.value =
          querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
    } catch (e) {
      print('Error loading initial order history: $e');
    }
  }

  Future<void> loadMoreOrderHistory() async {
    if (isLoadingMore.value || lastDocument.value == null) return;

    try {
      isLoadingMore.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orderHistory')
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument.value!)
          .limit(limitPerPage)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        orderHistoryDocs.addAll(querySnapshot.docs);
        lastDocument.value = querySnapshot.docs.last;
      }
    } catch (e) {
      print('Error loading more order history: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void deleteOrder(String orderId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      Get.snackbar(
        'Error',
        'User not authenticated',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _firestore
        .collection('users')
        .doc(userId)
        .collection('orderHistory')
        .doc(orderId)
        .delete()
        .then((_) => Get.snackbar(
              'Success',
              'Order deleted successfully',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            ))
        .catchError((error) {
      Get.snackbar(
        'Error',
        'Failed to delete order',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    });
  }

  void deleteAllOrders() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      Get.snackbar(
        'Error',
        'User not authenticated',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    _firestore
        .collection('users')
        .doc(userId)
        .collection('orderHistory')
        .get()
        .then((snapshot) {
      final batch = _firestore.batch();
      for (DocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      return batch.commit();
    }).then((_) {
      Get.snackbar(
        'Success',
        'All orders deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }).catchError((error) {
      print('Error deleting all orders: $error');
      Get.snackbar(
        'Error',
        'Failed to delete orders',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    });
  }
}
