class OrderProduct {
  final String productName;
  final String productId;
  final String variantId;
  final String variantName;
  final int quantity;
  final double price;
  final int amount;
  final String voucherCode;
  final String imageUrl;

  OrderProduct({
    required this.productName,
    required this.productId,
    required this.variantId,
    required this.variantName,
    required this.quantity,
    required this.price,
    required this.amount,
    required this.voucherCode,
    required this.imageUrl,
  });

  factory OrderProduct.fromMap(Map<String, dynamic> data) {
    return OrderProduct(
      productId: data['productId'],
      variantId: data['variantId'],
      productName: data['productName'],
      variantName: data['variantName'],
      price: data['price'],
      quantity: data['quantity'],
      amount: data['amount'] as int? ?? 0,
      voucherCode: data['voucherCode'],
      imageUrl: data['imageUrl'],
    );
  }

  // Add toJson() method
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'variantId': variantId,
      'productName': productName,
      'variantName': variantName,
      'price': price,
      'amount': amount, // Or whatever field represents the variant amount
      'voucherCode': voucherCode,
      'imageUrl': imageUrl, // If you want to store image URL in the order
      'quantity': quantity,
    };
  }
}
