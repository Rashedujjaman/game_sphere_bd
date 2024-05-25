class Variant {
  final String id;
  final String name;
  final double price;
  final double amount;

  Variant(
      {required this.id,
      required this.name,
      required this.price,
      required this.amount});
  factory Variant.fromMap(String variantId, Map<String, dynamic> variantMap) {
    return Variant(
      id: variantId,
      name: variantMap['name'],
      price: double.tryParse(variantMap['price'].toString()) ??
          0.0, // Parse to double
      amount: double.tryParse(variantMap['amount'].toString()) ??
          0.0, // Parse to double
    );
  }

  num? get length => null;
}
