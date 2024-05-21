import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Order {
  final String id;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final String paymentMethod;
  final String name;
  final String code;
  final String image;
  final String variant;

  Order({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.paymentMethod,
    required this.name,
    required this.code,
    required this.image,
    required this.variant,
  });
}

class OrderHistoryScreen extends StatelessWidget {
  final List<Order> orders = [
    Order(
      id: '1',
      name: 'Garena Shell',
      image: 'assets/images/garena.png',
      code: '65242458125456598',
      variant: '1300',
      totalAmount: 1920.0,
      status: 'Delivered',
      orderDate: DateTime.now(),
      paymentMethod: 'Bkash',
    ),
    Order(
      id: '2',
      totalAmount: 2000.0,
      status: 'Delivered',
      orderDate: DateTime.now(),
      paymentMethod: 'Rocket',
      name: 'Unipin UC',
      code: '9513574628046379',
      image: 'assets/images/unipin.jpg',
      variant: '1800',
    ),

    Order(
      id: '3',
      totalAmount: 950.0,
      status: 'Delivered',
      orderDate: DateTime.now(),
      paymentMethod: 'Nagad',
      name: 'Republic GG',
      code: '3542698710258961',
      image: 'assets/images/rgg.png',
      variant: '650',
    ),

    // Add more orders here
  ];

  OrderHistoryScreen({Key? key}) : super(key: key);

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
              title: Text('Order Number: ${order.id}'),
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
                //display the image of the product in a container aligned to the left of the order details in a raised button shape
                Container(
                  height: 150,
                  // width: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(order.image), fit: BoxFit.fitWidth),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 10),
                //add a horizontal line to separate the image from the order details
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                Text(
                  'Order ID: ${order.id}',
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
                  'Variant: ${order.variant}',
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
                  'code: ${order.code}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
                // Add more detailed information about the order here
              ],
            ),
          ],
        ),
      ),
    );
  }
}
