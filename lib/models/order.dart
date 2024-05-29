import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_sphere_bd/models/order_product.dart';
import 'package:game_sphere_bd/screens/payment_screen.dart';

class Order {
  final String orderId;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final String paymentMethod;
  final String name;
  final List<OrderProduct> products; // List of OrderProduct

  Order({
    required this.orderId,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.paymentMethod,
    required this.name,
    required this.products, // Include products in the constructor
  });

  factory Order.fromFirestore(String orderId, Map<String, dynamic> data) {
    return Order(
      orderId: orderId,
      totalAmount: (data['totalAmount'] as num).toDouble(),
      status: data['status'],
      orderDate: (data['orderTime'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] ?? 'Not available',
      name: data['name'],
      products: (data['items'] as List<dynamic>).map((itemData) {
        return OrderProduct.fromMap(itemData as Map<String, dynamic>);
      }).toList(),
    );
  }
}
