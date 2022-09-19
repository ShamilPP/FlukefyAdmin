import 'package:flukefy_admin/model/product_model.dart';
import 'package:flukefy_admin/services/firebase_service.dart';
import 'package:flukefy_admin/utils/enums/status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'brand_view_model.dart';

class ProductsViewModel extends ChangeNotifier {
  List<ProductModel> _products = [];
  Status _productsStatus = Status.loading;

  List<ProductModel> get products => _products;

  Status get productsStatus => _productsStatus;

  void loadProducts(BuildContext ctx) async {
    var brandProvider = Provider.of<BrandsViewModel>(ctx, listen: false);
    await brandProvider.loadBrands();
    FirebaseService.getAllProducts(brandProvider.brands).then((result) {
      _products = result;
      setProductsStatus(Status.success);
    });
  }

  void setProductsStatus(Status status) {
    _productsStatus = status;
    notifyListeners();
  }

  void removeProduct(BuildContext context, ProductModel product) async {
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

    await FirebaseService.removeProduct(product);
    Navigator.pop(context);
    _products.remove(product);
    notifyListeners();
  }

  void uploadProduct(BuildContext context, ProductModel product, bool isUpdateProduct) async {
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
                  isUpdateProduct ? 'Updating...' : 'Uploading...',
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        });

    //Upload

    if (isUpdateProduct) {
      await FirebaseService.updateProduct(product);
    } else {
      await FirebaseService.uploadProduct(product);
    }
    loadProducts(context);

    // Close Dialog
    Navigator.pop(context);
    // Back to home screen
    Navigator.pop(context);
  }
}
