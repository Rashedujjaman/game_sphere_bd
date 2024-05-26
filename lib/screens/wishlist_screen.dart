import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/widgets/product_card_widget.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<ProductModel> wishlistItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  //Fetch wishlist items
  Future<void> _fetchWishlist() async {
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('wishlists')
            .where('uid', isEqualTo: user.uid)
            .get();

        //Get item ids from wishlist
        final productId =
            querySnapshot.docs.map((doc) => doc['productId']).toList();

        //Get item data from products collection based on product ID
        final productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where(FieldPath.documentId, whereIn: productId)
            .get();

        setState(() {
          wishlistItems = productSnapshot.docs.map((doc) {
            return ProductModel.fromFirestore(doc.id, doc.data());
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF62BDBD),
      appBar: AppBar(
        title: const Text('Wishlist',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) => ProductCardWidget(
                product: wishlistItems[index],
              ),
            ),
    );
  }
}
