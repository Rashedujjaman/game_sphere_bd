import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/models/variant.dart';
import 'package:game_sphere_bd/widgets/product_card_widget.dart';

class WishlistScreen extends StatelessWidget {
  final List<ProductModel> wishlistProducts = [
    ProductModel(
      id: 1,
      name: 'Garena Shell',
      image: 'https://image.offgamers.com/infolink/2023/05/garena-tw.jpg',
      description:
          'Garena Shells Code (Malaysia) sold by SEAGM is a region locked product. It is only valid for Garena account registered in the region of MALAYSIA. All purchases are NON-REFUNDABLE and NON-RETURNABLE.',
      variants: [
        Variant(
          id: 1,
          name: 'Shell',
          price: 1920,
          amount: 1300,
        ),
        Variant(
          id: 2,
          name: 'Shell',
          price: 970,
          amount: 650,
        ),
        Variant(
          id: 3,
          name: 'Shell',
          price: 450,
          amount: 300,
        ),
        Variant(
          id: 4,
          name: 'Shell',
          price: 290,
          amount: 180,
        ),
        Variant(
          id: 5,
          name: 'Shell',
          price: 150,
          amount: 90,
        ),
      ],
    ),
    // Add more ProductModels for the wishlist
  ];

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
      body: ListView.builder(
        itemCount: wishlistProducts.length,
        itemBuilder: (context, index) {
          final product = wishlistProducts[index];
          return ProductCardWidget(product: product);
        },
      ),
    );
  }
}
