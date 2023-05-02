import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flukefy_admin/view_model/users_provider.dart';
import 'package:flukefy_admin/view_model/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../model/result.dart';
import '../services/firebase_service.dart';
import '../utils/constant.dart';
import '../view/screens/home/home_screen.dart';
import 'brand_provider.dart';
import 'products_provider.dart';

class SplashProvider extends ChangeNotifier {
  void init(BuildContext context) async {
    // For checking internet connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      Result<int> serverUpdateCode = await FirebaseService.getUpdateCode();
      if (serverUpdateCode.data == updateCode) {
        loadFromFirebase(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        // If update code is not matching, show update dialog
        showUpdateDialog(context, 'Update is available', 'Please update to latest version');
        // If update code fetching problem, show error in toast
        if (serverUpdateCode.status != Status.success) Helper.showToast(serverUpdateCode.message!, Colors.red);
      }
    } else {
      // If not connected network
      showUpdateDialog(context, 'Connection problem', 'Please check your internet connection');
    }
  }

  void loadFromFirebase(BuildContext context) async {
    Provider.of<ProductsProvider>(context, listen: false).loadProducts();
    Provider.of<BrandsProvider>(context, listen: false).loadBrands();
    Provider.of<UsersProvider>(context, listen: false).loadUsers();
  }

  void showUpdateDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
