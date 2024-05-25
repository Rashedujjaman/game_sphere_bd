import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_sphere_bd/widgets/product_card_widget.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  List<ProductModel> products = []; // Store fetched products

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products') // Product collection named
          .get();

      setState(() {
        products = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return ProductModel.fromFirestore(
              doc.id, data); // Convert Firestore data to ProductModel
        }).toList();
      });
    } catch (error) {
      // Handle errors, e.g., show a SnackBar or error message
      print("Error fetching products: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF62BDBD),
        appBar: AppBar(
          title: const Text(
            "All Products",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 2,
          backgroundColor: const Color(0xFF62BDBD),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 16),
            ...products.isEmpty
                ? const [
                    Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  ]
                : products
                    .map((product) => ProductCardWidget(product: product))
                    .toList(),
          ],
        )));
  }
}
