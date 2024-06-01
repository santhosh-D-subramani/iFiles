import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowAllExtensionPrefs with ChangeNotifier {
  bool _value = false;

  ShowAllExtensionPrefs() {
    _loadFromPrefs();
  }

  bool get value => _value;

  void toggleValue() {
    _value = !_value;
    _saveToPrefs();
    notifyListeners();
  }

  void _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _value = prefs.getBool('ShowAllExtensionPrefsBoolValue') ?? false;
    notifyListeners();
  }

  void _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('ShowAllExtensionPrefsBoolValue', _value);
  }
}
