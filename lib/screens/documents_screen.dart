import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xfiles/screens/support_screens/about_page.dart';
import 'package:xfiles/screens/support_screens/connect_ftp_page.dart';
import '../support/share_prefs.dart';
import '/widgets/error_screen.dart';
import '/widgets/loading_screen.dart';

import '../common/common.dart';
import '../widgets/empty_folder_screen.dart';
import 'folder.dart';
import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';

import 'support_screens/modal_fit.dart';
import 'support_screens/settings_page.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key, required this.title});

  final String title;

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final FileManagerController controller = FileManagerController();
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  final BoolStorage _boolStorage = BoolStorage();

  bool _boolValue = false;

  @override
  void initState() {
    super.initState();
    _loadBoolValue();
  }

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

  Animation<Decoration> _boxDecorationAnimation(Animation<double> animation) {
    return tween.animate(
      CurvedAnimation(
        parent: animation,
        curve: Interval(
          0.0,
          CupertinoContextMenu.animationOpensAt,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      navigationBar: CupertinoNavigationBar(
          middle: ValueListenableBuilder(
              valueListenable: controller.titleNotifier,
              builder: (context, title, _) {
                return Text(title == '0' ? widget.title : title);
              }),
          trailing: CustomPopupMenu(
            controller: _controller,
            enablePassEvent: false,
            pressType: PressType.singleClick,
            child:
                const Icon(CupertinoIcons.ellipsis_circle, color: Colors.blue),
            menuBuilder: () => SizedBox(
              width: MediaQuery.of(context).size.width / 1.4,
              child: CupertinoListSection(
                topMargin: 0,
                children: [
                  CupertinoListTile(
                    onTap: () {
                      _controller.hideMenu();
                      show(context, const ConnectToServer(), true);
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
                      title: const Text('Connect to Server')),
                  const SizedBox(
                    height: 5,
                  ),
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
                          : const Text(''),
                      onTap: () {
                        _toggleBoolValue();
                        _controller.hideMenu();
                      },
                      title: const Text('Show All Extensions')),
                ],
              ),
            ),
          )),
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

                  return CupertinoListSection(
                    backgroundColor: CupertinoColors.white,
                    // header: const Text(''),
                    footer: Center(child: Text('${entities.length} items')),
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
                          child: Builder(
                            builder: (BuildContext ctx) {
                              return CupertinoContextMenu.builder(
                                  enableHapticFeedback: true,
                                  actions: <Widget>[
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      isDefaultAction: true,
                                      trailingIcon:
                                          CupertinoIcons.doc_on_clipboard_fill,
                                      child: const Text('Copy'),
                                    ),
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      trailingIcon: CupertinoIcons.share,
                                      child: const Text('Share'),
                                    ),
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      trailingIcon: CupertinoIcons.heart,
                                      child: const Text('Favorite'),
                                    ),
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      isDestructiveAction: true,
                                      trailingIcon: CupertinoIcons.delete,
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                  builder: (BuildContext context,
                                      Animation<double> animation) {
                                    final Animation<Decoration>
                                        boxDecorationAnimation =
                                        _boxDecorationAnimation(animation);
                                    return Wrap(
                                      children: [
                                        Container(
                                          decoration: animation.value <
                                                  CupertinoContextMenu
                                                      .animationOpensAt
                                              ? boxDecorationAnimation.value
                                              : null,
                                          child: CupertinoListTile(
                                            padding: const EdgeInsets.all(8),
                                            backgroundColor:
                                                CupertinoColors.white,
                                            subtitle: FutureBuilder(
                                                future: dateFetcher(entity),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(snapshot.data
                                                        .toString());
                                                  } else {
                                                    return Center(
                                                      child: Text(
                                                        '${snapshot.error} occurred',
                                                      ),
                                                    );
                                                  }
                                                }),
                                            leading: FileManager.isFile(
                                                    entities[index])
                                                ? const Icon(
                                                    CupertinoIcons.doc_fill,
                                                    size: 30,
                                                  )
                                                : const Icon(
                                                    CupertinoIcons.folder_fill,
                                                    size: 30,
                                                  ),
                                            trailing: FileManager.isDirectory(
                                                    entities[index])
                                                ? const Icon(CupertinoIcons
                                                    .chevron_forward)
                                                : Text(getFileSize(
                                                    entities[index].path)),
                                            onTap: () {
                                              if (FileManager.isDirectory(
                                                  entities[index])) {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          FolderScreen(
                                                            entity:
                                                                entities[index]
                                                                    .path,
                                                          )),
                                                );

                                                if (kDebugMode) {
                                                  print(
                                                      'current path document: ${controller.getCurrentPath}');
                                                }
                                              } else {
                                                // Perform file-related tasks.
                                                try {
                                                  String filePath =
                                                      '${controller.getCurrentPath}/${FileManager.basename(entities[index])}';
                                                  OpenFile.open(filePath);
                                                } on Exception catch (e) {
                                                  if (kDebugMode) {
                                                    print(
                                                        'file open error : $e');
                                                  }
                                                }
                                              }
                                            },
                                            title: Text(
                                              FileManager.isDirectory(entity)
                                                  ? FileManager.basename(entity)
                                                  : _boolValue
                                                      ? entity.path
                                                          .split('/')
                                                          .last
                                                          .split('.')
                                                          .first
                                                      : FileManager.basename(
                                                          entity),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
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
