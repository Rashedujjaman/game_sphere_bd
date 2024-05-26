import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:game_sphere_bd/screens/aboutus_screen.dart';
import 'package:game_sphere_bd/screens/bulkorder_screen.dart';
import 'package:game_sphere_bd/screens/cart_screen.dart';
import 'package:game_sphere_bd/screens/login_screen.dart';
import 'package:game_sphere_bd/screens/order_screen.dart';
import 'package:game_sphere_bd/screens/profile.dart';
import 'package:game_sphere_bd/screens/reward_center_screen.dart';
import 'package:game_sphere_bd/screens/wishlist_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool userLoggedIn = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser; // Geting the current user
  }

  // Perform logout operations here (e.g., clearing user data, resetting authentication status)
  // Example: Clear user session, navigate to login screen
  // Replace the logic below with your actual logout logic
  void logoutUser(BuildContext context) {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Clear all previous routes from the stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: _user != null
            ? StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Customers')
                    .doc(_user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Error fetching user data"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  } else {
                    // Extracting user data from the snapshot
                    var userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    String name = userData['fullName'] ?? "N/A";
                    // int rewardPoint = userData['rewardPoint'] ?? 0;
                    String imageUrl = userData['imageUrl'] ?? "";

                    return ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          decoration: const BoxDecoration(
                            color: Color(0xFF62BDBD),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: imageUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(imageUrl)
                                    : null,
                                backgroundColor: imageUrl.isEmpty
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : null,
                                child: imageUrl.isNotEmpty
                                    ? null
                                    : const Icon(Icons.person,
                                        color: Color(0xFF62BDBD),
                                        size:
                                            50), // Size adjusted for visibility
                              ),
                              const SizedBox(height: 8),
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: const Text('Profile'),
                          onTap: () {
                            // Handle tapping the Profile menu item
                            //connect to profile page

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileScreen()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.history),
                          title: const Text('Orders'),
                          onTap: () {
                            // Handle tapping the Orders menu item
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderHistoryScreen()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.shopping_cart),
                          title: const Text('Cart'),
                          onTap: () {
                            // Handle tapping the Orders menu item

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartScreen()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.favorite),
                          title: const Text('Wishlist'),
                          onTap: () {
                            // Handle tapping the Wishlist menu item
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WishlistScreen()),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.card_giftcard),
                          title: const Text('Reward Center'),
                          onTap: () {
                            // Handle tapping the Reward Center menu item
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RewardCenterScreen()),
                            );
                          },
                        ),
                        //make a bulk order button
                        ListTile(
                          leading: const Icon(Icons.shopping_basket),
                          title: const Text('Bulk Order'),
                          onTap: () {
                            // Handle tapping the Reward Center menu item
                            //connect to bulk order screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BulkOrderFormScreen()),
                            );
                          },
                        ),

                        ListTile(
                          leading: const Icon(Icons.info),
                          title: const Text('About us'),
                          onTap: () {
                            // Handle tapping the About us menu item
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutUsScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 65),

                        //Logout button
                        if (userLoggedIn)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  logoutUser(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor:
                                      const Color.fromARGB(150, 0, 0, 0),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize
                                      .min, // Keep the Row's width compact
                                  children: [
                                    Icon(Icons.logout),
                                    SizedBox(width: 8), // Add some spacing
                                    Text('Logout',
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                })
            : Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    const DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color(0xFF62BDBD),
                        ),
                        // child: SizedBox.shrink(),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Color(
                                    0xFF62BDBD), // Avatar background color
                                child: CircleAvatar(
                                  // Inner circle for the Icon
                                  radius:
                                      38, // Slightly smaller to create the border
                                  backgroundColor: Colors.white, // Border color
                                  child: Icon(
                                    Icons.person,
                                    color: Color(0xFF62BDBD), // Icon color
                                    size: 50,
                                  ),
                                ),
                              ),
                            ])), // Empty header to match logged-in state
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('About us'),
                      onTap: () {
                        // Handle tapping the About us menu item
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 400),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            logoutUser(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: const Color.fromARGB(150, 0, 0, 0),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize
                                .min, // Keep the Row's width compact
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 8), // Add some spacing
                              Text('Login', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
