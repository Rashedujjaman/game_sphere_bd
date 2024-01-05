import 'package:flutter/material.dart';
import 'package:game_sphere_bd/screens/login_screen.dart';

class CustomDrawer extends StatelessWidget {
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
                  'MD Rasheedujjan Reza',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle tapping the Home menu item
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle tapping the Settings menu item
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Purchase History'),
            onTap: () {
              // Handle tapping the Purchase History menu item
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Wishlist'),
            onTap: () {
              // Handle tapping the Wishlist menu item
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Bulk Order'),
            onTap: () {
              // Handle tapping the Bulk Order menu item
            },
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('Reward Center'),
            onTap: () {
              // Handle tapping the Reward Center menu item
            },
          ),
          ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Account Management'),
              onTap: () {
                //navigate login
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginScreen();
                }));
              }),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Report an issue'),
            onTap: () {
              // Handle tapping the Report an issue menu item
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About us'),
            onTap: () {
              // Handle tapping the About us menu item
            },
          ),
        ],
      ),
    );
  }
}
