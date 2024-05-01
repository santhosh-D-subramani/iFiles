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

  ///SMB server saves
  static const String _serverKey = 'serverTextEditingController';
  static const String _nameKey = 'nameTextEditingController';
  static const String _passwordKey = 'passwordTextEditingController';

  Future<String> getServerUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_serverKey) ?? 'unknown';
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? 'unknown';
  }

  Future<String> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey) ?? 'unknown';
  }

  Future<void> setServerUrl(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serverKey, value);
  }

  Future<void> setUsername(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, value);
  }

  Future<void> setPassword(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passwordKey, value);
  }
}
