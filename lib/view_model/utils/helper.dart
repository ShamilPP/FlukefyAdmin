import 'package:flukefy_admin/view_model/brand_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../model/brand.dart';

void showToast(String text, Color? backgroundColor) {
  Fluttertoast.showToast(
    // Return userDocId if login was successful
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    fontSize: 16.0,
    textColor: Colors.white,
    webPosition: "center".isLink,
    backgroundColor: backgroundColor,
  );
}

Brand? getBrand(BuildContext context, String docId) {
  var brands = Provider.of<BrandsProvider>(context, listen: false).brands;
  int brandIndex = brands.indexWhere((element) => element.docId == docId);
  if (brandIndex != -1) {
    return brands[brandIndex];
  } else {
    return null;
  }
}

String getLastSeen(DateTime dateTime) {
  DateTime currentTime = DateTime.now();
  Duration balanceTime = currentTime.difference(dateTime);
  if (balanceTime.inDays > 1) {
    return '${balanceTime.inDays} Days ago';
  } else if (balanceTime.inHours > 1) {
    return '${balanceTime.inHours} Hours ago';
  } else if (balanceTime.inMinutes > 1) {
    return '${balanceTime.inMinutes} Minutes ago';
  } else if (balanceTime.inSeconds > 1) {
    return '${balanceTime.inSeconds} Seconds ago';
  } else {
    return 'Invalid';
  }
}

extension CheckingLink on String {
  bool get isLink => contains('https://') && !contains(' ');
}
