import 'package:flukefy_admin/model/brand.dart';

class Product {
  String? docId;
  final String name;
  final String description;
  final Brand? brand;
  final List<String> images;
  final double rating;
  final int price;
  final int discount;

  Product({
    this.docId,
    required this.name,
    required this.description,
    required this.brand,
    required this.images,
    required this.rating,
    required this.price,
    required this.discount,
  });
}
