import 'package:flukefy_admin/model/brand.dart';
import 'package:flukefy_admin/services/firebase_service.dart';
import 'package:flutter/material.dart';

import '../model/result.dart';

class BrandsProvider extends ChangeNotifier {
  List<Brand> _brands = [];
  Status _brandsStatus = Status.loading;

  List<Brand> get brands => _brands;

  Status get brandsStatus => _brandsStatus;

  void loadBrands() {
    FirebaseService.getAllCategory().then((Result) {
      _brandsStatus = Result.status;
      if (_brandsStatus == Status.success && Result.data != null) {
        _brands = Result.data!;
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
}
