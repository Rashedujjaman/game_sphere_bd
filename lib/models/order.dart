import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_sphere_bd/models/order_product.dart';

class Order {
  final String orderId;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final String paymentMethod;
  final String name;
  final List<OrderProduct> products; // List of OrderProduct
  final String email;
  final String mobile;
  final double adjustedTotal;
  final double discount;
  final int earnedLoyaltyPoints;

  Order({
    required this.orderId,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.paymentMethod,
    required this.name,
    required this.products,
    required this.email,
    required this.mobile,
    required this.adjustedTotal,
    required this.discount,
    required this.earnedLoyaltyPoints,
  });

  factory Order.fromFirestore(String orderId, Map<String, dynamic> data) {
    return Order(
      orderId: orderId,
      totalAmount: (data['totalAmount'] as num).toDouble(),
      status: data['status'],
      orderDate: (data['orderTime'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] ?? 'Not available',
      name: data['name'],
      email: data['email'],
      mobile: data['mobile'],
      adjustedTotal: (data['adjustedTotal'] as num).toDouble(),
      discount: (data['discount'] as num).toDouble(),
      earnedLoyaltyPoints: data['earnedLoyaltyPoints'],
      products: (data['items'] as List<dynamic>).map((itemData) {
        return OrderProduct.fromMap(itemData as Map<String, dynamic>);
      }).toList(),
    );
  }
}
