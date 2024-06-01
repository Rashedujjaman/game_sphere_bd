import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/order.dart'; // Import your Order model
import 'package:game_sphere_bd/models/order_product.dart';
import 'package:game_sphere_bd/screens/home_screen.dart';
import 'package:game_sphere_bd/screens/order_screen.dart';
import 'package:game_sphere_bd/screens/rate_order_screen.dart';
import 'package:intl/intl.dart'; // Import your OrderProduct model

class OrderInvoice extends StatelessWidget {
  final Order order;
  OrderInvoice({required this.order});

  @override
  Widget build(BuildContext context) {
    final discount = order.discount;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF62BDBD),
          elevation: 1,
          title: const Text(
            'Order Invoice',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTile(
                collapsedTextColor: const Color(0xFF62BDBD),
                iconColor: const Color(0xFF62BDBD),
                title: const Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                initiallyExpanded: true,
                children: [
                  Container(
                    // height: 150,
                    transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(1, 0),
                        ),
                      ],
                      border: Border.all(
                          color: const Color.fromARGB(255, 131, 111, 111),
                          width: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ref No: ${order.orderId}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Date & Time: ${DateFormat().format(order.orderDate)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total: ${order.totalAmount} ৳',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        if (discount > 0) ...[
                          Text(
                            'Discount: ${order.discount} ৳',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Paid: ${order.adjustedTotal} ৳',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          'Status: ${order.status}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Earned Loyalty Points: ${order.earnedLoyaltyPoints}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Payment Method: ${order.paymentMethod}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Name: ${order.name}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Email: ${order.email}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Mobile: ${order.mobile}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Items:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              //Card for each Item
              Expanded(
                child: ListView.builder(
                  itemCount: order.products.length,
                  itemBuilder: (context, index) {
                    final orderProduct = order.products[index];
                    return Card(
                      color: Colors.cyan[50],
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: orderProduct.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    orderProduct.productName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Variant: ${orderProduct.amount} ${orderProduct.variantName}\nPrice: ${orderProduct.price} ৳\nQty: ${orderProduct.quantity}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RateOrderItemScreen(
                                                orderProduct: orderProduct,
                                                orderId: order.orderId),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Rate',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.qr_code, size: 30),
                                      onPressed: () {
                                        _showVoucherCodeDialog(
                                            context, orderProduct);
                                      },
                                    ),
                                    const Text(
                                      'Tap QR for Code',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(bottom: 10, left: 100, right: 100),
          child: ElevatedButton(
            onPressed: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF62BDBD),
              padding: const EdgeInsets.symmetric(vertical: 10),
              side: const BorderSide(color: Color(0xFF62BDBD)),
            ),
            child: const Text('Close'),
          ),
        ));
  }

  void _showVoucherCodeDialog(BuildContext context, OrderProduct product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Voucher Code'),
          content: Text(product.voucherCode),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
