// models/order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? id;
  String menuId;
  String menuName;
  int quantity;
  double price;
  DateTime createdAt;

  OrderModel({
    this.id,
    required this.menuId,
    required this.menuName,
    required this.quantity,
    required this.price,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuId': menuId,
      'menuName': menuName,
      'quantity': quantity,
      'price': price,
      'createdAt': createdAt,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      menuId: json['menuId'],
      menuName: json['menuName'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}