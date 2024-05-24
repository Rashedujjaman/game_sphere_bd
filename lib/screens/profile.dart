import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_sphere_bd/screens/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser; // Get the current user
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      // Handle the case where the user is not logged in
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: const Center(
          child: Text('User not logged in'),
        ),
      );
    }

    // Fetch the user's data from Firestore using their UID
    return Scaffold(
      backgroundColor: const Color(0xFF62BDBD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Customers')
            .doc(_user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No user data found'));
          } else {
            // Extract user data from the snapshot
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String name = userData['fullName'] ?? "N/A";
            String email = userData['email'] ?? "N/A";
            String userName = userData['username'] ?? "N/A";
            String mobile = userData['mobileNo'] ?? "N/A";
            int rewardPoint = userData['rewardPoint'] ?? 0;
            String imageUrl = userData['imageUrl'] ?? "";

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                      backgroundColor: imageUrl.isEmpty
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : null,
                      child: imageUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              color: Color(0xFF62BDBD),
                              size: 120,
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Divider(), // A horizontal line for separation
                    const SizedBox(height: 20),
                    _buildProfileInfo('Username', userName),
                    _buildProfileInfo('Mobile', mobile),
                    _buildProfileInfo('Email', email),
                    _buildProfileInfo('Reward Points', rewardPoint.toString()),
                    const Divider(), // A horizontal line for separation
                    const SizedBox(height: 30),
                    _buildBottomButtons(context),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF62BDBD),
                backgroundColor: Colors.white),
            onPressed: () {
              // Handle edit button press

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            child: const Text('Edit'),
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     foregroundColor: const Color.fromARGB(255, 255, 0, 0),
          //     backgroundColor: Colors.white,
          //   ),
          //   onPressed: () {
          //     // Handle delete button press
          //   },
          //   child: const Text('Delete'),
          // ),
        ],
      ),
    );
  }
}
