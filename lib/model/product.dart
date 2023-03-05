import 'package:flukefy_admin/model/brand.dart';

class Product {
  String? docId;
  List<String> images;
  final String name;
  final String description;
  final Brand? brand;
  final double rating;
  final int price;
  final int discount;

  Product({
    this.docId,
    required this.images,
    required this.name,
    required this.description,
    required this.brand,
    required this.rating,
    required this.price,
    required this.discount,
  });
}
