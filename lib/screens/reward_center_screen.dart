import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_sphere_bd/constants.dart';

class RewardCenterScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RewardCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF62BDBD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Reward Center',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FutureBuilder<DocumentSnapshot>(
            future: _firestore
                .collection('Customers')
                .doc(Constants.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                    color: Colors.white); // Loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final int rewardPoint = snapshot.data!['rewardPoint'] ?? 0;
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Reward Points: $rewardPoint',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'You can redeem your reward points for discounts on your next purchase.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '100 Reward Point = 10 Taka',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Thank you for being a loyal customer!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
