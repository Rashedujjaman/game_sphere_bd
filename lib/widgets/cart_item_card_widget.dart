import 'package:flutter/material.dart';
import 'package:game_sphere_bd/models/cart_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartItemCardWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function(int newQuantity) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCardWidget({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    ;
    return Dismissible(
      // Using Dismissible for swipe-to-delete
      key: Key(cartItem.id), // Unique key for Dismissible
      onDismissed: (direction) => onRemove(),
      direction:
          DismissDirection.endToStart, // Swipe from right to left to delete
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child:
            const Icon(Icons.delete, color: Color.fromARGB(255, 255, 255, 255)),
      ),
      child: Card(
        margin: const EdgeInsets.all(8),
        color: Colors.cyan[100],
        child: Row(
          // Main Row for the entire card content
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(cartItem.productImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Product Image (Leading)

            const SizedBox(width: 16), // Add spacing between image and details

            Expanded(
              // Expanded Column for details
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cartItem.productName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold, // Make product name bold
                    ),
                  ),
                  Text(
                    'Variant: ${cartItem.variantAmount} ${cartItem.variantName}',
                  ),
                  Text('Price: ${cartItem.price.toStringAsFixed(0)} ৳'),
                ],
              ),
            ),

            // Quantity Controls (Trailing)

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Row for increment and decrement buttons
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: cartItem.quantity > 1
                      ? () => onQuantityChanged(cartItem.quantity - 1)
                      : null, // Disable decrement button if quantity is 1
                ),
                Text('${cartItem.quantity}',
                    style: const TextStyle(
                        fontSize: 16)), // Style the quantity text
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => onQuantityChanged(cartItem.quantity + 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
