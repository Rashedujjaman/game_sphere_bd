import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/models/promotion.dart';
import 'package:game_sphere_bd/models/variant.dart';
import 'package:game_sphere_bd/screens/all_products.dart';
import 'package:game_sphere_bd/widgets/menu_drawer.dart';
import 'package:game_sphere_bd/widgets/product_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ImageModel> carouselImages = [
    ImageModel(imagePath: 'assets/images/garena.png'),
    ImageModel(imagePath: 'assets/images/callofduty.jpg'),
    ImageModel(imagePath: 'assets/images/pubg.jpg'),
  ];

  ProductModel product = ProductModel(
    id: 1,
    name: 'Call of Duty:',
    image:
        'https://cdn.cloudflare.steamstatic.com/steam/apps/1289310/capsule_616x353.jpg?t=1632935379',
    description:
        'Call of Duty: Mobile is a free-to-play first-person shooter game developed by TiMi Studios and published by Activision for Android and iOS. It was released on October 1, 2019. In its first month, the game had over 148 million downloads and generated nearly US '
        '54 million in revenue, making it the largest mobile game launch in history.',
    variant: Variant(
      id: 1,
      name: 'Call of Duty: Mobil',
      price: 100,
      amount: 13,
    ),
  );

  //another product
  ProductModel product2 = ProductModel(
    id: 2,
    name: 'PUBG Mobile',
    image: 'https://wstatic-prod.pubg.com/web/live/static/og/img-og-pubg.jpg',
    description:
        'PUBG Mobile is an online multiplayer battle royale game developed and published by PUBG Corporation, a subsidiary of South Korean video game company Bluehole. The game is based on previous mods that were created by Brendan "PlayerUnknown" Greene for other games, inspired by the 2000 Japanese film Battle Royale, and expanded into a standalone game under Greene\'s creative direction. In the game, up to one hundred players parachute onto an island and scavenge for weapons and equipment to kill others while avoiding getting killed themselves. The available safe area of the game\'s map decreases in size over time, directing surviving players into tighter areas to force encounters. The last player or team standing wins the round.',
    variant: Variant(
      id: 1,
      name: 'Call of Duty: Mobile - Garena',
      price: 100,
      amount: 13,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: const Color(0xFF62BDBD),
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF62BDBD),
        elevation: 1,
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselSlider(
              items: carouselImages.map((image) {
                return ClipRRect(
                  borderRadius:
                      BorderRadius.circular(15), // Adjust the radius as needed
                  child: Image.asset(
                    image.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300, // Increase the height for more coverage
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 200,
                aspectRatio: 1 / 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            // Container(
            //   height: 80,
            //   color:
            //       Colors.blue.withOpacity(0.4), // Adjust the height as needed
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 5, // Replace with your category list length
            //     itemBuilder: (BuildContext context, int index) {
            //       // Return your category list items here
            //       return GestureDetector(
            //         onTap: () {
            //           // Navigate to another page
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) =>
            //                     const CategoeryScreen()), // Replace AnotherPage with your desired page
            //           );
            //         },
            //         child: Container(
            //           width: 80,
            //           margin: const EdgeInsets.all(8.0),
            //           decoration: const BoxDecoration(
            //             color: Color(0xFF85C8CD),
            //             borderRadius: BorderRadius.all(
            //               Radius.circular(15),
            //             ),
            //           ),
            //           // Other contents of the container
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Popular Games",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllProductsScreen()),
                          );
                        },
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ])),
            ProductCardWidget(product: product),
            ProductCardWidget(product: product2),
            for (int i = 0; i < 100; i++) ProductCardWidget(product: product2),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const SizedBox(
          height: 200,
          // Customize the bottom sheet content here
          child: Center(
            child: Text(
              'Your Bottom Sheet Content go',
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      },
    );
  }
}
