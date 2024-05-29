import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/order_product.dart';
import 'package:intl/intl.dart';
import 'package:game_sphere_bd/models/order.dart';

class OrderHistoryScreen extends StatelessWidget {
  final List<Order> orders = [
    Order(
      orderId: '1',
      name: 'Garena Shell',
      totalAmount: 1920.0,
      status: 'Delivered',
      orderDate: DateTime.now(),
      paymentMethod: 'Bkash',
      products: [
        OrderProduct(
          productName: 'Garena Shell',
          productId: '1',
          variantId: '1',
          variantName: 'Shell',
          amount: 1300,
          imageUrl: 'assets/images/garena.png',
          voucherCode: '65242458125456598',
          quantity: 1,
          price: 1920.0,
        ),
      ],
    ),
  ];
  // Add more orders here

  // OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF62BDBD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        title: const Text(
          'Order History',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Order Number: ${order.orderId}'),
              subtitle: Text(
                  'Total Amount: ${order.totalAmount.toStringAsFixed(0)} BDT'),
              trailing: Text('Status: ${order.status}'),
              onTap: () {
                // Navigate to order details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(order: order),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().add_jms().format(order.orderDate);

    return Scaffold(
      backgroundColor: const Color(0xFF62BDBD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(order.products[0].imageUrl),
                        fit: BoxFit.fitWidth),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Text(
                  'Order ID: ${order.orderId}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Date: $formattedDate',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Payment Method: ${order.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Variant: ${order.products[0].variantName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Total Amount: ${order.totalAmount.toStringAsFixed(2)} BDT',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Status: ${order.status}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Payment Method: ${order.paymentMethod}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'code: ${order.products[0].voucherCode}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                // Display Order Products
                const Text(
                  'Products:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: order.products.length,
                  itemBuilder: (context, index) {
                    final product = order.products[index];
                    return ListTile(
                      title: Text(product.productName),
                      subtitle: Text('Quantity: ${product.quantity}'),
                      trailing: Text('${product.price} BDT'),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
