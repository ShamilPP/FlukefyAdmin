import 'package:flukefy_admin/model/product_model.dart';
import 'package:flukefy_admin/view/screens/product/widgets/image_slider.dart';
import 'package:flukefy_admin/view/widgets/general/curved_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/products_view_model.dart';
import '../../widgets/buttons/black_button.dart';
import '../../widgets/general/curved_dialog.dart';
import '../add_product/add_product_screen.dart';

class ProductScreen extends StatelessWidget {
  final ProductModel product;

  const ProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(
        title: product.name,
        trailing: PopupMenuButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          itemBuilder: (BuildContext context) {
            return {'Edit', 'Delete'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
          onSelected: (selected) async {
            switch (selected) {
              case 'Edit':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddProductScreen(isUpdateProduct: true, product: product)));
                break;
              case 'Delete':
                deleteProduct(context);
                break;
            }
          },
        ),
      ),
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

                  Text('Brand : ${product.brand == null ? 'No Brand' : product.brand!.name}',
                      style: const TextStyle(fontSize: 15)),
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

  void deleteProduct(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => CurvedDialog(
        title: 'Delete ${product.name}',
        content: const Text('Are you sure you want to delete product'),
        closeButton: true,
        button: BlackButton(
          title: 'Delete',
          onPressed: () async {
            // Close confirmation dialog
            Navigator.pop(context);
            Provider.of<ProductsViewModel>(context, listen: false).removeProduct(context, product);
          },
        ),
      ),
    );
  }
}
