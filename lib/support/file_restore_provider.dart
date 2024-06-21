import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/file_restore_model.dart';

class FileProvider with ChangeNotifier {
  List<FileModel> _trash = [];

  List<FileModel> get trash => _trash;

  FileProvider() {
    _loadTrash();
  }

  Future<void> _loadTrash() async {
    final prefs = await SharedPreferences.getInstance();
    final trashData = prefs.getString('trash') ?? '[]';
    _trash = (jsonDecode(trashData) as List)
        .map((item) => FileModel.fromJson(item))
        .toList();
    notifyListeners();
  }

  Future<void> _saveTrash() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'trash', jsonEncode(_trash.map((file) => file.toJson()).toList()));
  }

  Future<void> deleteFile(
    String filePath,
    String fileName,
    // DateTime lastModified
  ) async {
    final newFile = FileModel(
      path: filePath,
      name: fileName,
      // lastModified: lastModified,
    );

    _trash.add(newFile);
    print('_trash length : ${_trash.length}');
    print('_trash : $_trash');
    await _saveTrash();
    notifyListeners();
  }

  Future<void> restoreFile(FileModel file) async {
    _trash.removeWhere((f) => f.path == file.path);
    await _saveTrash();
    notifyListeners();
  }
}
