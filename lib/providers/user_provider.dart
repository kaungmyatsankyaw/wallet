import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User user = User(name: '', email: '', amount: 0, id: '');

  setUser(userData) {
    user = userData;
    notifyListeners();
  }

  getUser() => user;
}
