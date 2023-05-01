class Product {
  String? docId;
  List<String> images;
  final String name;
  final String description;
  final String brandId;
  final double rating;
  final int price;
  final int stock;
  final int discount;
  final DateTime createdTime;

  Product({
    this.docId,
    required this.images,
    required this.name,
    required this.description,
    required this.brandId,
    required this.rating,
    required this.price,
    required this.discount,
    required this.stock,
    required this.createdTime,
  });
}
