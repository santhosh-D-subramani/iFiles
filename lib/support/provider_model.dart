import 'package:flutter/material.dart';

class MyStringModel extends ChangeNotifier {
  String _myString = '';
  String _isFile = '';
  String _taskName = '';
  String _internalStorageRootDirectory = '';
  String _sdCardRootDirectory = '';
  bool _showAllExtension = false;

  String get myString => _myString;

  String get isFile => _isFile;

  String get taskName => _taskName;

  String get internalStorageRootDirectory => _internalStorageRootDirectory;

  String get sdCardRootDirectory => _sdCardRootDirectory;

  bool get showAllExtension => _showAllExtension;

  void setShowAllExtension(bool value) {
    _showAllExtension = value;
    notifyListeners();
  }

  void setStoragePath(String internal, String external) {
    _internalStorageRootDirectory = internal;
    _sdCardRootDirectory = external;
    notifyListeners();
  }

  ///copy move
  void updateString(String path, String isFile, String taskName) {
    _myString = path;
    _isFile = isFile;
    _taskName = taskName;
    notifyListeners(); // Notify listeners of the change
  }
}
