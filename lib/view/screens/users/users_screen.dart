import 'package:flukefy_admin/utils/colors.dart';
import 'package:flukefy_admin/view/screens/users/widgets/user_card.dart';
import 'package:flukefy_admin/view/widgets/general/curved_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/result.dart';
import '../../../model/user.dart';
import '../../../view_model/users_provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColors.backgroundColor,
      appBar: const CurvedAppBar(
        title: 'Users',
      ),
      body: Consumer<UsersProvider>(
        builder: (ctx, provider, child) {
          List<User> users = provider.users;
          if (provider.status == Status.success) {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (buildContext, index) {
                return UserCard(user: users[index]);
              },
            );
          } else if (provider.status == Status.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.status == Status.error) {
            return const Center(
              child: Text("Error"),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
