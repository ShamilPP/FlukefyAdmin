import 'package:flukefy_admin/model/brand.dart';
import 'package:flukefy_admin/services/firebase_service.dart';
import 'package:flutter/material.dart';

import '../model/response.dart';

class BrandsProvider extends ChangeNotifier {
  List<Brand> _brands = [];
  Status _brandsStatus = Status.loading;

  List<Brand> get brands => _brands;

  Status get brandsStatus => _brandsStatus;

  void loadBrands() {
    FirebaseService.getAllCategory().then((response) {
      _brandsStatus = response.status;
      if (_brandsStatus == Status.completed && response.data != null) {
        _brands = response.data!;
      } else {
        _brands = [];
      }
      notifyListeners();
    });
  }

  Future createBrand(BuildContext context, Brand brand) async {
    var brandResponse = await FirebaseService.createCategory(brand);

    if (brandResponse.status == Status.completed && brandResponse.data != null) {
      Brand newBrand = brandResponse.data!;
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
