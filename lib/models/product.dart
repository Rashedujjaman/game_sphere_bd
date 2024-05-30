import 'package:game_sphere_bd/models/variant.dart';

class ProductModel {
  String id;
  String name;
  String description;
  String imageUrl;
  double averageRating;
  Map<String, Variant> variant;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.variant,
    required this.averageRating,
  });

  factory ProductModel.fromFirestore(String id, Map<String, dynamic> data) {
    if (!data.containsKey('name') ||
        !data.containsKey('imageUrl') ||
        !data.containsKey('variant')) {
      throw ArgumentError(
          'Product data is missing required fields'); // Or provide default values
    }

    Map<String, Variant> variant = {};
    (data['variant'] as Map<String, dynamic>).forEach((key, value) {
      variant[key] = Variant.fromMap(key, value);
    });

    return ProductModel(
      id: id,
      name: data['name'],
      imageUrl: data['imageUrl'],
      description: data['description'],
      averageRating: double.tryParse(data['averageRating'].toString()) ?? 0.0,
      variant: variant,
    );
  }
}
