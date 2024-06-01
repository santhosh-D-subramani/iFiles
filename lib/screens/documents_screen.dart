import 'dart:io';

import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:xfiles/support/show_all_extension_prefs.dart';

import '/support/provider_model.dart';
import '/widgets/error_screen.dart';
import '/widgets/loading_screen.dart';
import '../common/common.dart';
import '../support/share_prefs.dart';
import '../widgets/empty_folder_screen.dart';
import 'folder.dart';
import 'support_screens/connect_ftp_page.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key, required this.title});

  final String title;

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final FileManagerController controller = FileManagerController();
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  final CustomPopupMenuController _controller1 = CustomPopupMenuController();
  final BoolStorage _boolStorage = BoolStorage();

  //bool _boolValue = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _loadBoolValue();
  }

  // Future<void> _loadBoolValue() async {
  //   bool value = await _boolStorage.getBool();
  //   if (value != _boolValue) {
  //     setState(() {
  //       _boolValue = value;
  //     });
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       var i = Provider.of<MyStringModel>(context, listen: false);
  //       print(
  //           'updated provider ${i.showAllExtension}from _loadBoolValue() :$_boolValue');
  //       i.setShowAllExtension(_boolValue);
  //     });
  //   }
  // }

  //
  // Future<void> _toggleBoolValue() async {
  //   bool newValue = !_boolValue;
  //   await _boolStorage.setBool(newValue);
  //   setState(() {
  //     _boolValue = newValue;
  //   });
  // }

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

  void setStateCaller() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var i = Provider.of<MyStringModel>(context, listen: true);
    //  print(
    //  'before provider ${i.showAllExtension} ShowExtensionWidget :$_boolValue');
    //i.setShowAllExtension(_boolValue);
    // print(
    //   ' provider ${i.showAllExtension} ShowExtensionWidget :${i.showAllExtension}');
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      navigationBar: fileManagerNavbar(
        context,
        _controller1,
        controller,
        _controller,
        setStateCaller,
        widget.title,
        ShowExtensionWidget(
          customPopupMenuController: _controller,
        ),
      ),
      // navigationBar: CupertinoNavigationBar(
      //
      //     ///title pop up menu
      //     middle: CustomPopupMenu(
      //       controller: _controller1,
      //       enablePassEvent: false,
      //       pressType: PressType.longPress,
      //       child: ValueListenableBuilder(
      //           valueListenable: controller.titleNotifier,
      //           builder: (context, title, _) {
      //             return Text(
      //               title == '0' ? widget.title : title,
      //               style: const TextStyle(fontWeight: FontWeight.bold),
      //             );
      //           }),
      //       menuBuilder: () => ClipRRect(
      //         borderRadius: BorderRadius.circular(15),
      //         child: SizedBox(
      //           width: MediaQuery.of(context).size.width / 2,
      //           child: CupertinoListSection(
      //             topMargin: 0,
      //             children: [
      //               CupertinoListTile(
      //                 onTap: () {
      //                   _controller1.hideMenu();
      //                   createFolder(context, controller);
      //                 },
      //                 title: const Text('New Folder'),
      //                 trailing:
      //                     const Icon(CupertinoIcons.folder_fill_badge_plus),
      //               ),
      //               if (i.isFile.isNotEmpty)
      //                 CupertinoListTile(
      //                   onTap: () {
      //                     _controller1.hideMenu();
      //                     if (i.isFile == 'true') {
      //                       i.taskName == 'Move'
      //                           ? moveFile(
      //                               i.myString, controller.getCurrentPath)
      //                           : copyFiles(
      //                               i.myString, controller.getCurrentPath);
      //                       setState(() {});
      //                     } else if (i.isFile == 'false') {
      //                       i.taskName == 'Move'
      //                           ? movePath(
      //                               i.myString, controller.getCurrentPath)
      //                           : copyPath(
      //                               i.myString, controller.getCurrentPath);
      //                       setState(() {});
      //                     }
      //                     if (kDebugMode) {
      //                       print('path: ${i.myString}');
      //                       print('task; ${i.taskName}');
      //                       print(controller.getCurrentPath);
      //                       print('isFile: ${i.isFile}');
      //                     }
      //                   },
      //                   title: const Text('Paste'),
      //                   trailing: const Icon(CupertinoIcons.doc_on_clipboard),
      //                 ),
      //               CupertinoListTile(
      //                 onTap: () {
      //                   _controller1.hideMenu();
      //                 },
      //                 title: const Text('Get Info'),
      //                 trailing: const Icon(CupertinoIcons.info_circle),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //
      //     ///top right pop up menu
      //     trailing: CustomPopupMenu(
      //       controller: _controller,
      //       enablePassEvent: false,
      //       pressType: PressType.singleClick,
      //       child:
      //           const Icon(CupertinoIcons.ellipsis_circle, color: Colors.blue),
      //       menuBuilder: () => ClipRRect(
      //         borderRadius: BorderRadius.circular(15),
      //         child: SizedBox(
      //           width: MediaQuery.of(context).size.width / 1.4,
      //           child: CupertinoListSection(
      //             topMargin: 0,
      //             children: [
      //               CupertinoListTile(
      //                 onTap: () {
      //                   createFolder(context, controller);
      //                   _controller.hideMenu();
      //                 },
      //                 title: const Text('New Folder'),
      //                 trailing: const Icon(
      //                     CupertinoIcons.slider_horizontal_below_rectangle),
      //               ),
      //               if (i.isFile.isNotEmpty)
      //                 CupertinoListTile(
      //                   onTap: () {
      //                     _controller.hideMenu();
      //
      //                     if (i.isFile == 'true') {
      //                       i.taskName == 'Move'
      //                           ? moveFile(
      //                               i.myString, controller.getCurrentPath)
      //                           : copyFiles(
      //                               i.myString, controller.getCurrentPath);
      //                       setState(() {});
      //                     } else if (i.isFile == 'false') {
      //                       i.taskName == 'Move'
      //                           ? movePath(
      //                               i.myString, controller.getCurrentPath)
      //                           : copyPath(
      //                               i.myString, controller.getCurrentPath);
      //                       setState(() {});
      //                     }
      //                     if (kDebugMode) {
      //                       print('path: ${i.myString}');
      //                       print('task; ${i.taskName}');
      //                       print(controller.getCurrentPath);
      //                       print('isFile: ${i.isFile}');
      //                     }
      //                   },
      //                   title: const Text('Paste'),
      //                   trailing:
      //                       const Icon(CupertinoIcons.doc_on_clipboard_fill),
      //                 ),
      //               CupertinoListTile(
      //                   onTap: () {
      //                     _controller.hideMenu();
      //                   },
      //                   title: const Text('Icons')),
      //               CupertinoListTile(
      //                   onTap: () {
      //                     _controller.hideMenu();
      //                   },
      //                   title: const Text('List')),
      //               CupertinoListTile(
      //                   onTap: () {
      //                     _controller.hideMenu();
      //                   },
      //                   title: const Text('Name')),
      //               CupertinoListTile(
      //                   onTap: () {
      //                     _controller.hideMenu();
      //                   },
      //                   title: const Text('Kind')),
      //               CupertinoListTile(
      //                   onTap: () {
      //                     _controller.hideMenu();
      //                   },
      //                   title: const Text('Date')),
      //               CupertinoListTile(
      //                   onTap: () {
      //                     _controller.hideMenu();
      //                   },
      //                   title: const Text('Size')),
      //               CupertinoListTile(
      //                   onTap: () {
      //                     show(context, const ConnectToServer(), true);
      //                     _controller.hideMenu();
      //                   },
      //                   title: const Text('Tags')),
      //               CupertinoListTile(
      //                   leading: !_boolValue
      //                       ? const Icon(CupertinoIcons.check_mark)
      //                       : const Text(''),
      //                   onTap: () {
      //                     _toggleBoolValue();
      //                     _controller.hideMenu();
      //                   },
      //                   title: const Text('Show All Extensions')),
      //             ],
      //           ),
      //         ),
      //       ),
      //     )),
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

                        ///Slidable widget
                        return Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            dismissible: DismissiblePane(
                              onDismissed: () async {
                                FileManager.isDirectory(entity)
                                    ? movePath(
                                            '${controller.getCurrentPath}/${FileManager.basename(entity)}',
                                            '${i.internalStorageRootDirectory}/.trash/')
                                        .whenComplete(() => setState(() {}))
                                    : moveFile(
                                            '${controller.getCurrentPath}/${FileManager.basename(entity)}',
                                            '${i.internalStorageRootDirectory}/.trash/')
                                        .whenComplete(() => setState(() {}));
                              },
                            ),
                            children: [
                              SlidableAction(
                                onPressed: (value) async {
                                  FileManager.isDirectory(entity)
                                      ? movePath(
                                              '${controller.getCurrentPath}/${FileManager.basename(entity)}',
                                              '${i.internalStorageRootDirectory}/.trash/')
                                          .whenComplete(() => setState(() {}))
                                      : moveFile(
                                              '${controller.getCurrentPath}/${FileManager.basename(entity)}',
                                              '${i.internalStorageRootDirectory}/.trash/')
                                          .whenComplete(() => setState(() {}));
                                },
                                label: 'Delete',
                                backgroundColor: CupertinoColors.destructiveRed,
                              ),
                            ],
                          ),
                          child: Builder(
                            builder: (BuildContext ctx) {
                              ///List Item OnClick Pop up Menu
                              return CupertinoContextMenu.builder(
                                  enableHapticFeedback: true,
                                  actions: <Widget>[
                                    ///Get Info
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      trailingIcon: CupertinoIcons.info_circle,
                                      child: const Text('Get Info'),
                                    ),

                                    /// Rename
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                      trailingIcon: CupertinoIcons.pencil,
                                      child: const Text('Rename'),
                                    ),

                                    ///compress || uncompress
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        FileManager.isFile(entity)
                                            ? zipTheFile(
                                                controller.getCurrentDirectory,
                                                entity.path)
                                            : zipTheDirectory(
                                                Directory(i
                                                    .internalStorageRootDirectory),
                                                FileManager.basename(entity));
                                        setState(() {});
                                      },
                                      trailingIcon: CupertinoIcons.archivebox,
                                      child: entity.path
                                                  .split('/')
                                                  .last
                                                  .split('.')
                                                  .last ==
                                              'zip'
                                          ? const Text('Uncompress')
                                          : const Text('Compress'),
                                    ),

                                    // CupertinoContextMenuAction(
                                    //   onPressed: () {
                                    //     Navigator.pop(ctx);
                                    //   },
                                    //   trailingIcon:
                                    //       CupertinoIcons.plus_square_on_square,
                                    //   child: const Text('Duplicate'),
                                    // ),
                                    // CupertinoContextMenuAction(
                                    //   onPressed: () {
                                    //     Navigator.pop(ctx);
                                    //   },
                                    //   trailingIcon:
                                    //       CupertinoIcons.folder_fill_badge_plus,
                                    //   child: const Text('New Folder with Item'),
                                    // ),
                                    // CupertinoContextMenuAction(
                                    //   onPressed: () {
                                    //     Navigator.pop(context);
                                    //   },
                                    //   trailingIcon: CupertinoIcons.heart,
                                    //   child: const Text('Favorite'),
                                    // ),
                                    ///Copy
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                        context.read<MyStringModel>().updateString(
                                            entities[index].path,
                                            '${!FileManager.isDirectory(entities[index])}',
                                            'Copy');
                                        if (kDebugMode) {
                                          print(
                                              'copy initial data : ${entities[index].path} - ${!FileManager.isDirectory(entities[index])}');
                                        }
                                      },
                                      isDefaultAction: true,
                                      trailingIcon:
                                          CupertinoIcons.doc_on_clipboard_fill,
                                      child: const Text('Copy'),
                                    ),

                                    ///Move
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        context.read<MyStringModel>().updateString(
                                            entities[index].path,
                                            '${!FileManager.isDirectory(entities[index])}',
                                            'Move');
                                        if (kDebugMode) {
                                          print(
                                              'move initial data : ${entities[index].path} - ${!FileManager.isDirectory(entities[index])}');
                                        }
                                      },
                                      trailingIcon: CupertinoIcons.folder,
                                      child: const Text('Move'),
                                    ),

                                    ///Share
                                    CupertinoContextMenuAction(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        show(context, const ConnectToServer(),
                                            true);
                                      },
                                      trailingIcon: CupertinoIcons.share,
                                      child: const Text('Share'),
                                    ),

                                    ///Delete
                                    CupertinoContextMenuAction(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        FileManager.isDirectory(entity)
                                            ? movePath(
                                                    '${controller.getCurrentPath}/${FileManager.basename(entity)}',
                                                    '${i.internalStorageRootDirectory}/.trash/')
                                                .whenComplete(
                                                    () => setState(() {}))
                                            : moveFile(
                                                    '${controller.getCurrentPath}/${FileManager.basename(entity)}',
                                                    '${i.internalStorageRootDirectory}/.trash/')
                                                .whenComplete(
                                                    () => setState(() {}));
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
                                                      'current path from root: ${controller.getCurrentPath}');
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
                                                  : Provider.of<ShowAllExtensionPrefs>(
                                                              context)
                                                          .value
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
