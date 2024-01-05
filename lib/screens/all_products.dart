import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/models/variant.dart';
import 'package:game_sphere_bd/widgets/product_card_widget.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  ProductModel product = ProductModel(
    id: 1,
    name: 'Call of Duty: Mobile - Garena',
    image:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1289310/capsule_616x353.jpg?t=1632935379',
    description:
        'Call of Duty: Mobile is a free-to-play first-person shooter game developed by TiMi Studios and published by Activision for Android and iOS. It was released on October 1, 2019. In its first month, the game had over 148 million downloads and generated nearly US '
        '54 million in revenue, making it the largest mobile game launch in history.',
    variant: Variant(
      id: 1,
      name: 'Call of Duty',
      price: 100,
      amount: 13,
    ),
  );

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
            for (int i = 0; i < 10; i++) ProductCardWidget(product: product),

            // ProductCardWidget(product: product),
            //      ProductCardWidget(product: product2),
          ],
        )));
  }
}
