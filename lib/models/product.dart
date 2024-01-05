import 'package:game_sphere_bd/models/variant.dart';

class ProductModel {
  int id;
  String name;
  String description;
  String image;
  String rating = '4.5';
  Variant variant;
  ProductModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.variant});

  ProductModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        image = json['image'],
        variant = json['variant'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'variant': variant,
    };
  }
}
