import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_sphere_bd/models/cart_item.dart';
import 'package:game_sphere_bd/screens/home_screen.dart';
import 'package:game_sphere_bd/screens/payment_screen.dart';
import 'package:game_sphere_bd/widgets/cart_item_card_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];
  final user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
    _calculateTotal();
  }

  void _removeFromCart(String cartItemId) async {
    try {
      // Remove the cart item from Firestore
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(cartItemId)
          .delete();

      // Update the cartItems list
      setState(() {
        cartItems.removeWhere((item) => item.id == cartItemId);
      });
    } catch (e) {
      print('Error removing item from cart: $e');
      // Handle the error (e.g., show a SnackBar to the user)
    }
  }

  Future<void> _fetchCartItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('carts')
            .where('uid', isEqualTo: user.uid)
            .get();

        List<CartItem> fetchedCartItems = [];

        for (var cartDoc in querySnapshot.docs) {
          final cartData = cartDoc.data();
          final productId = cartData['productId'] as String;
          final variantId = cartData['variantId'] as String;
          final quantity = cartData['quantity'] as int;

          // Fetch the product document
          final productDoc = await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();

          // Check if product exists and variant exists
          if (productDoc.exists && productDoc.data()!.containsKey('variant')) {
            final productData = productDoc.data() as Map<String, dynamic>;
            final variantData = productData['variant'][variantId];

            if (variantData != null) {
              fetchedCartItems.add(CartItem(
                id: cartDoc.id,
                productId: productId,
                productName: productData['name'],
                productImage: productData['imageUrl'],
                variantId: variantId,
                variantName: variantData['name'],
                price: (variantData['price'] as num).toDouble(),
                quantity: quantity,
                variantAmount: variantData['amount'],
                // variantAmount: selectedVariant['amount'],
              ));
            } else {
              // Handle case where variant is not found
              print(
                  'Error: Variant with ID $variantId not found in product $productId');
            }
          } else {
            // Handle case where product is not found
            print('Error: Product with ID $productId not found');
          }
        }

        setState(() {
          cartItems = fetchedCartItems;
          isLoading = false;
        });

        // Calculate total after fetching cart items
        _calculateTotal();
      } else {
        // Handle the case where the user is not logged in
        print("User not logged in");
      }
    } catch (error) {
      // Handle errors with the Firestore query itself
      print("Error fetching cart items from Firestore: $error");
      // Optionally, show a SnackBar or an error dialog to the user
    }
  }

  void _calculateTotal() {
    setState(() {
      total =
          cartItems.fold(0.0, (sum, item) => sum + item.price * item.quantity);
    });
  }

  void _updateQuantity(String cartItemId, int newQuantity) async {
    try {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(cartItemId)
          .update({'quantity': newQuantity});

      _fetchCartItems(); // Refresh cart items after updating quantity
    } catch (e) {
      print('Error updating quantity: $e');
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xFF62BDBD),
            ))
          : Column(
              // Main column to organize content
              children: [
                Expanded(
                  child: cartItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart,
                                  size: 150, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text('Your cart is empty',
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.grey,
                                  )),
                              const SizedBox(height: 150),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                                child: const Text('See Products',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        )
                      :
                      // Make ListView expandable
                      ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (ctx, index) {
                            final cartItem = cartItems[index];
                            return CartItemCardWidget(
                              cartItem: cartItem,
                              onQuantityChanged: (newQuantity) =>
                                  _updateQuantity(cartItem.id, newQuantity),
                              onRemove: () => _removeFromCart(cartItem.id),
                            );
                          },
                        ),
                ),

                // Bottom Sheet (Only when cartItems is not empty)
                if (cartItems.isNotEmpty)
                  Container(
                    color: const Color(0xFF62BDBD),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: $total ৳',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Fetch user name and email
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final userData = await FirebaseFirestore.instance
                                  .collection('Customers')
                                  .doc(user.uid)
                                  .get();
                              final String userName = userData['fullName'];
                              final String userEmail = userData['email'];
                              final int rewardPoint = userData['rewardPoint'];
                              final String userMobile = userData['mobileNo'];

                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      totalAmount: total,
                                      cartItems: cartItems,
                                      userName: userName,
                                      userEmail: userEmail,
                                      rewardPoint: rewardPoint,
                                      userMobile: userMobile,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text('Checkout',
                              style: TextStyle(color: const Color(0xFF62BDBD))),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
