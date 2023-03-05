import 'package:flukefy_admin/view/widgets/general/curved_app_bar.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CurvedAppBar(
        title: 'Users',
      ),
      body: Center(
        child: Text('No Users'),
      ),
    );
  }
}
