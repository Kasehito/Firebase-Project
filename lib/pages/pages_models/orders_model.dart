import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? id;
  final String menuId;
  final String menuName;
  final int quantity;
  final double price;
  final DateTime createdAt;

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
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      menuId: json['menuId'],
      menuName: json['menuName'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      createdAt: json['createdAt'] is String 
          ? DateTime.parse(json['createdAt'])
          : (json['createdAt'] as Timestamp).toDate(),
    );
  }
}