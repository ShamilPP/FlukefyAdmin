import 'package:flukefy_admin/model/product.dart';
import 'package:flukefy_admin/view/animations/slide_animation.dart';
import 'package:flukefy_admin/view/screens/add_product/add_product_screen.dart';
import 'package:flukefy_admin/view/widgets/buttons/black_button.dart';
import 'package:flukefy_admin/view/widgets/general/curved_dialog.dart';
import 'package:flukefy_admin/view_model/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../product/product_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imageHeroTag = 'image${product.docId}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProductScreen(
                          product: product,
                          imageHeroTag: imageHeroTag,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              leading: SlideAnimation(
                delay: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Hero(
                    tag: imageHeroTag,
                    child: Image.network(
                      product.images[0],
                      height: 70,
                      width: 70,
                      fit: BoxFit.contain,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                            height: 70, width: 80, child: Center(child: SpinKitPulse(color: Colors.black, size: 20)));
                      },
                    ),
                  ),
                ),
              ),
              title: SlideAnimation(
                delay: 300,
                child: Text(
                  product.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: SlideAnimation(
                delay: 400,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: '₹${product.price - (product.price * product.discount ~/ 100)}\t ',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 16,
                          )),
                      TextSpan(
                        text: '₹${product.price}',
                        style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              trailing: SlideAnimation(
                delay: 500,
                child: PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AddProductScreen(isUpdateProduct: true, product: product)));
                        break;
                      case 'Delete':
                        deleteProduct(context);
                        break;
                    }
                  },
                ),
              ),
            ),
          ),
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
            // Show deleting dialog
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return AlertDialog(
                    content: Row(
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(width: 25),
                        Text(
                          'Deleting....',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  );
                });
            await Provider.of<ProductsProvider>(context, listen: false).removeProduct(context, product);
            // Close 'Deleting' Dialog
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
