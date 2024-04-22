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
          hideHiddenEntity: false,
          controller: controller,
          builder: (context, snapshot) {
            List<FileSystemEntity> entities = snapshot;

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
