import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/order.dart'; // Import your Order model

class SuccessPage extends StatelessWidget {
  final Order
      order; // Assuming you have an Order model to represent order details

  SuccessPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.orderId}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Date: ${order.orderDate}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Total Amount: ${order.totalAmount} ৳',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Delivery of Voucher Code: ${order.voucherCode}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            const Text(
              'Product Details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: order.products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(order.products[index].productName),
                    subtitle:
                        Text('Quantity: ${order.products[index].quantity}'),
                    trailing: Text('${order.products[index].price} ৳'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                    context,
                    ModalRoute.withName(
                        '/')); // Navigate back to the home screen
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
