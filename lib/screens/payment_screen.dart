import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:game_sphere_bd/models/cart_item.dart';
import 'package:game_sphere_bd/widgets/payment_cart_item_card_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:math';

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
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  double get totalAmount => widget.totalAmount;
  List<CartItem> get cartItems => widget.cartItems;
  bool useLoyaltyPoints = false;
  late int loyaltyPointsBalance = widget.rewardPoint;
  late String userName = widget.userName;
  late String userEmail = widget.userEmail;
  late String userMobile = widget.userMobile;
  late double pointsEarned = totalAmount * 0.1;
  double get adjustedTotal =>
      useLoyaltyPoints ? totalAmount - loyaltyPointsBalance * .1 : totalAmount;

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
    userEmail = widget.userEmail;
    userMobile = widget.userMobile;
    pointsEarned = totalAmount * 0.1;
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

  Future<void> _submitOrder() async {
    setState(() {
      _isLoading = true;
    });

    String generateTranId() {
      final now = DateTime.now();
      final timestamp = now.millisecondsSinceEpoch.toString();
      final random = Random().nextInt(100000).toString().padLeft(5, '0');
      return '$timestamp-$random';
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      final transactionId = generateTranId();

      if (user != null) {
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
          ipn_url: "www.ipnurl.com",
        );

        // 2. Initiate SSLCommerz Payment
        final Sslcommerz sslcommerz = Sslcommerz(initializer: paymentRequest);
        final response = await sslcommerz.payNow();

        // 3. Handle Response
        if (response != null && response.status == "SUCCESS") {
          _showSuccessMessage('Payment successful');

          // Store order details in Firestore
          // Example:
          await FirebaseFirestore.instance.collection('orders').add({
            'uid': user.uid,
            'transaction_id': transactionId,
            'totalAmount': adjustedTotal,
            'status': 'Paid',
            'items': cartItems.map((item) => item.toJson()).toList(),
          });
        } else if (response != null && response.status == "FAILED") {
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

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showErrorMessage('Could not launch URL: $url');
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
      body: Column(
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
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Column(
                    children: [
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        title: const Text('Total Amount:'),
                        trailing: Text('${totalAmount.toStringAsFixed(0)} ৳'),
                      ),
                      if (loyaltyPointsBalance > 0) ...[
                        Material(
                          child: CheckboxListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            dense: true,
                            title: Text(
                                'Use Loyalty Points (Available: $loyaltyPointsBalance )'),
                            value: useLoyaltyPoints,
                            onChanged: (value) {
                              setState(() {
                                useLoyaltyPoints = value ?? false;
                              });
                            },
                          ),
                        ),
                        if (useLoyaltyPoints)
                          ListTile(
                            visualDensity: const VisualDensity(
                                horizontal: 0, vertical: -4),
                            dense: true,
                            title: const Text('Loyalty Points Redeemed:'),
                            trailing: Text('- $loyaltyPointsBalance ৳'),
                          ),
                      ],
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        title: const Text('Final Amount:'),
                        trailing: Text('${adjustedTotal.toStringAsFixed(0)} ৳'),
                      ),
                      Material(
                        child: ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          dense: true,
                          title: const Text('Points Earned: '),
                          trailing: Text(pointsEarned.toStringAsFixed(0)),
                        ),
                      ),
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        title: Text('Name: $userName'),
                      ),
                      ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        title: Text('Email: $userEmail'),
                      ),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                // Disable the button when loading
                                await _submitOrder();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF62BDBD),
                        ),
                        child: const Text('Confirm Payment',
                            style: TextStyle(color: Colors.white)),
                      ),
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
