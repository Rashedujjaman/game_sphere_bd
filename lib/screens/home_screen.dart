import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/models/promotion.dart';
import 'package:game_sphere_bd/screens/all_products.dart';
import 'package:game_sphere_bd/screens/cart_screen.dart';
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
    ImageModel(imagePath: 'assets/images/unipin.jpg'),
    ImageModel(imagePath: 'assets/images/freefire.jpg'),
    ImageModel(imagePath: 'assets/images/rgg.png'),
  ];

  List<ProductModel> products = []; // Store fetched products
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  } // Fetch products when the screen loads

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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              // Add your cart button functionality here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
          // Add the item indicator widget here
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const SizedBox(
            //   height: 16,
            // ),
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
                height: 150,
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
              height: 20,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Popular Items",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ])),
            GridView.builder(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // to avoid conflict with SingleChildScrollView
              itemCount: products.length,
              // itemCount: 8,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                crossAxisSpacing: 0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 6 / 8, // Adjust to fit card's aspect ratio
              ),
              itemBuilder: (context, index) {
                return ProductCardWidget(product: products[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // void _showBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return const SizedBox(
  //         height: 200,
  //         // Customize the bottom sheet content here
  //         child: Center(
  //           child: Text(
  //             'Your Bottom Sheet Content go',
  //             style: TextStyle(fontSize: 20),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
