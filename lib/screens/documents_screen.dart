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
import '../support/file_restore_provider.dart';
import '../support/share_prefs.dart';
import '../widgets/empty_folder_screen.dart';
import '../widgets/file_manager_navbar.dart';
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
  final CustomPopupMenuController _controller1 = CustomPopupMenuController();
  final BoolStorage _boolStorage = BoolStorage();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void setStateCaller() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var i = Provider.of<MyStringModel>(context, listen: true);
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: true,
      navigationBar: fileManagerNavbar(
        context,
        _controller1,
        controller,
        setStateCaller,
        widget.title,
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
                                        if (FileManager.isDirectory(entity)) {
                                          Provider.of<FileProvider>(context,
                                                  listen: false)
                                              .deleteFile(
                                            controller.getCurrentPath,
                                            FileManager.basename(entity),
                                          )
                                              .whenComplete(() {
                                            movePath(
                                                    '${controller.getCurrentPath}/${FileManager.basename(entity)}',
                                                    '${i.internalStorageRootDirectory}/.trash/')
                                                .whenComplete(
                                                    () => setState(() {}));
                                          });
                                        } else {
                                          Provider.of<FileProvider>(context,
                                                  listen: false)
                                              .deleteFile(
                                            controller.getCurrentPath,
                                            FileManager.basename(entity),
                                          )
                                              .whenComplete(() {
                                            moveFile(
                                                    '${controller.getCurrentPath}/${FileManager.basename(entity)}',
                                                    '${i.internalStorageRootDirectory}/.trash/')
                                                .whenComplete(
                                                    () => setState(() {}));
                                          });
                                        }
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
                                        boxDecorationAnimationX(animation);
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
