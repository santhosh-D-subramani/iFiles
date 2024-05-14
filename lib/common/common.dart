import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';

const appName = 'iFiles';
const browsePageTitle = 'Browse';

Future<void> copyPath(String from, String to) async {
  if (!await Directory(from).exists()) {
    if (kDebugMode) {
      print('source directory not found');
    }
  }

  if (!await Directory(to).exists()) {
    await Directory(to).create(recursive: true);
  }

  // await Directory(to).create(recursive: true);
  await for (final file in Directory(from).list(recursive: true)) {
    await Directory('$to${from.split('/').last}').create(recursive: true);
    if (kDebugMode) {
      print(from.split('/').last);
    }
    String copyFolderName = '$to${from.split('/').last}';
    if (kDebugMode) {
      print(copyFolderName);
    }
    final copyTo = join(copyFolderName, relative(file.path, from: from));
    if (kDebugMode) {
      print(copyTo);
    }
    if (file is Directory) {
      await Directory(copyTo).create(recursive: true);
    } else if (file is File) {
      await File(file.path).copy(copyTo);
    } else if (file is Link) {
      await Link(copyTo).create(await file.target(), recursive: true);
    }
  }
}

Future<void> copyFiles(String from, String to) async {
  Directory destDir = Directory(to);
  if (!await Directory(to).exists()) {
    await destDir.create(recursive: true);
  }
  String fileName = basename(from); // Using path package to get the basename
  String fullPath = join(
      to, fileName); // Using path package to create the full destination path

  // Perform the copy operation
  await File(from).copy(fullPath);

  // Debug output
  if (kDebugMode) {
    print('Copied from: $from');
  }
  if (kDebugMode) {
    print('Copied to: $fullPath');
  }
}

Future<void> moveFile(String from, String to) async {
  await copyFiles(from, to); // move file
  await File(from).delete(recursive: true); // Delete the original directory
  if (kDebugMode) {
    print('Moved from: $from');
  }
  if (kDebugMode) {
    print('Moved to: $to');
  }
}

Future<void> movePath(String from, String to) async {
  await copyPath(from, to); // Copy files and folders
  await Directory(from)
      .delete(recursive: true); // Delete the original directory
  if (kDebugMode) {
    print('Moved from: $from');
  }
  if (kDebugMode) {
    print('Moved to: $to');
  }
}

Future<void> zipTheFile(Directory sourcePath, String fileName) async {
  final files = <File>[];
  files.add(File(fileName));
  String fileNameEnd = fileName.split('.').first;
  int suffix = 1;

  final zipFile = _createZipFile(
      sourcePath.path, "${fileName.split('/').last.split('.').first}.zip");
  if (kDebugMode) {
    print("Writing file to zip file in: ${zipFile.path}");
  }
  try {
    await ZipFile.createFromFiles(
        sourceDir: sourcePath,
        files: files,
        zipFile: zipFile,
        includeBaseDirectory: false);
  } on PlatformException catch (e) {
    if (kDebugMode) {
      print('zip error : $e');
    }
  }
}

File _createZipFile(currentPath, fileName) {
  int suffix = 1;
  String fileNAmeEnd = fileName;
  while (true) {
    if (!File('$currentPath/$fileNAmeEnd').existsSync()) {
      break; // Exit the loop if the file doesn't exist
    }

    // Extract the suffix from the filename
    RegExp regExp = RegExp(r'(\d+)(?=.zip$)');
    Match? match = regExp.firstMatch(fileNAmeEnd);
    if (match != null) {
      suffix = int.parse(match.group(0)!) + 1; // Increment the extracted suffix
      fileNAmeEnd = fileNAmeEnd.replaceAll(regExp, '$suffix');
    } else {
      fileNAmeEnd = '$fileName$suffix.zip'; // If no suffix found, add one
    }

    // if (suffix > 10000) {
    //   // Exit loop to prevent infinite loop (optional check)
    //   print('Suffix exceeded limit, exiting loop.');
    //   break;
    // }
  }
  final zipFile = File('$currentPath/$fileNAmeEnd');

  return zipFile;
}

String getFileSize(String path) {
  File file = File(path);
  int fileSizeInBytes = file.lengthSync();
  double fileSizeInKB = fileSizeInBytes / 1024; // Convert bytes to kilobytes
  double fileSizeInMB = fileSizeInKB / 1024;
  double fileSizeInGB = fileSizeInMB / 1024;
  return fileSizeInKB < 1
      ? '${fileSizeInBytes.toStringAsFixed(1)} B'
      : fileSizeInMB < 1
          ? '${fileSizeInKB.toStringAsFixed(1)} Kb'
          : fileSizeInGB < 1
              ? '${fileSizeInMB.toStringAsFixed(1)} Mb'
              : fileSizeInGB > 1
                  ? '${fileSizeInGB.toStringAsFixed(1)} Gb'
                  : '';
}

createFolder(BuildContext context, FileManagerController controller) {
  showDialog(
      context: context,
      builder: (context) {
        TextEditingController folderName = TextEditingController();
        return CupertinoAlertDialog(
          title: const Text('New Folder'),
          content: CupertinoListTile(
              title: CupertinoTextField(
            controller: folderName,
          )),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                try {
                  // Create Folder
                  if (folderName.text.isNotEmpty) {
                    await FileManager.createFolder(
                        controller.getCurrentPath, folderName.text);
                    // Open Created Folder
                    controller.setCurrentPath =
                        "${controller.getCurrentPath}/${folderName.text}";
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print('error creating folder: $e');
                  }
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
            CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
          ],
        );
      });
}

Future<dynamic> show(BuildContext context, Widget builder, bool expand) {
  return showCupertinoModalBottomSheet(
    expand: expand,
    isDismissible: true,
    context: context,
    backgroundColor: CupertinoColors.secondarySystemBackground,
    builder: (context) => builder,
  );
}

Future<dynamic> dateFetcher(var entity) async {
  DateTime date = (await entity.stat()).modified;
  DateTime now = DateTime.now();
  var i = now.day.compareTo(date.day);
  String formattedDate = DateFormat('dd/MM/yy').format(date);

  return i == 0
      ? DateFormat('h:mm a').format(date)
      : i == 1
          ? 'Yesterday'
          : formattedDate;
}

final DecorationTween tween = DecorationTween(
  begin: BoxDecoration(
    color: CupertinoColors.white,
    boxShadow: const <BoxShadow>[],
    borderRadius: BorderRadius.circular(20.0),
  ),
  end: BoxDecoration(
    color: CupertinoColors.white,
    boxShadow: CupertinoContextMenu.kEndBoxShadow,
    borderRadius: BorderRadius.circular(20.0),
  ),
);
