import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/promotion.dart';

class CategoeryScreen extends StatefulWidget {
  const CategoeryScreen({Key? key}) : super(key: key);

  @override
  State<CategoeryScreen> createState() => _CategoeryScreenState();
}

class _CategoeryScreenState extends State<CategoeryScreen> {
  final List<ImageModel> carouselImages = [
    ImageModel(imagePath: 'assets/images/garena.png'),
    ImageModel(imagePath: 'assets/images/callofduty.jpg'),
    ImageModel(imagePath: 'assets/images/pubg.jpg'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text(
        "Category",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
    ));
  }
}
