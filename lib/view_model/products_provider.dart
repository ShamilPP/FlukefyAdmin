import 'package:flukefy_admin/model/product.dart';
import 'package:flukefy_admin/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/response.dart';
import 'brand_provider.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  Status _productsStatus = Status.loading;

  List<Product> get products => _products;

  Status get productsStatus => _productsStatus;

  void loadProducts(BuildContext ctx) async {
    var brandProvider = Provider.of<BrandsProvider>(ctx, listen: false);
    await brandProvider.loadBrands();
    var productsResponse = await FirebaseService.getAllProducts(brandProvider.brands);
    if (productsResponse.status == Status.completed && productsResponse.data != null) {
      _products = productsResponse.data!;
    } else {
      _products = [];
    }
    _productsStatus = productsResponse.status;
    notifyListeners();
  }

  Future removeProduct(BuildContext context, Product product) async {
    await FirebaseService.removeProduct(product);
    _products.remove(product);
    notifyListeners();
  }

  Future uploadProduct(BuildContext context, Product product, bool isUpdateProduct) async {
    // Upload
    if (isUpdateProduct) {
      // Update product
      // Updating data in firebase
      var productResponse = await FirebaseService.updateProduct(product);
      if (productResponse.data != null && productResponse.status == Status.completed) {
        var newProduct = productResponse.data!;
        // Checking old product index
        int productIndex = _products.indexWhere((element) => element.docId == newProduct.docId);
        if (productIndex != -1) {
          // Update product in product list
          _products[productIndex] = newProduct;
          notifyListeners();
        }
      }
    } else {
      // Uploading product
      var productResponse = await FirebaseService.createProduct(product);
      if (productResponse.data != null && productResponse.status == Status.completed) {
        // Add product to list
        _products.add(productResponse.data!);
        notifyListeners();
      }
    }
  }
}
