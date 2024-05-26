class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final String variantId;
  final String variantName;
  final int variantAmount;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.productName,
    required this.productImage,
    required this.variantName,
    required this.variantAmount,
    required this.price,
  });

  factory CartItem.fromFirestore(String id, Map<String, dynamic> cartData,
      Map<String, dynamic> productData) {
    final selectedVariant = (cartData['variant'] as Map<String, dynamic>);
    return CartItem(
      id: id,
      productId: cartData['productId'],
      productName: productData['name'],
      productImage: productData['imageUrl'],
      variantId: cartData['variantId'],
      variantName: selectedVariant['name'],
      price: (selectedVariant['price'] as num).toDouble(),
      quantity: cartData['quantity'],
      variantAmount: (selectedVariant['amount'] as num).toInt(),
    );
  }
}
