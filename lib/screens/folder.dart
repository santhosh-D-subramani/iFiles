import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xfiles/widgets/empty_folder_screen.dart';
import 'package:xfiles/widgets/error_screen.dart';
import 'package:xfiles/widgets/loading_screen.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key, required this.entity});

  final String entity;

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final FileManagerController controller = FileManagerController();

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

  @override
  void initState() {
    super.initState();
    controller.setCurrentPath = widget.entity;
    if (kDebugMode) {
      print('current path init state call: ${controller.getCurrentPath}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: ValueListenableBuilder(
            valueListenable: controller.titleNotifier,
            builder: (context, title, _) {
              return Text(title);
            }),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              fillOverscroll: true,
              hasScrollBody: true,
              child: FileManager(
                emptyFolder: emptyFolderScreen(),
                loadingScreen: loadingScreen(),
                errorBuilder: (context, error) => errorScreen(error),
                hideHiddenEntity: false,
                controller: controller,
                builder: (context, snapshot) {
                  List<FileSystemEntity> entities = snapshot;

                  controller.setCurrentPath = widget.entity;

                  if (kDebugMode) {
                    print(
                        'current path inside loop: ${controller.getCurrentPath}');
                  }
                  return CupertinoListSection.insetGrouped(
                    footer: Center(child: Text('${entities.length + 1} items')),
                    header: const Text(''),
                    children: [
                      ...List.generate(entities.length, (index) {
                        return CupertinoListTile(
                          leading: FileManager.isFile(entities[index])
                              ? const Icon(CupertinoIcons.doc_fill)
                              : const Icon(CupertinoIcons.folder_fill),
                          trailing: FileManager.isDirectory(entities[index])
                              ? const Icon(CupertinoIcons.chevron_forward)
                              : Text(getFileSize(entities[index].path)),
                          onTap: () {
                            if (FileManager.isDirectory(entities[index])) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => FolderScreen(
                                          entity: entities[index].path,
                                        )),
                              );
                              // open directory
                            } else {
                              // Perform file-related tasks.
                            }
                          },
                          title: Text(FileManager.basename(entities[index])),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
