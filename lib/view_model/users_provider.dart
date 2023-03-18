import 'package:flukefy_admin/model/user.dart';
import 'package:flukefy_admin/services/firebase_service.dart';
import 'package:flutter/material.dart';

import '../model/result.dart';

class UsersProvider extends ChangeNotifier {
  List<User> _users = [];

  // Users fetching status
  Status _status = Status.loading;

  List<User> get users => _users;

  Status get status => _status;

  void loadUsers() {
    FirebaseService.getAllUsers().then((result) {
      _status = result.status;
      if (_status == Status.success && result.data != null) {
        _users = result.data!;
      } else {
        _users = [];
      }
      notifyListeners();
    });
  }
}
