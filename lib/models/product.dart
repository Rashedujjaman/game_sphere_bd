import 'package:game_sphere_bd/models/variant.dart';

class ProductModel {
  int id;
  String name;
  String description;
  String image;
  double rating = 4.5;
  List<Variant> variants;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.variants,
  });

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        image = json['image'],
        variants = (json['variants'] as List<dynamic>)
            .map((variantJson) => Variant.fromJson(variantJson))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'variants': variants,
    };
  }
}
