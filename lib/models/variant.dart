class Variant {
  final String id;
  final String name;
  final double price;
  final double amount;
  final List<String> voucherCodes; // Add voucherCodes field

  Variant({
    required this.id,
    required this.name,
    required this.price,
    required this.amount,
    required this.voucherCodes,
  });

  factory Variant.fromMap(String variantId, Map<String, dynamic> variantMap) {
    return Variant(
      id: variantId,
      name: variantMap['name'],
      price: double.tryParse(variantMap['price'].toString()) ?? 0.0,
      amount: double.tryParse(variantMap['amount'].toString()) ?? 0.0,
      voucherCodes: (variantMap['voucherCodes'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [], // Ensure voucherCodes is a list
    );
  }
}
