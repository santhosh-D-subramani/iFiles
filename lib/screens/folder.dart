import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class DocumentScreen2 extends StatefulWidget {
  const DocumentScreen2({super.key, required this.entity});

  final String entity;

  @override
  State<DocumentScreen2> createState() => _DocumentScreen2State();
}

class _DocumentScreen2State extends State<DocumentScreen2> {
  final FileManagerController controller = FileManagerController();

  @override
  void initState() {
    super.initState();
    controller.setCurrentPath = widget.entity;
    print('current path : ${controller.getCurrentPath}');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: ValueListenableBuilder(
            valueListenable: controller.titleNotifier,
            builder: (context, title, _) {
              return Text(title);
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

            controller.setCurrentPath = widget.entity;

            if (kDebugMode) {
              print('current path : ${controller.getCurrentPath}');
            }
            return CupertinoListSection.insetGrouped(
              header: const Text(''),
              children: [
                ...List.generate(entities.length, (index) {
                  return CupertinoListTile(
                    leading: FileManager.isFile(entities[index])
                        ? const Icon(CupertinoIcons.doc_fill)
                        : const Icon(CupertinoIcons.folder_fill),
                    onTap: () {
                      if (FileManager.isDirectory(entities[index])) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => DocumentScreen2(
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
    );
  }
}
