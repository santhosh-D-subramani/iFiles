import 'package:shared_preferences/shared_preferences.dart';

class BoolStorage {
  static const String _key = 'showAllExtension';

  Future<bool> getBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  Future<void> setBool(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
