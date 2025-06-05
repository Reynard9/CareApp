import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  String _userName = '';
  int? _deviceId;

  String get userName => _userName;
  int? get deviceId => _deviceId;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setDeviceId(int id) {
    _deviceId = id;
    notifyListeners();
  }
} 