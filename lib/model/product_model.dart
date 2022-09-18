class ProductModel {
  String? docId;
  final String name;
  final String description;
  final String category;
  final List<String> images;
  final double rating;
  final int price;
  final int discount;

  ProductModel({
    this.docId,
    required this.name,
    required this.description,
    required this.category,
    required this.images,
    required this.rating,
    required this.price,
    required this.discount,
  });
}
