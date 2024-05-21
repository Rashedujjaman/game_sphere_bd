import 'package:flutter/material.dart';
import 'package:game_sphere_bd/screens/aboutus_screen.dart';
import 'package:game_sphere_bd/screens/bulkorder_screen.dart';
import 'package:game_sphere_bd/screens/cart_screen.dart';
import 'package:game_sphere_bd/screens/login_screen.dart';
import 'package:game_sphere_bd/screens/order_screen.dart';
import 'package:game_sphere_bd/screens/profile.dart';
import 'package:game_sphere_bd/screens/reward_center_screen.dart';
import 'package:game_sphere_bd/screens/wishlist_screen.dart';

class CustomDrawer extends StatelessWidget {
  bool userLoggedIn = true;

  void logoutUser(BuildContext context) {
    // Perform logout operations here (e.g., clearing user data, resetting authentication status)
    // Example: Clear user session, navigate to login screen
    // Replace the logic below with your actual logout logic

    userLoggedIn = false;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false, // Clear all previous routes from the stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF62BDBD),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/Reza.jpg'),
                ),
                SizedBox(height: 8),
                Text(
                  'MD Rashedujjan Reza',
                  style: TextStyle(
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
                MaterialPageRoute(builder: (context) => ProfileScreen()),
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
                MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
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
                MaterialPageRoute(builder: (context) => CartScreen()),
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
                MaterialPageRoute(builder: (context) => WishlistScreen()),
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
                MaterialPageRoute(builder: (context) => RewardCenterScreen()),
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
                MaterialPageRoute(builder: (context) => BulkOrderFormScreen()),
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
                MaterialPageRoute(builder: (context) => AboutUsScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          //logout or login button that will be shown conditionally based on user login status;
          if (userLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                logoutUser(context);
              },
            ),
        ],
      ),
    );
  }
}
