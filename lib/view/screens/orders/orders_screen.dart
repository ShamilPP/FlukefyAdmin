import 'package:flukefy_admin/view/widgets/general/curved_app_bar.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CurvedAppBar(
        title: 'Orders',
      ),
      body: Center(
        child: Text('No orders'),
      ),
    );
  }
}
