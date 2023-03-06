import 'package:flukefy_admin/view/screens/product/widgets/image_slider.dart';
import 'package:flukefy_admin/view/screens/product/widgets/product_details.dart';
import 'package:flutter/material.dart';

import '../../../model/product.dart';
import '../../widgets/general/curved_app_bar.dart';

class ProductScreen extends StatelessWidget {
  final Product product;
  final String imageHeroTag;

  const ProductScreen({Key? key, required this.product, required this.imageHeroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight / 1.7;
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            ImageSlider(images: product.images, imageHeroTag: imageHeroTag, imageHeight: imageHeight),
            // Appbar
            SizedBox(height: MediaQuery.of(context).viewPadding.top + 50, child: CurvedAppBar(title: product.name)),
            // Product details
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ProductDetails(product: product, boxHeight: (screenHeight - imageHeight) + 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
