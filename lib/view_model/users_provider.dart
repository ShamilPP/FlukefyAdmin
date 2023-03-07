import 'package:flukefy_admin/model/brand.dart';
import 'package:flukefy_admin/model/user.dart';
import 'package:flukefy_admin/services/firebase_service.dart';
import 'package:flutter/material.dart';

import '../model/result.dart';

class UsersProvider extends ChangeNotifier {
  List<User> _users = [];
  Status _usersStatus = Status.loading;

  List<User> get users => _users;

  Status get usersStatus => _usersStatus;

  void loadUsers() {
    FirebaseService.getAllUsers().then((result) {
      _usersStatus = result.status;
      if (_usersStatus == Status.success && result.data != null) {
        _users = result.data!;
      } else {
        _users = [];
      }
      notifyListeners();
    });
  }
}
