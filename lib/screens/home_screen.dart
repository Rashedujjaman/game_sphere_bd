import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/models/promotion.dart';
import 'package:game_sphere_bd/models/variant.dart';
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

  final List<ProductModel> products = [
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
    ProductModel(
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
      ],
    ),
    ProductModel(
      id: 3,
      name: 'Unipin UC',
      image: 'https://cdn.unipin.com/images/unipin-dark-og.png',
      description:
          'Smile Coin is a region locked product. It is only valid for Garena account registered in the region of MALAYSIA. All purchases are NON-REFUNDABLE and NON-RETURNABLE.',
      variants: [
        Variant(
          id: 1,
          name: 'UC',
          price: 1920,
          amount: 1300,
        ),
        Variant(
          id: 2,
          name: 'UC',
          price: 970,
          amount: 650,
        ),
      ],
    ),
    ProductModel(
      id: 4,
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
      ],
    ),
    ProductModel(
      id: 5,
      name: 'Unipin UC',
      image: 'https://cdn.unipin.com/images/unipin-dark-og.png',
      description:
          'Smile Coin is a region locked product. It is only valid for Garena account registered in the region of MALAYSIA. All purchases are NON-REFUNDABLE and NON-RETURNABLE.',
      variants: [
        Variant(
          id: 1,
          name: 'UC',
          price: 1920,
          amount: 1300,
        ),
        Variant(
          id: 2,
          name: 'UC',
          price: 970,
          amount: 650,
        ),
      ],
    ),
    ProductModel(
      id: 6,
      name: 'Unipin UC',
      image: 'https://cdn.unipin.com/images/unipin-dark-og.png',
      description:
          'Smile Coin is a region locked product. It is only valid for Garena account registered in the region of MALAYSIA. All purchases are NON-REFUNDABLE and NON-RETURNABLE.',
      variants: [
        Variant(
          id: 1,
          name: 'UC',
          price: 1920,
          amount: 1300,
        ),
        Variant(
          id: 2,
          name: 'UC',
          price: 970,
          amount: 650,
        ),
      ],
    ),
    ProductModel(
      id: 7,
      name: 'Unipin UC',
      image: 'https://cdn.unipin.com/images/unipin-dark-og.png',
      description:
          'Smile Coin is a region locked product. It is only valid for Garena account registered in the region of MALAYSIA. All purchases are NON-REFUNDABLE and NON-RETURNABLE.',
      variants: [
        Variant(
          id: 1,
          name: 'UC',
          price: 1920,
          amount: 1300,
        ),
        Variant(
          id: 2,
          name: 'UC',
          price: 970,
          amount: 650,
        ),
      ],
    ),
  ];

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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ])),
            GridView.builder(
              padding: const EdgeInsets.all(8.0),
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // to avoid conflict with SingleChildScrollView
              itemCount: products.length,
              // itemCount: 8,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 6 / 7, // Adjust to fit card's aspect ratio
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
