import 'package:flukefy_admin/view/screens/product/widgets/similar_products.dart';
import 'package:flutter/material.dart';

import '../../../../model/product.dart';
import '../../../../view_model/utils/helper.dart';
import '../../../animations/fade_animation.dart';

class ProductDetails extends StatelessWidget {
  final Product product;
  final double boxHeight;

  const ProductDetails({Key? key, required this.product, required this.boxHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: boxHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3)),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              // Rating
              Positioned(
                top: 0,
                right: 0,
                child: FadeAnimation(
                  delay: 500,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      '${product.rating} ★',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  FadeAnimation(
                    delay: 100,
                    child: Text(Helper.getBrand(context, product.brandId)!.name,
                        style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                  const SizedBox(height: 5),
                  // Product name
                  FadeAnimation(delay: 200, child: Text(product.name, style: const TextStyle(fontSize: 19))),
                  const SizedBox(height: 5),
                  // Price
                  FadeAnimation(
                    delay: 300,
                    child: Row(
                      children: [
                        Text(
                          '₹${product.price}',
                          style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 17),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '₹${product.price - (product.price * product.discount ~/ 100)}',
                          style: const TextStyle(color: Colors.black, fontSize: 22),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${product.discount}% off',
                          style: const TextStyle(color: Colors.green, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Description
                  FadeAnimation(
                      delay: 400, child: Text(product.description, style: const TextStyle(color: Colors.grey, fontSize: 16))),

                  // Similar Products
                  FadeAnimation(delay: 500, child: SimilarProducts(brandId: product.brandId)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
