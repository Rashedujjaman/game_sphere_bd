import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/cart_item.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For image caching

class PaymentCartItemCardWidget extends StatelessWidget {
  final CartItem cartItem;

  const PaymentCartItemCardWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.cyan[100],
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: CachedNetworkImageProvider(cartItem.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cartItem.productName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                    'Variant: ${cartItem.variantAmount} ${cartItem.variantName}'),
                Text('Price: ${cartItem.price.toStringAsFixed(0)} ৳'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
