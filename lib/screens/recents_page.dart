import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecentsPage extends StatefulWidget {
  const RecentsPage({super.key});

  @override
  State<RecentsPage> createState() => _RecentsPageState();
}

class _RecentsPageState extends State<RecentsPage> {
  Future<List<File>>? _files;

  Future<bool> requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.isGranted;
    if (!status) {
      var result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    }
    return true;
  }

  // checks  storage permission
  void initFiles() async {
    if (await requestStoragePermission()) {
      _files = getRecentFilesFromExternalStorage();
      setState(() {});
    } else {
      if (kDebugMode) {
        print("Storage permission was denied.");
      }
    }
  }

  getRecentFilesFromExternalStorage() async {
    if (!await requestStoragePermission()) {
      throw Exception("Storage permission not granted");
    }
    // Getting the external storage directory
    // final directory = Directory('/storage/emulated/0/Download');
    ///need to work on this doest pull recents from full storage only apps directory
    final directory =
        await getApplicationDocumentsDirectory(); //File Location (Path): /data/user/0/com.santhoshDsubramani.iFiles/app_flutter/ // This path is for Android, adjust for other platforms if needed
    final files =
        directory.listSync(recursive: true).whereType<File>().toList();

    // Sorting files by their last modified date
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    return files;
  }

  @override
  void initState() {
    super.initState();
    initFiles();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.secondarySystemBackground,
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Recents'),
          trailing: Icon(CupertinoIcons.ellipsis_circle),
          // backgroundColor: CupertinoColors.secondarySystemBackground,
        ),
        child: FutureBuilder<List<File>>(
          future: _files,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.data != null) {
              return CupertinoListSection(
                children: [
                  ...List.generate(snapshot.data!.length, (index) {
                    File file = snapshot.data![index];
                    if (kDebugMode) {
                      print(file.path.split('/').last);
                    }
                    if (kDebugMode) {
                      print('Last modified: ${file.lastModifiedSync()}');
                    }

                    return CupertinoListTile(
                      title: Text(file.path.split('/').last),
                      subtitle: Text('${formatDate(file.lastModifiedSync())} '),
                    );
                  })
                ],
              );
            } else {
              return const Center(child: Text("No files found"));
            }
          },
        ));
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)} ${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}:${_addLeadingZero(dateTime.second)}';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }
}
