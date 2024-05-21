import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/models/variant.dart';
import 'package:game_sphere_bd/widgets/product_card_widget.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  ProductModel product1 = ProductModel(
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
  );

  //another product
  ProductModel product2 = ProductModel(
      id: 2,
      name: 'Republic GG',
      image:
          'https://my-milkadeal.s3.ap-southeast-1.amazonaws.com/storage/160000/129884/da1cfcc42d940104c3014d6a9f37901e.png',
      description:
          'Republic GG is a region locked product. It is only valid for Garena account registered in the region of MALAYSIA. All purchases are NON-REFUNDABLE and NON-RETURNABLE.',
      variants: [
        Variant(
          id: 1,
          name: 'RGG',
          price: 1920,
          amount: 1300,
        ),
        Variant(
          id: 2,
          name: 'RGG',
          price: 970,
          amount: 650,
        ),
        Variant(
          id: 3,
          name: 'RGG',
          price: 450,
          amount: 300,
        ),
        Variant(
          id: 4,
          name: 'RGG',
          price: 290,
          amount: 180,
        ),
        Variant(
          id: 5,
          name: 'RGG',
          price: 150,
          amount: 90,
        ),
      ]);
  ProductModel product3 = ProductModel(
      id: 3,
      name: 'Unipin UC',
      image: 'https://cdn.unipin.com/images/unipin-dark-og.png',
      description:
          'Unipin UC is a region locked product. It is only valid for Garena account registered in the region of MALAYSIA. All purchases are NON-REFUNDABLE and NON-RETURNABLE.',
      variants: [
        Variant(
          id: 1,
          name: 'UC',
          price: 2000,
          amount: 1800,
        ),
        Variant(
          id: 2,
          name: 'UC',
          price: 1200,
          amount: 1120,
        ),
      ]);
  ProductModel product4 = ProductModel(
      id: 3,
      name: 'Smile Coin',
      image:
          'https://static.wikia.nocookie.net/infectious-smile/images/9/97/SmileCoinTrans.png/revision/latest?cb=20230712231154',
      description:
          'Smile Coin is a region locked product. It is only valid for Garena account registered in the region of MALAYSIA. All purchases are NON-REFUNDABLE and NON-RETURNABLE.',
      variants: [
        Variant(
          id: 1,
          name: 'coin',
          price: 1500,
          amount: 5999,
        ),
        Variant(
          id: 2,
          name: 'coin',
          price: 750,
          amount: 2999,
        ),
      ]);

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
            ProductCardWidget(product: product1),
            ProductCardWidget(product: product2),
            ProductCardWidget(product: product3),
            ProductCardWidget(product: product4),

            // ProductCardWidget(product: product),
            //      ProductCardWidget(product: product2),
          ],
        )));
  }
}
