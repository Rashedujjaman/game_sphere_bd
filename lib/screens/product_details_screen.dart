import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/models/variant.dart';
import 'package:game_sphere_bd/screens/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});
  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Variant _selectedVariant;
  bool isInWishlist = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkWishlistStatus(); // Re-check wishlist status when dependencies change
  }

  @override
  void initState() {
    super.initState();
    _selectedVariant = widget.product.variant.isNotEmpty
        ? widget.product.variant[0]
        : Variant(id: '0', name: 'default', price: 0, amount: 0);
  }

  Future<void> _checkWishlistStatus() async {
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('wishlists')
          .where('uid', isEqualTo: user!.uid)
          .where('productId', isEqualTo: widget.product.id)
          .get();
      setState(() {
        isInWishlist = querySnapshot.docs.isNotEmpty;
      });
    }
  }

  // Define the _showSuccessMessage method
  void _showSuccessMessage(String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
      messageText: Center(
          child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      )),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    ).show(context);
  }

  Future<void> _toggleWishlist(ProductModel product) async {
    if (user != null) {
      try {
        final productId = product.id;

        final wishlistRef = FirebaseFirestore.instance
            .collection('wishlists')
            .where('uid', isEqualTo: user!.uid)
            .where('productId', isEqualTo: productId);

        final querySnapshot = await wishlistRef.get();

        if (querySnapshot.docs.isEmpty) {
          // Product not in wishlist, add it
          DocumentReference docRef =
              await FirebaseFirestore.instance.collection('wishlists').add({
            'uid': user!.uid,
            'productId': productId,
            // ... other relevant fields ...
          });

          // Update the document with its ID as wishlistId
          await docRef.update({'wishlistId': docRef.id});

          _showSuccessMessage('Added to wishlist');
        } else {
          // Product in wishlist, remove it
          await querySnapshot.docs.first.reference.delete();
          _showSuccessMessage('Removed from wishlist');
        }
      } catch (e) {
        // Handle errors (e.g., show error message)
        print('Error updating wishlist: $e');
      }
    }

    setState(() {
      isInWishlist = !isInWishlist;
    });
  }

  Future<void> _addToCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedVariant != null) {
      try {
        final productId = widget.product.id;
        final variantId = _selectedVariant!.id;

        // Check if the item with this variant is already in the cart
        final cartQuery = await FirebaseFirestore.instance
            .collection('carts')
            .where('uid', isEqualTo: user.uid)
            .where('productId', isEqualTo: productId)
            .where('variantId', isEqualTo: variantId)
            .get();

        DocumentReference? docRef;

        if (cartQuery.docs.isEmpty) {
          // Item with this variant not found, add it to the cart
          docRef = await FirebaseFirestore.instance.collection('carts').add({
            'uid': user.uid,
            'productId': productId,
            'variantId': variantId,
            'quantity': 1,
          });
          await docRef.update({'cartId': docRef.id});
        } else {
          // Item with this variant exists, update quantity
          docRef = cartQuery.docs.first.reference;
          DocumentSnapshot snapshot = await docRef.get();
          int currentQuantity =
              (snapshot.data() as Map<String, dynamic>)['quantity'] ?? 0;
          await docRef.update({
            'quantity': currentQuantity + 1,
          });
        }
      } catch (e) {
        print('Error adding to cart: $e');
        // Show an error message to the user (SnackBar or Dialog)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding to cart: $e')),
          );
        }
        return;
      }
      // Showing the dialog whether user wants to continue shopping or view cart
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 130, 214, 214),
            titlePadding: const EdgeInsets.all(5),
            iconPadding: const EdgeInsets.symmetric(vertical: 10),
            actionsPadding: const EdgeInsets.all(10),
            shadowColor: Colors.amber,
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 40,
            ),
            title: const Text(
              'Item Added to Cart',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Continue Shopping',
                    style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                //button color
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                ),
                onPressed: () {
                  // Navigator.pop(context); // Close the dialog
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()));
                },
                child: const Text('View Cart',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF62BDBD),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                image: DecorationImage(
                  image: NetworkImage(widget.product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _toggleWishlist(widget.product);
                        // Wishlist functionality here
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      // Calculate the rating to determine how many full/half stars to display
                      int fullStars =
                          widget.product.rating.floor(); // Get the integer part
                      double remaining = widget.product.rating -
                          fullStars; // Get the decimal part

                      if (index < fullStars) {
                        // Display full stars
                        return const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        );
                      } else if (index == fullStars && remaining > 0) {
                        // Display half star for ratings like 2.5, 3.5, 4.5
                        return const Icon(
                          Icons.star_half,
                          color: Colors.yellow,
                        );
                      } else {
                        // Display empty stars for remaining positions
                        return const Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Variants:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: DropdownButton<Variant>(
                      // This is the dropdown button
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      iconEnabledColor: Colors.white,
                      dropdownColor: Color.fromARGB(255, 130, 214, 214),
                      value: _selectedVariant,
                      items: widget.product.variant.map((Variant variant) {
                        return DropdownMenuItem<Variant>(
                          value: variant,
                          child: Container(
                            width: MediaQuery.of(context).size.width * .8,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${variant.amount.toInt()} ${variant.name}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  '${variant.price.toStringAsFixed(0)} ৳',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (Variant? selectedVariant) {
                        if (selectedVariant != null) {
                          setState(() {
                            _selectedVariant = selectedVariant;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      // This is the Add to Cart button
                      onPressed: () {
                        // Add your purchase functionality here
                        // link to cart screen
                        _addToCart();

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const CartScreen()
                        //       ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
