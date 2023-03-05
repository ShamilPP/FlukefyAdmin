import 'package:flukefy_admin/view_model/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../model/response.dart';
import '../services/firebase_service.dart';
import '../utils/constant.dart';
import '../view/screens/home/home_screen.dart';
import 'products_provider.dart';

class SplashProvider extends ChangeNotifier {
  void init(BuildContext context) async {
    Response<int> serverUpdateCode = await FirebaseService.getUpdateCode();

    if (serverUpdateCode.data != updateCode) {
      // If update code is not matching, show update dialog
      showUpdateDialog(context);
      // If update code fetching problem, show error in toast
      if (serverUpdateCode.status != Status.completed) showToast(serverUpdateCode.message!, Colors.red);
    } else {
      loadFromFirebase(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  void loadFromFirebase(BuildContext context) async {
    Provider.of<ProductsProvider>(context, listen: false).loadProducts(context);
  }

  void showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Update is available'),
        content: const Text('Please update to latest version'),
        actions: [
          ElevatedButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
