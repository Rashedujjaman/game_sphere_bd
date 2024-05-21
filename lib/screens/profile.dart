import 'package:flutter/material.dart';
import 'package:game_sphere_bd/screens/edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  String name = "MD Rashedujjan Reza";
  String email = "reza2001july@gmail.com";
  String image = "assets/images/Reza.jpg";
  String userName = "Rashedujjaman";
  String mobile = "01161342013";
  int rewardPoint = 100;

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          color: Colors.white, // Set color of back button
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage(image),
              ),

              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 255, 0, 0),
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              // Handle delete button press
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
