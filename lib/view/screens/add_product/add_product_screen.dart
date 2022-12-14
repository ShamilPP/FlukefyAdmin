import 'package:flukefy_admin/model/brand.dart';
import 'package:flukefy_admin/model/product.dart';
import 'package:flukefy_admin/view/screens/add_product/widgets/brand_selector.dart';
import 'package:flukefy_admin/view/screens/add_product/widgets/image_selector.dart';
import 'package:flukefy_admin/view/widgets/buttons/black_button.dart';
import 'package:flukefy_admin/view/widgets/general/curved_dialog.dart';
import 'package:flukefy_admin/view/widgets/text_field/outlined_text_field.dart';
import 'package:flukefy_admin/view_model/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  final bool isUpdateProduct;
  final Product? product;

  const AddProductScreen({
    Key? key,
    this.isUpdateProduct = false,
    this.product,
  }) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();

  final descController = TextEditingController();

  final ratingController = TextEditingController();

  final priceController = TextEditingController();

  final discountController = TextEditingController();

  int discountPrice = 0;

  @override
  void dispose() {
    ImageSelector.imagesNotifier.value = [];
    BrandSelector.brandNotifier.value = null;
    super.dispose();
  }

  @override
  void initState() {
    if (widget.isUpdateProduct) {
      nameController.text = widget.product!.name;
      descController.text = widget.product!.description;
      ratingController.text = widget.product!.rating.toString();
      priceController.text = widget.product!.price.toString();
      discountController.text = widget.product!.discount.toString();
      updateDiscountPrice(widget.product!.price.toString());
      BrandSelector.brandNotifier.value = widget.product!.brand;
      ImageSelector.imagesNotifier.value = widget.product!.images;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isUpdateProduct ? 'Edit product' : 'Add product')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.isUpdateProduct ? const SizedBox() : const ImageSelector(),

            // TextFields
            OutlinedTextField(hint: 'Name', controller: nameController),
            OutlinedTextField(hint: 'Description', controller: descController, maxLines: 5),
            const BrandSelector(),
            OutlinedTextField(hint: 'Rating', controller: ratingController, numberKeyboard: true),
            OutlinedTextField(
              hint: 'Price',
              controller: priceController,
              numberKeyboard: true,
              onChanged: updateDiscountPrice,
            ),
            OutlinedTextField(
              hint: 'Discount %',
              controller: discountController,
              numberKeyboard: true,
              suffixText: '???$discountPrice',
              onChanged: updateDiscountPrice,
            ),

            // Upload button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlackButton(
                title: widget.isUpdateProduct ? 'Update' : 'Upload',
                fontSize: 15,
                onPressed: () async {
                  String name = nameController.text;
                  String desc = descController.text;
                  Brand? brand = BrandSelector.brandNotifier.value;
                  double? rating = double.tryParse(ratingController.text);
                  int? price = int.tryParse(priceController.text);
                  int? discount = int.tryParse(discountController.text);
                  List<String> images = ImageSelector.imagesNotifier.value;

                  rating ??= 0;
                  price ??= 0;
                  discount ??= 0;

                  if (rating > 5 || rating < 1) {
                    rating = 0;
                  }
                  if (name != '' &&
                      desc != '' &&
                      brand != null &&
                      rating != 0 &&
                      price != 0 &&
                      images.isNotEmpty) {
                    Product product = Product(
                      docId: widget.isUpdateProduct ? widget.product!.docId : null,
                      name: name,
                      description: desc,
                      brand: brand,
                      images: images,
                      rating: rating,
                      price: price,
                      discount: discount,
                    );

                    Provider.of<ProductsProvider>(context, listen: false)
                        .uploadProduct(context, product, widget.isUpdateProduct);
                  } else {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        return CurvedDialog(
                          title: 'Failed !',
                          closeButton: false,
                          content:
                              const Text('Product uploading failed, please fill empty box then try again'),
                          button: BlackButton(
                              title: 'Close',
                              fontSize: 15,
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateDiscountPrice(String value) {
    setState(() {
      int? currentPrice = int.tryParse(priceController.text);
      int? discount = int.tryParse(discountController.text);
      if (discountController.text == '') discount = 0;
      if (currentPrice != null && discount != null) {
        discountPrice = currentPrice - (currentPrice * discount ~/ 100);
      }
    });
  }
}
