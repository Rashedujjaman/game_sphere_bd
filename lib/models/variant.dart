class Variant {
  final int id;
  final String name;
  final double price;
  final int amount;

  Variant(
      {required this.id,
      required this.name,
      required this.price,
      required this.amount});

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      amount: json['amount'],
    );
  }
}
