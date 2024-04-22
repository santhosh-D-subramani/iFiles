import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'folder.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key, required this.title});

  final String title;

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: ValueListenableBuilder(
            valueListenable: controller.titleNotifier,
            builder: (context, title, _) {
              return Text(title == '0' ? widget.title : title);
            }),
      ),
      child: SafeArea(
        child: FileManager(
          emptyFolder: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.folder_fill,
                  size: 50,
                  color: CupertinoColors.systemGrey,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Folder is Empty',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          loadingScreen: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.folder_fill,
                  size: 50,
                  color: CupertinoColors.systemGrey,
                ),
                SizedBox(
                  height: 8,
                ),
                CupertinoActivityIndicator(),
              ],
            ),
          ),
          errorBuilder: (context, error) => Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.folder_fill,
                    size: 50,
                    color: CupertinoColors.systemGrey,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    error.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          hideHiddenEntity: false,
          controller: controller,
          builder: (context, snapshot) {
            List<FileSystemEntity> entities = snapshot;

            return CupertinoListSection.insetGrouped(
              header: const Text(''),
              children: [
                ...List.generate(entities.length, (index) {
                  if (!(FileManager.isDirectory(entities[index]))) {
                    print('file size ${getFileSize(entities[index].path)}');
                  }
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

                        if (kDebugMode) {
                          print(
                              'current path document: ${controller.getCurrentPath}');
                        }
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
    );
  }
}
