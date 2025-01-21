import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/pages_controller/orders_controller.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrdersController ordersController = Get.find<OrdersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Obx(
        () => ordersController.ordersList.isEmpty
            ? const Center(
                child: Text('No orders yet'),
              )
            : ListView.builder(
                itemCount: ordersController.ordersList.length,
                itemBuilder: (context, index) {
                  final order = ordersController.ordersList[index];
                  return ListTile(
                    title: Text(order.menuName),
                    subtitle: Text('Quantity: ${order.quantity}'),
                    trailing: Text(
                      'Rp ${(order.price * order.quantity).toStringAsFixed(2)}',
                    ),
                    leading: IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        ordersController.removeOrder(order.menuId);
                        if (order.quantity > 1) {
                          Get.snackbar(
                            'Quantity Reduced',
                            'Quantity of ${order.menuName} has been reduced',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                          );
                        } else {
                          Get.snackbar(
                            'Item Removed',
                            '${order.menuName} has been removed from the order',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          padding: const EdgeInsets.all(16),
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: Rp ${ordersController.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: ordersController.ordersList.isEmpty
                    ? null
                    : () async {
                        // Execute checkout logic
                        await ordersController.checkout();
                        Get.snackbar(
                          'Checkout Successful',
                          'Your order has been processed!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
