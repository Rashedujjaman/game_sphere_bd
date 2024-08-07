import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:game_sphere_bd/models/cart_item.dart';
import 'package:game_sphere_bd/models/order_product.dart';
// ignore: library_prefixes
import 'package:game_sphere_bd/models/order.dart' as myOrder;
import 'package:game_sphere_bd/screens/order_invoice.dart';
import 'package:game_sphere_bd/widgets/payment_cart_item_card_widget.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:math';
import 'package:game_sphere_bd/constants.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;
  final String userName;
  final String userMobile;
  final String userEmail;
  final int rewardPoint;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.cartItems,
    required this.userName,
    required this.userEmail,
    required this.rewardPoint,
    required this.userMobile,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  double get totalAmount => widget.totalAmount;
  List<CartItem> get cartItems => widget.cartItems;
  // Create a list of OrderProduct objects from cartItems
  final List<OrderProduct> orderProducts = [];

  late String userName = widget.userName;
  late String userEmail = widget.userEmail;
  late String userMobile = widget.userMobile;
  late String orderId;
  late String transactionId = 'N/A';
  late String paymentMethod = 'Redeem Points';
  late String validId = 'N/A';

  late int loyaltyPointsBalance = widget.rewardPoint;
  bool useLoyaltyPoints = false;
  int earnedLoyaltyPoints = 0;
  int usedLoyaltyPoints = 0;
  int remainingLoyaltyPoints = 0;
  double adjustedTotal = 0;
  double discount = 0;

  // double get adjustedTotal =>
  //     useLoyaltyPoints ? totalAmount - loyaltyPointsBalance * .1 : totalAmount;

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
    userEmail = widget.userEmail;
    userMobile = widget.userMobile;
    earnedLoyaltyPoints = (totalAmount * 0.1).toInt();
    _calculateAdjustedAmount();
  }

//Calculate the adjusted amount based on the loyalty points
  void _calculateAdjustedAmount() {
    setState(() {
      if (useLoyaltyPoints) {
        final maxDiscount = loyaltyPointsBalance * 0.1;
        if (totalAmount <= maxDiscount) {
          adjustedTotal = 0;
          discount = totalAmount;
          usedLoyaltyPoints = (discount * 10).toInt();
          remainingLoyaltyPoints =
              loyaltyPointsBalance - usedLoyaltyPoints + earnedLoyaltyPoints;
        } else {
          adjustedTotal = totalAmount - maxDiscount;
          usedLoyaltyPoints = loyaltyPointsBalance;
          remainingLoyaltyPoints = earnedLoyaltyPoints;
          discount = maxDiscount;
        }
      } else {
        adjustedTotal = totalAmount;
        usedLoyaltyPoints = 0;
        remainingLoyaltyPoints = loyaltyPointsBalance + earnedLoyaltyPoints;
        discount = 0;
      }
    });
  }

  //Creating Order Number Algorithm
  Future<String> generateOrderNumber() async {
    // Reference to Firestore collection for order numbers
    CollectionReference ordersRef =
        FirebaseFirestore.instance.collection('order_numbers');

    // Transaction to ensure atomicity
    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document where counter is stored
      DocumentReference counterRef = ordersRef.doc('counter');
      DocumentSnapshot counterSnapshot = await transaction.get(counterRef);

      // Get the current counter value
      int currentCounter = 0;
      if (counterSnapshot.exists) {
        currentCounter = counterSnapshot.get('current_counter');
      }

      // Generate an order number using current timestamp and counter
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      String orderNumber = (timestamp % 100000000).toString().padLeft(8, '0') +
          (currentCounter % 1000).toString().padLeft(3, '0');

      // Check for uniqueness
      bool isUnique = false;
      while (!isUnique) {
        // Check if order number already exists
        QuerySnapshot existingOrders =
            await ordersRef.where('order_number', isEqualTo: orderNumber).get();
        if (existingOrders.docs.isEmpty) {
          // Order number is unique
          isUnique = true;
        } else {
          // Order number is not unique, increment the counter and regenerate
          currentCounter++;
          orderNumber = (timestamp % 100000000).toString().padLeft(8, '0') +
              (currentCounter % 1000).toString().padLeft(3, '0');
        }
      }

      // Store the new order number and increment the counter
      transaction
          .set(ordersRef.doc(orderNumber), {'order_number': orderNumber});
      transaction.update(counterRef, {'current_counter': currentCounter + 1});

      return orderNumber;
    });
  }

  void _showSuccessMessage(String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
      messageText: Center(
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ).show(context);
  }

  void _showErrorMessage(String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      messageText: Center(
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
      icon: const Icon(Icons.error, color: Colors.white),
    ).show(context);
  }

  //Create a list of products item from cartItems
  Future<void> _createOrder() async {
    final user = Constants.currentUser;

    if (user != null) {
      for (var cartItem in cartItems) {
        final productId = cartItem.productId;
        final variantId = cartItem.variantId;

        // Fetch the product document
        final productDoc = await FirebaseFirestore.instance
            .collection('products')
            .doc(cartItem.productId)
            .get();

        if (productDoc.exists && productDoc.data()!.containsKey('variant')) {
          final productData = productDoc.data() as Map<String, dynamic>;
          final variantData = productData['variant'][cartItem.variantId];

          if (variantData != null) {
            final voucherCodes =
                (variantData['voucherCodes'] as List<dynamic>).cast<String>();

            if (voucherCodes.length >= cartItem.quantity) {
              // Get the required number of voucher codes
              List<String> selectedVoucherCodes =
                  voucherCodes.take(cartItem.quantity).toList();

              // Remove the voucher codes from Firestore
              await FirebaseFirestore.instance
                  .collection('products')
                  .doc(productId)
                  .update({
                'variant.$variantId.voucherCodes':
                    FieldValue.arrayRemove(selectedVoucherCodes),
              });
              // Create a single OrderProduct instance for the entire quantity
              orderProducts.add(
                OrderProduct(
                  productName: cartItem.productName,
                  productId: cartItem.productId,
                  variantId: cartItem.variantId,
                  variantName: cartItem.variantName,
                  quantity: cartItem.quantity,
                  price: cartItem.price,
                  amount: cartItem.variantAmount,
                  voucherCode: selectedVoucherCodes
                      .join(', '), // Combine the voucher codes
                  imageUrl: cartItem.imageUrl,
                ),
              );
            } else {
              // No enough voucher codes available for this variant
              _showErrorMessage(
                  'No more voucher codes available for this variant: ${cartItem.variantName}');
              return;
            }
          }
        } else {
          // Handle case where product or variant is not found
          _showErrorMessage('Error processing order. Please try again.');
          return; // Exit the function if a product or variant is not found
        }
      }
      orderId = await generateOrderNumber();
      //prepare order details
      final orderRef = {
        'uid': user.uid,
        'transactionId': transactionId,
        'totalAmount': totalAmount,
        'adjustedTotal': adjustedTotal,
        'paymentMethod': paymentMethod,
        'status': 'Paid',
        'items': orderProducts.map((item) => item.toJson()).toList(),
        'valId': validId,
        'orderTime': Timestamp.fromDate(DateTime.now()),
        'name': userName,
        'email': userEmail,
        'mobile': userMobile,
        'earnedLoyaltyPoints': earnedLoyaltyPoints,
        'usedLoyaltyPoints': usedLoyaltyPoints,
        'discount': discount,
      };

      // Store order details in Firestore
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .set(orderRef);

      // // Create Order object from the saved document
      final order = myOrder.Order.fromFirestore(
        orderId,
        orderRef,
      );

      // Clear the cart after successful payment (optional)
      await FirebaseFirestore.instance
          .collection('carts')
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Update the user's loyalty points balance
      await FirebaseFirestore.instance
          .collection('Customers')
          .doc(user.uid)
          .update({'rewardPoint': remainingLoyaltyPoints});

      // Show the order invoice screen
      if (mounted) {
        //Clear cart items locally
        cartItems.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderInvoice(order: order)),
        );
      }
    }
  }

  //payment gateway integration and order creation function.
  Future<void> _submitOrder() async {
    setState(() {
      _isLoading = true;
    });

    if (adjustedTotal == 0) {
      await _createOrder();
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String generateTranId() {
      final now = DateTime.now();
      final timestamp = now.millisecondsSinceEpoch.toString();
      final random = Random().nextInt(100000).toString().padLeft(5, '0');
      return '$timestamp-$random';
    }

    try {
      transactionId = generateTranId();

      if (adjustedTotal > 0) {
        // 1. Prepare SSLCommerz Payment Request
        final paymentRequest = SSLCommerzInitialization(
          store_id: "janan6655fbb5ebcc3",
          store_passwd: "janan6655fbb5ebcc3@ssl",
          total_amount: adjustedTotal,
          currency: SSLCurrencyType.BDT,
          tran_id: transactionId,
          multi_card_name: "visa,master,amex,mobilewallet",
          product_category: 'Game',
          sdkType: SSLCSdkType.TESTBOX,
          ipn_url: "https://handleipn-2gh5slju2a-uc.a.run.app",
        );

        // 2. Initiate SSLCommerz Payment
        final Sslcommerz sslcommerz = Sslcommerz(initializer: paymentRequest);
        final response = await sslcommerz.payNow();
        print(response.toJson());

        // 3. Handle Response
        if (response.status == "VALID" || response.status == "VALIDATED") {
          _showSuccessMessage('Payment successful');
          validId = response.valId ?? 'N/A';
          paymentMethod = response.cardType ?? 'Redeem Points';
          await _createOrder();
        } else if (response.status == "INVALID_TRANSACTION") {
          _showErrorMessage(
              'Payment failed: ${response.riskTitle ?? 'unknown error'}');
          print(response.toJson());
        } else {
          _showErrorMessage('Payment cancelled');
        }
      }
    } catch (e) {
      _showErrorMessage('Error processing payment: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      return PaymentCartItemCardWidget(
                          cartItem: widget.cartItems[index]);
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.cyan[100],
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: const Center(
                          child: Text('Order Summary',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        child: Column(
                          children: [
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              dense: true,
                              title: const Text('Name:'),
                              trailing: Text(userName),
                            ),
                            Material(
                              child: ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                dense: true,
                                title: const Text('Email:'),
                                trailing: Text(userEmail),
                              ),
                            ),
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              dense: true,
                              title: const Text('Total Amount:'),
                              trailing:
                                  Text('${totalAmount.toStringAsFixed(0)} ৳'),
                            ),
                            if (loyaltyPointsBalance > 0) ...[
                              Material(
                                child: SwitchListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  dense: true,
                                  title: Text(
                                      'Use Loyalty Points (Available: $loyaltyPointsBalance )'),
                                  value: useLoyaltyPoints,
                                  onChanged: (value) {
                                    setState(() {
                                      useLoyaltyPoints = value;
                                      _calculateAdjustedAmount();
                                    });
                                  },
                                ),
                              ),
                              if (useLoyaltyPoints)
                                ListTile(
                                  visualDensity: const VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  dense: true,
                                  title: const Text('Discount: '),
                                  trailing: Text(
                                      '- ${discount.toStringAsFixed(1)} ৳'),
                                ),
                            ],
                            ListTile(
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: -4),
                              dense: true,
                              title:
                                  const Text('Points Earned in this Order: '),
                              trailing:
                                  Text(earnedLoyaltyPoints.toStringAsFixed(0)),
                            ),
                            Material(
                              child: ListTile(
                                titleTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                dense: true,
                                title: const Text('Pay Amount:'),
                                trailing: Text(
                                    '${adjustedTotal.toStringAsFixed(0)} ৳',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      await _submitOrder();
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF62BDBD),
                              ),
                              child: const Text('Pay',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
