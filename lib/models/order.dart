import 'package:game_sphere_bd/models/order_product.dart';

class Order {
  final String orderId;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final String paymentMethod;
  final String name;
  final String voucherCode;
  final String image;
  final String variant;
  final List<OrderProduct> products; // List of OrderProduct

  Order({
    required this.orderId,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.paymentMethod,
    required this.name,
    required this.voucherCode,
    required this.image,
    required this.variant,
    required this.products, // Include products in the constructor
  });
}
