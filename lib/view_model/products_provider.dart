import 'package:flukefy_admin/model/product.dart';
import 'package:flukefy_admin/services/firebase_service.dart';
import 'package:flukefy_admin/view_model/utils/helper.dart';
import 'package:flutter/material.dart';

import '../model/response.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  Status _productsStatus = Status.loading;

  List<Product> get products => _products;

  Status get productsStatus => _productsStatus;

  void loadProducts() {
    FirebaseService.getAllProducts().then((response) {
      _productsStatus = response.status;
      if (_productsStatus == Status.completed && response.data != null) {
        _products = response.data!;
      } else {
        _products = [];
      }
      notifyListeners();
    });
  }

  Future removeProduct(BuildContext context, Product product) async {
    await FirebaseService.removeProduct(product);
    _products.remove(product);
    notifyListeners();
  }

  Future updateProduct(Product product, List<String> removedImages) async {
    // Uploading new images
    for (int i = 0; i < product.images.length; i++) {
      // If not link means image not uploaded
      if (!product.images[i].isLink) {
        // Set image name
        String imageExtension = product.images[i].substring(product.images[i].lastIndexOf("."));
        String imageName = 'IMG ${DateTime.now().millisecondsSinceEpoch}$imageExtension';
        // Upload image to firebase storage
        Response<String> imageUrl = await FirebaseService.uploadImage(product.images[i], imageName);
        // to add image list
        if (imageUrl.data != null && imageUrl.status == Status.completed) product.images[i] = imageUrl.data!;
      }
    }

    // Deleting images from firebase storage
    for (var image in removedImages) {
      await FirebaseService.removeImage(image);
    }

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
  }

  Future createProduct(Product product) async {
    List<String> imagesUrls = [];
    // Images Upload
    for (var image in product.images) {
      // Set image name
      String imageExtension = image.substring(image.lastIndexOf("."));
      String imageName = 'IMG ${DateTime.now().millisecondsSinceEpoch}$imageExtension';
      // Upload image to firebase storage
      Response<String> imageUrl = await FirebaseService.uploadImage(image, imageName);
      // to add image list
      if (imageUrl.data != null && imageUrl.status == Status.completed) imagesUrls.add(imageUrl.data!);
    }
    //Setting image url to product
    product.images = imagesUrls;

    // Uploading product
    var productResponse = await FirebaseService.createProduct(product);
    if (productResponse.data != null && productResponse.status == Status.completed) {
      // Add product to list
      _products.add(productResponse.data!);
      notifyListeners();
    }
  }
}
