import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/models/variant.dart';
import 'package:game_sphere_bd/screens/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Variant _selectedVariant;

  @override
  void initState() {
    super.initState();
    _selectedVariant =
        widget.product.variant[0]; // Set the initial selected variant
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF62BDBD),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                image: DecorationImage(
                  image: NetworkImage(widget.product.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add your like functionality here
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      // Calculate the rating to determine how many full/half stars to display
                      int fullStars =
                          widget.product.rating.floor(); // Get the integer part
                      double remaining = widget.product.rating -
                          fullStars; // Get the decimal part

                      if (index < fullStars) {
                        // Display full stars
                        return const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        );
                      } else if (index == fullStars && remaining > 0) {
                        // Display half star for ratings like 2.5, 3.5, 4.5
                        return const Icon(
                          Icons.star_half,
                          color: Colors.yellow,
                        );
                      } else {
                        // Display empty stars for remaining positions
                        return const Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                        );
                      }
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Variants:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: DropdownButton<Variant>(
                      // This is the dropdown button
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      iconEnabledColor: Colors.white,
                      dropdownColor: Color.fromARGB(255, 130, 214, 214),
                      value: _selectedVariant,
                      items: widget.product.variant.map((Variant variant) {
                        return DropdownMenuItem<Variant>(
                          value: variant,
                          child: Container(
                            width: MediaQuery.of(context).size.width * .8,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${variant.amount.toInt()} ${variant.name}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  '${variant.price.toStringAsFixed(0)} ৳',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (Variant? selectedVariant) {
                        if (selectedVariant != null) {
                          setState(() {
                            _selectedVariant = selectedVariant;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      // This is the Add to Cart button
                      onPressed: () {
                        // Add your purchase functionality here
                        // link to cart screen

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
