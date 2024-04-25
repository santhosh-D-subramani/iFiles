import 'dart:io';

import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:open_file/open_file.dart';
import 'package:xfiles/widgets/empty_folder_screen.dart';
import 'package:xfiles/widgets/error_screen.dart';
import 'package:xfiles/widgets/loading_screen.dart';

import '../common/common.dart';
import '../support/share_prefs.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key, required this.entity});

  final String entity;

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final FileManagerController controller = FileManagerController();
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  final BoolStorage _boolStorage = BoolStorage();

  bool _boolValue = false;

  Future<void> _loadBoolValue() async {
    bool value = await _boolStorage.getBool();
    setState(() {
      _boolValue = value;
    });
  }

  Future<void> _toggleBoolValue() async {
    bool newValue = !_boolValue;
    await _boolStorage.setBool(newValue);
    setState(() {
      _boolValue = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBoolValue();
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
                      leading: !_boolValue
                          ? const Icon(CupertinoIcons.check_mark)
                          : null,
                      onTap: () {
                        _toggleBoolValue();
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
                        FileSystemEntity entity = entities[index];

                        return Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            dismissible: DismissiblePane(
                              onDismissed: () async {
                                FileManager.isDirectory(entity)
                                    ? await entity.delete(recursive: true)
                                    : await entity.delete();
                                if (await entity.exists()) {
                                } else {
                                  setState(() {});
                                }
                              },
                            ),
                            children: [
                              SlidableAction(
                                onPressed: (value) async {
                                  FileManager.isDirectory(entity)
                                      ? await entity.delete(recursive: true)
                                      : await entity.delete();
                                  if (await entity.exists()) {
                                  } else {
                                    setState(() {});
                                  }
                                },
                                label: 'Delete',
                                backgroundColor: CupertinoColors.destructiveRed,
                              ),
                            ],
                          ),
                          child: CupertinoListTile(
                            leading: FileManager.isFile(entities[index])
                                ? const Icon(CupertinoIcons.doc_fill)
                                : const Icon(CupertinoIcons.folder_fill),
                            trailing: FileManager.isDirectory(entities[index])
                                ? const Icon(CupertinoIcons.chevron_forward)
                                : Text(getFileSize(entities[index].path)),
                            subtitle: FutureBuilder(
                                future: dateFetcher(entity),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data.toString());
                                  } else {
                                    return Center(
                                      child: Text(
                                        '${snapshot.error} occurred',
                                      ),
                                    );
                                  }
                                }),
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
                                      'current path Folder: ${controller.getCurrentPath}');
                                }
                                // open directory
                              } else {
                                // Perform file-related tasks.
                                try {
                                  String filePath =
                                      '${controller.getCurrentPath}/${FileManager.basename(entities[index])}';
                                  OpenFile.open(filePath);
                                } on Exception catch (e) {
                                  if (kDebugMode) {
                                    print('file open error : $e');
                                  }
                                }
                              }
                            },
                            title: Text(FileManager.isDirectory(entity)
                                ? FileManager.basename(entity)
                                : _boolValue
                                    ? entity.path
                                        .split('/')
                                        .last
                                        .split('.')
                                        .first
                                    : FileManager.basename(entity)),
                          ),
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
