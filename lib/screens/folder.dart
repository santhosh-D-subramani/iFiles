import 'dart:io';

import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:xfiles/widgets/empty_folder_screen.dart';
import 'package:xfiles/widgets/error_screen.dart';
import 'package:xfiles/widgets/loading_screen.dart';

import '../common/common.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key, required this.entity});

  final String entity;

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final FileManagerController controller = FileManagerController();
  final CustomPopupMenuController _controller = CustomPopupMenuController();

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
        trailing: CustomPopupMenu(
          controller: _controller,
          pressType: PressType.singleClick,
          child: const Icon(CupertinoIcons.ellipsis_circle, color: Colors.blue),
          menuBuilder: () => ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.4,
              child: CupertinoListSection(
                topMargin: 0,
                children: [
                  CupertinoListTile(
                    onTap: () {
                      _controller.hideMenu();
                    },
                    title: const Text('Select'),
                    trailing: const Icon(CupertinoIcons.doc_text_viewfinder),
                  ),
                  CupertinoListTile(
                    onTap: () {
                      createFolder(context, controller);
                      _controller.hideMenu();
                    },
                    title: const Text('New Folder'),
                    trailing: const Icon(
                        CupertinoIcons.slider_horizontal_below_rectangle),
                  ),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('Scan Documents')),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('Connect to Server')),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('Scan Documents')),
                  const Divider(),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('Icons')),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('List')),
                  const Divider(),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('Name')),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('Kind')),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('Date')),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('Size')),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('Tags')),
                  const Divider(),
                  CupertinoListTile(
                      onTap: () {
                        _controller.hideMenu();
                      },
                      title: const Text('Show All Extensions')),
                ],
              ),
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              fillOverscroll: true,
              hasScrollBody: false,
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
                    footer: Center(child: Text('${entities.length} items')),
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
