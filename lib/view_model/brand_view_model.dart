import 'package:flukefy_admin/model/brand_model.dart';
import 'package:flukefy_admin/services/firebase_service.dart';
import 'package:flukefy_admin/utils/enums/status.dart';
import 'package:flukefy_admin/view/widgets/general/curved_dialog.dart';
import 'package:flutter/material.dart';

class BrandsViewModel extends ChangeNotifier {
  List<BrandModel> _brands = [];
  Status _brandsStatus = Status.loading;

  List<BrandModel> get brands => _brands;

  Status get brandsStatus => _brandsStatus;

  Future loadBrands() async {
    _brands = await FirebaseService.getAllCategory();
    setBrandsStatus(Status.success);
  }

  void setBrandsStatus(Status status) {
    _brandsStatus = status;
    notifyListeners();
  }

  void createBrand(BuildContext context, BrandModel brand) async {
    if (brand.name != '') {
      // Show creating dialog
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
                    'Creating...',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          });
      await FirebaseService.createCategory(brand);
      loadBrands();
      // Close Dialog
      Navigator.pop(context);
      // Back to home screen
      Navigator.pop(context);
    } else {
      showDialog(context: context, builder: (ctx) => const CurvedDialog(title: 'Brand name is empty'));
    }
  }

  void deleteBrand(BuildContext context, BrandModel brand) async {
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

    await FirebaseService.removeCategory(brand);
    Navigator.pop(context);
    _brands.remove(brand);
    notifyListeners();
  }
}
