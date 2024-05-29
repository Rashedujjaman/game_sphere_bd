import 'package:game_sphere_bd/models/variant.dart';

class ProductModel {
  String id;
  String name;
  String description;
  String imageUrl;
  double rating;
  Map<String, Variant> variant;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.variant,
    required this.rating,
  });

  factory ProductModel.fromFirestore(String id, Map<String, dynamic> data) {
    if (!data.containsKey('name') ||
        !data.containsKey('imageUrl') ||
        !data.containsKey('variant')) {
      throw ArgumentError(
          'Product data is missing required fields'); // Or provide default values
    }

    Map<String, Variant> variants = {};
    (data['variant'] as Map<String, dynamic>).forEach((key, value) {
      variants[key] = Variant.fromMap(key, value);
    });

    return ProductModel(
      id: id,
      name: data['name'],
      imageUrl: data['imageUrl'],
      description: data['description'],
      rating: double.tryParse(data['rating'].toString()) ?? 0.0,
      variant: variants,
    );
  }
}
