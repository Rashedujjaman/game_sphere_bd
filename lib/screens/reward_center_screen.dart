import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardCenterScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user = FirebaseAuth.instance.currentUser;

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
            future: _firestore.collection('Customers').doc(_user!.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                    color: Colors.white); // Loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final int rewardPoint = snapshot.data!['rewardPoint'] ?? 0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Congratulations!',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 100),
                    Text(
                      'You have achieved $rewardPoint rewards from your previous purchases.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 150),
                    // const Icon(
                    //   Icons.padding_sharp,
                    //   color: Colors.white,
                    //   size: 24,
                    // ),
                    const Text(
                      'You May Redeem Your Points For Discounts On Your Next Purchase!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
