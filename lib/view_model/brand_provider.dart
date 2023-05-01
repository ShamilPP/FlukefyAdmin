import 'package:flukefy_admin/model/brand.dart';
import 'package:flukefy_admin/services/firebase_service.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';
import '../model/result.dart';

class BrandsProvider extends ChangeNotifier {
  List<Brand> _brands = [];

  // Brands fetching status
  Status _status = Status.loading;

  List<Brand> get brands => _brands;

  Status get status => _status;

  void loadBrands() {
    FirebaseService.getAllCategory().then((result) {
      _status = result.status;
      if (_status == Status.success && result.data != null) {
        _brands = result.data!;
      } else {
        _brands = [];
      }
      notifyListeners();
    });
  }

  Future createBrand(BuildContext context, Brand brand) async {
    var brandResult = await FirebaseService.createCategory(brand);

    if (brandResult.status == Status.success && brandResult.data != null) {
      Brand newBrand = brandResult.data!;
      _brands.add(newBrand);
      notifyListeners();
    }
  }

  Future deleteBrand(BuildContext context, Brand brand) async {
    await FirebaseService.removeCategory(brand);
    _brands.remove(brand);
    notifyListeners();
  }

  List<Product> getBrandProducts(String brandId, List<Product> allProducts) {
    List<Product> brandProducts = [];
    for (var product in allProducts) {
      if (product.brandId == brandId) {
        brandProducts.add(product);
      }
    }
    if (brandProducts.isEmpty) {
      brandProducts = allProducts.toList()..shuffle();
    }
    return brandProducts;
  }
}
