class CartItem {
  final String cartId;
  final String productId;
  final String productName;
  final String imageUrl;
  final String variantId;
  final String variantName;
  final int variantAmount;
  final double price;
  int quantity;

  CartItem({
    required this.cartId,
    required this.productId,
    required this.variantId,
    required this.quantity,
    required this.productName,
    required this.imageUrl,
    required this.variantName,
    required this.variantAmount,
    required this.price,
  });

  factory CartItem.fromFirestore(String id, Map<String, dynamic> cartData,
      Map<String, dynamic> productData) {
    final selectedVariant = (cartData['variant'] as Map<String, dynamic>);
    return CartItem(
      cartId: id,
      productId: cartData['productId'],
      productName: productData['name'],
      imageUrl: productData['imageUrl'],
      variantId: cartData['variantId'],
      variantName: selectedVariant['name'],
      price: (selectedVariant['price'] as num).toDouble(),
      quantity: cartData['quantity'],
      variantAmount: (selectedVariant['amount'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'productId': productId,
      'variantId': variantId,
      'imageUrl': imageUrl,
      'variantName': variantName,
      'variantAmount': variantAmount,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cartId'],
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      price: json['price'],
      variantId: json['variantId'],
      imageUrl: json['imageUrl'],
      variantName: json['variantName'],
      variantAmount: json['variantAmount'],
    );
  }
}
