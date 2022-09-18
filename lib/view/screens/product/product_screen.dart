import 'package:flukefy_admin/model/product_model.dart';
import 'package:flukefy_admin/view/screens/product/widgets/image_slider.dart';
import 'package:flukefy_admin/view/widgets/general/curved_app_bar.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  final ProductModel product;

  const ProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(title: product.name),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSlider(product: product),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),

                  // Price
                  Row(
                    children: [
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(
                            color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '₹${product.price - (product.price * product.discount ~/ 100)}',
                        style: const TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${product.discount}% off',
                        style: const TextStyle(color: Colors.green, fontSize: 18),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration:
                            BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                        child: Text(
                          '${product.rating} ★',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '1 Rating',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  const Divider(thickness: 1),
                  const SizedBox(height: 10),

                  // More details
                  const Text('More details',
                      style: TextStyle(fontSize: 20, fontFamily: 'roboto', fontWeight: FontWeight.w400)),
                  const SizedBox(height: 20),

                  Text('Category : ${product.category}', style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 5),
                  Text('Description : ${product.description}', style: const TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
