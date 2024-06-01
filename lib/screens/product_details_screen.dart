import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/models/variant.dart';
import 'package:game_sphere_bd/screens/cart_screen.dart';
import 'package:game_sphere_bd/widgets/review_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});
  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Variant? _selectedVariant;
  List<DropdownMenuItem<Variant>> _dropdownMenuItems = [];
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
    _dropdownMenuItems = _buildDropdownMenuItems(); // Initialize dropdown items
    _selectedVariant = _getInitialVariant();
    _checkWishlistStatus();
  }

  Variant? _getInitialVariant() {
    // Look for the first variant with available voucher codes
    for (var variant in widget.product.variant.values) {
      if (variant.voucherCodes.isNotEmpty) {
        return variant;
      }
    }
    return null;
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

        // Fetch the product document
        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();

        final variantData = (productSnapshot.data()
            as Map<String, dynamic>)['variant'][variantId];

        if (variantData['voucherCodes'].length > 0) {
          // Check if the item with this variant and voucherCode is already in the cart
          final cartQuery = await FirebaseFirestore.instance
              .collection('carts')
              .where('uid', isEqualTo: user.uid)
              .where('productId', isEqualTo: productId)
              .where('variantId', isEqualTo: variantId)
              .get();

          DocumentReference? docRef;
          // Item with this variant and code not found, add it to the cart
          if (cartQuery.docs.isEmpty) {
            docRef = await FirebaseFirestore.instance.collection('carts').add({
              'uid': user.uid,
              'productId': productId,
              'variantId': variantId,
              // 'voucherCode': selectedVoucherCode,
              'quantity': 1,
              'productName': widget.product.name,
              'productImage': widget.product.imageUrl,
              'variant': variantData,
            });
            await docRef.update({'cartId': docRef.id});
          } else {
            // Item with this variant and code exists, update quantity
            docRef = cartQuery.docs.first.reference;
            DocumentSnapshot snapshot = await docRef.get();
            int currentQuantity =
                (snapshot.data() as Map<String, dynamic>)['quantity'] ?? 0;
            await docRef.update({
              'quantity': currentQuantity + 1,
            });
          }
          _showSuccessMessage('Added to cart');
        } else {
          // No voucher codes available for this variant
          _showErrorMessage('No voucher codes available for this variant.');
          return;
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

  void _showErrorMessage(String message) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3), // Longer duration for errors
      backgroundColor: Colors.red,
      messageText: Center(
        child: Text(message, style: const TextStyle(color: Colors.white)),
      ),
      icon: const Icon(Icons.error, color: Colors.white),
    ).show(context);
  }

  List<DropdownMenuItem<Variant>> _buildDropdownMenuItems() {
    return widget.product.variant.values
        .map((variant) {
          final int stockCount =
              variant.voucherCodes.length; // Calculate stock count
          if (stockCount > 0) {
            return DropdownMenuItem<Variant>(
              value: variant,
              child: Text(
                '${variant.amount.toStringAsFixed(0)} ${variant.name} - ${variant.price.toStringAsFixed(0)} BDT (Stock: $stockCount)',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            );
          } else {
            return null;
          }
        })
        .whereType<DropdownMenuItem<Variant>>()
        .toList();
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
                      int fullStars = widget.product.averageRating
                          .floor(); // Get the integer part
                      double remaining = widget.product.averageRating -
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
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      iconEnabledColor: Colors.white,
                      dropdownColor: const Color.fromARGB(255, 130, 214, 214),
                      value: _selectedVariant,
                      items: _dropdownMenuItems,
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
                      onPressed: () {
                        _addToCart();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(
                        Icons.add_shopping_cart,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: Column(children: [
                    const Text(
                      'Customer Reviews:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    ReviewWidget(productId: widget.product.id),
                  ])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
