import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

const appName = 'iFiles';

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
