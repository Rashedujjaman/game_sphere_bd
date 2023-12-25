import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:game_sphere_bd/models/promotion.dart';
import 'package:game_sphere_bd/screens/category.dart';
import 'package:game_sphere_bd/widgets/menu_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ImageModel> carouselImages = [
    ImageModel(imagePath: 'assets/images/garena.png'),
    ImageModel(imagePath: 'assets/images/callofduty.jpg'),
    ImageModel(imagePath: 'assets/images/rgg.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CarouselSlider(
            items: carouselImages.map((image) {
              return Image.asset(
                image.imagePath,
                fit: BoxFit.cover,
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
          Container(
            height: 80,
            color: Colors.blue.withOpacity(0.4), // Adjust the height as needed
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Replace with your category list length
              itemBuilder: (BuildContext context, int index) {
                // Return your category list items here
                return GestureDetector(
                  onTap: () {
                    // Navigate to another page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const CategoeryScreen()), // Replace AnotherPage with your desired page
                    );
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    // Other contents of the container
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20, // Replace with your product list length
              itemBuilder: (BuildContext context, int index) {
                // Return your product list items here
                return GestureDetector(
                  onDoubleTap: () {
                    _showBottomSheet(context);
                  },
                  child: ListTile(
                    textColor: Colors.blue,
                    title: Text('Product $index',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    // Your product item widget
                  ),
                );
              },
            ),
          ),
        ],
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