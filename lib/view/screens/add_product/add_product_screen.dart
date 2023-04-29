import 'package:flukefy_admin/model/product.dart';
import 'package:flukefy_admin/utils/colors.dart';
import 'package:flukefy_admin/view/animations/slide_animation.dart';
import 'package:flukefy_admin/view/screens/add_product/widgets/brand_selector.dart';
import 'package:flukefy_admin/view/screens/add_product/widgets/image_selector.dart';
import 'package:flukefy_admin/view/widgets/buttons/black_button.dart';
import 'package:flukefy_admin/view/widgets/general/curved_app_bar.dart';
import 'package:flukefy_admin/view/widgets/general/curved_dialog.dart';
import 'package:flukefy_admin/view/widgets/text_field/outlined_text_field.dart';
import 'package:flukefy_admin/view_model/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

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
  final RoundedLoadingButtonController buttonController = RoundedLoadingButtonController();

  final nameController = TextEditingController();
  final descController = TextEditingController();
  final ratingController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final stockController = TextEditingController();

  int discountPrice = 0;

  @override
  void dispose() {
    ImageSelector.imagesNotifier.value = [];
    ImageSelector.removedImagesNotifier.value = [];
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
      stockController.text = widget.product!.stock.toString();
      updateDiscountPrice(widget.product!.price.toString());
      BrandSelector.brandNotifier.value = widget.product!.brandId;
      ImageSelector.imagesNotifier.value = widget.product!.images;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CurvedAppBar(title: widget.isUpdateProduct ? 'Edit product' : 'Add product'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SlideAnimation(delay: 200, child: ImageSelector()),
            // TextFields
            SlideAnimation(delay: 300, child: OutlinedTextField(hint: 'Name', controller: nameController)),
            SlideAnimation(delay: 400, child: OutlinedTextField(hint: 'Description', controller: descController, maxLines: 5)),
            SlideAnimation(delay: 500, child: const BrandSelector()),
            SlideAnimation(
                delay: 600, child: OutlinedTextField(hint: 'Rating', controller: ratingController, numberKeyboard: true)),
            SlideAnimation(
              delay: 700,
              child: OutlinedTextField(
                hint: 'Price',
                controller: priceController,
                numberKeyboard: true,
                onChanged: updateDiscountPrice,
              ),
            ),
            SlideAnimation(
              delay: 800,
              child: OutlinedTextField(
                  hint: 'Discount %', controller: discountController, numberKeyboard: true, suffixText: '₹$discountPrice'),
            ),
            SlideAnimation(
              delay: 900,
              child: OutlinedTextField(hint: 'Stock', controller: stockController, numberKeyboard: true),
            ),

            // Upload button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SlideAnimation(
                delay: 1000,
                child: RoundedLoadingButton(
                  controller: buttonController,
                  color: primaryColor,
                  successColor: Colors.green,
                  onPressed: uploadProduct,
                  child: Text(widget.isUpdateProduct ? 'Update' : 'Upload'),
                ),
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

  void uploadProduct() async {
    String name = nameController.text;
    String desc = descController.text;
    String? brandId = BrandSelector.brandNotifier.value;
    double? rating = double.tryParse(ratingController.text);
    int? price = int.tryParse(priceController.text);
    int? discount = int.tryParse(discountController.text);
    int? stock = int.tryParse(stockController.text);

    List<String> images = ImageSelector.imagesNotifier.value;

    rating ??= 0;
    price ??= 0;
    discount ??= 0;

    if (name != '' &&
        desc != '' &&
        brandId != null &&
        (rating >= 1 && rating <= 5) &&
        price != 0 &&
        stock != null &&
        images.isNotEmpty) {
      Product product = Product(
        docId: widget.isUpdateProduct ? widget.product!.docId : null,
        name: name,
        description: desc,
        brandId: brandId,
        images: images,
        rating: rating,
        price: price,
        stock: stock,
        discount: discount,
      );

      // Show uploading dialog
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 25),
                  Text(
                    widget.isUpdateProduct ? 'Updating...' : 'Uploading...',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          });

      if (widget.isUpdateProduct) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(product, ImageSelector.removedImagesNotifier.value);
      } else {
        await Provider.of<ProductsProvider>(context, listen: false).createProduct(product);
      }
      // Close Dialog
      Navigator.pop(context);
      buttonController.success();
      await Future.delayed(const Duration(milliseconds: 500));
      // Back to home screen
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (ctx) {
          return CurvedDialog(
            title: 'Failed !',
            closeButton: false,
            content: const Text('Product uploading failed, please fill empty box then try again'),
            button: BlackButton(
                title: 'Close',
                fontSize: 15,
                onPressed: () {
                  Navigator.pop(context);
                }),
          );
        },
      );
      buttonController.error();
      await Future.delayed(const Duration(seconds: 2));
      buttonController.reset();
    }
  }
}
