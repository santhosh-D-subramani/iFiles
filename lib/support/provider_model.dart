import 'package:flutter/material.dart';

class MyStringModel extends ChangeNotifier {
  String _myString = '';
  String _isFile = '';

  String get myString => _myString;

  String get isFile => _isFile;

  void updateString(String path, String isFile) {
    _myString = path;
    _isFile = isFile;
    notifyListeners(); // Notify listeners of the change
  }
}
