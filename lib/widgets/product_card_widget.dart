import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/product.dart';
import 'package:game_sphere_bd/screens/product_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;

  const ProductCardWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/product_details', arguments: product);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        color: Colors.lightBlue[50],
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shadowColor: const Color.fromARGB(255, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Displaying the product image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 150,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                        color: Colors.grey)), // Loading indicator
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error), // Error icon
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the product name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Display the product rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          // Calculate the rating to determine how many full/half stars to display
                          int fullStars = product.averageRating
                              .floor(); // Get the integer part
                          double remaining = product.averageRating -
                              fullStars; // Get the decimal part

                          if (index < fullStars) {
                            // Display full stars
                            return const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            );
                          } else if (index == fullStars && remaining > 0) {
                            // Display half star for ratings like 2.5, 3.5, 4.5
                            return const Icon(
                              Icons.star_half,
                              color: Colors.amber,
                              size: 18,
                            );
                          } else {
                            // Display empty stars for remaining positions
                            return const Icon(
                              Icons.star_border,
                              color: Colors.amber,
                              size: 18,
                            );
                          }
                        }),
                      ),
                    ],
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
