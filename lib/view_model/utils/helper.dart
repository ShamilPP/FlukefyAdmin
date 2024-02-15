import 'package:flukefy_admin/view_model/brand_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../model/brand.dart';

class Helper {
  static void showToast(String text, Color? backgroundColor) {
    Fluttertoast.showToast(
      // Return userDocId if login was successful
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 16.0,
      textColor: Colors.white,
      webPosition: "center",
      backgroundColor: backgroundColor,
    );
  }

  static Brand? getBrand(BuildContext context, String docId) {
    var brands = Provider.of<BrandsProvider>(context, listen: false).brands;
    int brandIndex = brands.indexWhere((element) => element.docId == docId);
    if (brandIndex != -1) {
      return brands[brandIndex];
    } else {
      return null;
    }
  }

  static String getLastSeenFromDate(DateTime date) {
    DateTime currentTime = DateTime.now();
    Duration balanceTime = currentTime.difference(date);

    if (balanceTime.inSeconds < 60) {
      return 'Just now';
    } else if (balanceTime.inMinutes < 60) {
      return '${balanceTime.inMinutes} Minutes ago';
    } else if (balanceTime.inHours < 24) {
      return '${balanceTime.inHours} Hours ago';
    } else if (balanceTime.inDays < 30) {
      return '${balanceTime.inDays} Days ago';
    } else if (balanceTime.inDays < 365) {
      int months = currentTime.month - date.month + 12 * (currentTime.year - date.year);
      return '$months Months ago';
    } else {
      int years = currentTime.year - date.year;
      return '$years Years ago';
    }
  }
}

extension CheckingLink on String {
  bool get isLink => contains('https://') && !contains(' ');
}
