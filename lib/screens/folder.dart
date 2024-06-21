import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:xfiles/widgets/main_body_file_manager.dart';

import '../common/common.dart';
import '../support/provider_model.dart';
import '../support/share_prefs.dart';
import '../widgets/file_manager_navbar.dart';

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
  final CustomPopupMenuController _controller1 = CustomPopupMenuController();

  bool _boolValue = false;

  // Future<void> _loadBoolValue() async {
  //   bool value = await _boolStorage.getBool();
  //   setState(() {
  //     _boolValue = value;
  //   });
  // }
  //
  // Future<void> _checkBoolState() async {
  //   bool value = await _boolStorage.getBool();
  //   if (_boolValue != value) {
  //     setState(() {});
  //   }
  // }

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

  @override
  void initState() {
    super.initState();
    //_loadBoolValue();
    controller.setCurrentPath = widget.entity;
    if (kDebugMode) {
      print('current path init state call: ${controller.getCurrentPath}');
    }
  }

  void setStateCaller() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var i = Provider.of<MyStringModel>(context, listen: false);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: fileManagerNavbar(
        context,
        _controller1,
        controller,
        setStateCaller,
        null,
      ),
      child: MainBodyFileManager(
        controller: controller,
        setStateCaller: setStateCaller,
        builderStarting: () {
          controller.setCurrentPath = widget.entity;
        },
      ),
      // child: SafeArea(
      //   child: CustomScrollView(
      //     slivers: [
      //       SliverFillRemaining(
      //         fillOverscroll: true,
      //         hasScrollBody: false,
      //         child: FileManager(
      //           emptyFolder: emptyFolderScreen(),
      //           loadingScreen: loadingScreen(),
      //           errorBuilder: (context, error) => errorScreen(error),
      //           hideHiddenEntity: false,
      //           controller: controller,
      //           builder: (context, snapshot) {
      //             ///builderStarting
      //             List<FileSystemEntity> entities = snapshot;
      //
      //             controller.setCurrentPath = widget.entity;
      //
      //             if (kDebugMode) {
      //               print(
      //                   'current path inside loop: ${controller.getCurrentPath}');
      //             }
      //             return CupertinoListSection(
      //               backgroundColor: CupertinoColors.white,
      //               footer: Center(child: Text('${entities.length} items')),
      //               // header: const Text(''),
      //               children: [
      //                 ...List.generate(entities.length, (index) {
      //                   FileSystemEntity entity = entities[index];
      //
      //                   return Slidable(
      //                     key: UniqueKey(),
      //                     endActionPane: ActionPane(
      //                       motion: const StretchMotion(),
      //                       dismissible: DismissiblePane(
      //                         onDismissed: () async {
      //                           FileManager.isDirectory(entity)
      //                               ? movePath(
      //                                       '${controller.getCurrentPath}/${FileManager.basename(entity)}',
      //                                       '${i.internalStorageRootDirectory}/.trash/')
      //                                   .whenComplete(() => setState(() {}))
      //                               : moveFile(
      //                                       '${controller.getCurrentPath}/${FileManager.basename(entity)}',
      //                                       '${i.internalStorageRootDirectory}/.trash/')
      //                                   .whenComplete(() => setState(() {}));
      //                         },
      //                       ),
      //                       children: [
      //                         SlidableAction(
      //                           onPressed: (value) async {
      //                             if (controller.getCurrentPath ==
      //                                     '${i.internalStorageRootDirectory}/.trash/' ||
      //                                 controller.getCurrentPath ==
      //                                     '${i.sdCardRootDirectory}/.trash/') {
      //                               FileManager.isDirectory(entity)
      //                                   ? await entity
      //                                       .delete(recursive: true)
      //                                       .whenComplete(() => setState(() {}))
      //                                   : await entity.delete().whenComplete(
      //                                       () => setState(() {}));
      //                             } else {
      //                               FileManager.isDirectory(entity)
      //                                   ? movePath(
      //                                           '${controller.getCurrentPath}/${FileManager.basename(entity)}',
      //                                           '${i.internalStorageRootDirectory}/.trash/')
      //                                       .whenComplete(() => setState(() {}))
      //                                   : moveFile(
      //                                           '${controller.getCurrentPath}/${FileManager.basename(entity)}',
      //                                           '${i.internalStorageRootDirectory}/.trash/')
      //                                       .whenComplete(
      //                                           () => setState(() {}));
      //                             }
      //                           },
      //                           label: 'Delete',
      //                           backgroundColor: CupertinoColors.destructiveRed,
      //                         ),
      //                       ],
      //                     ),
      //                     child: Builder(
      //                       builder: (BuildContext ctx) {
      //                         return CupertinoContextMenu.builder(
      //                           enableHapticFeedback: true,
      //                           actions: <Widget>[
      //                             CupertinoContextMenuAction(
      //                               onPressed: () {
      //                                 Navigator.pop(ctx);
      //                               },
      //                               trailingIcon: CupertinoIcons.info_circle,
      //                               child: const Text('Get Info'),
      //                             ),
      //                             CupertinoContextMenuAction(
      //                               onPressed: () {
      //                                 Navigator.pop(ctx);
      //                               },
      //                               trailingIcon: CupertinoIcons.pencil,
      //                               child: const Text('Rename'),
      //                             ),
      //                             CupertinoContextMenuAction(
      //                               onPressed: () {
      //                                 Navigator.pop(ctx);
      //                                 FileManager.isFile(entity)
      //                                     ? zipTheFile(
      //                                         controller.getCurrentDirectory,
      //                                         entity.path)
      //                                     : zipTheDirectory(
      //                                         Directory(i
      //                                             .internalStorageRootDirectory),
      //                                         FileManager.basename(entity));
      //                                 setState(() {});
      //                               },
      //                               trailingIcon: CupertinoIcons.archivebox,
      //                               child: entity.path
      //                                           .split('/')
      //                                           .last
      //                                           .split('.')
      //                                           .last ==
      //                                       'zip'
      //                                   ? const Text('Uncompress')
      //                                   : const Text('Compress'),
      //                             ),
      //                             CupertinoContextMenuAction(
      //                               onPressed: () {
      //                                 Navigator.of(ctx).pop();
      //                                 context.read<MyStringModel>().updateString(
      //                                     entities[index].path,
      //                                     '${!FileManager.isDirectory(entities[index])}',
      //                                     'Copy');
      //                                 if (kDebugMode) {
      //                                   print(
      //                                       '${entities[index].path} - ${!FileManager.isDirectory(entities[index])}');
      //                                 }
      //                               },
      //                               isDefaultAction: true,
      //                               trailingIcon:
      //                                   CupertinoIcons.doc_on_clipboard_fill,
      //                               child: const Text('Copy'),
      //                             ),
      //                             CupertinoContextMenuAction(
      //                               onPressed: () {
      //                                 Navigator.pop(ctx);
      //                                 context.read<MyStringModel>().updateString(
      //                                     entities[index].path,
      //                                     '${!FileManager.isDirectory(entities[index])}',
      //                                     'Move');
      //                                 if (kDebugMode) {
      //                                   print(
      //                                       'move initial data : ${entities[index].path} - ${!FileManager.isDirectory(entities[index])}');
      //                                 }
      //                               },
      //                               trailingIcon: CupertinoIcons.folder,
      //                               child: const Text('Move'),
      //                             ),
      //                             CupertinoContextMenuAction(
      //                               onPressed: () {
      //                                 Navigator.pop(ctx);
      //                               },
      //                               trailingIcon: CupertinoIcons.share,
      //                               child: const Text('Share'),
      //                             ),
      //                             CupertinoContextMenuAction(
      //                               onPressed: () {
      //                                 Navigator.pop(context);
      //                               },
      //                               trailingIcon: CupertinoIcons.heart,
      //                               child: const Text('Favorite'),
      //                             ),
      //                             CupertinoContextMenuAction(
      //                               onPressed: () async {
      //                                 Navigator.pop(context);
      //
      //                                 if (controller.getCurrentPath ==
      //                                         '${i.internalStorageRootDirectory}/.trash/' ||
      //                                     controller.getCurrentPath ==
      //                                         '${i.sdCardRootDirectory}/.trash/') {
      //                                   FileManager.isDirectory(entity)
      //                                       ? await entity
      //                                           .delete(recursive: true)
      //                                           .whenComplete(
      //                                               () => setState(() {}))
      //                                       : await entity
      //                                           .delete()
      //                                           .whenComplete(
      //                                               () => setState(() {}));
      //                                 } else {
      //                                   FileManager.isDirectory(entity)
      //                                       ? movePath(
      //                                               '${controller.getCurrentPath}/${FileManager.basename(entity)}',
      //                                               '${i.internalStorageRootDirectory}/.trash/')
      //                                           .whenComplete(
      //                                               () => setState(() {}))
      //                                       : moveFile(
      //                                               '${controller.getCurrentPath}/${FileManager.basename(entity)}',
      //                                               '${i.internalStorageRootDirectory}/.trash/')
      //                                           .whenComplete(
      //                                               () => setState(() {}));
      //                                 }
      //                               },
      //                               isDestructiveAction: true,
      //                               trailingIcon: CupertinoIcons.delete,
      //                               child: const Text('Delete'),
      //                             ),
      //                           ],
      //                           builder: (BuildContext context,
      //                               Animation<double> animation) {
      //                             final Animation<Decoration>
      //                                 boxDecorationAnimation =
      //                                 _boxDecorationAnimation(animation);
      //                             return Wrap(
      //                               children: [
      //                                 Container(
      //                                   decoration: animation.value <
      //                                           CupertinoContextMenu
      //                                               .animationOpensAt
      //                                       ? boxDecorationAnimation.value
      //                                       : null,
      //                                   child: CupertinoListTile(
      //                                     // padding: const EdgeInsets.all(8),
      //                                     backgroundColor:
      //                                         CupertinoColors.white,
      //                                     leading: FileManager.isFile(
      //                                             entities[index])
      //                                         ? const Icon(
      //                                             CupertinoIcons.doc_fill,
      //                                             size: 30,
      //                                           )
      //                                         : const Icon(
      //                                             CupertinoIcons.folder_fill,
      //                                             size: 30,
      //                                           ),
      //                                     trailing: FileManager.isDirectory(
      //                                             entities[index])
      //                                         ? const Icon(CupertinoIcons
      //                                             .chevron_forward)
      //                                         : Text(getFileSize(
      //                                             entities[index].path)),
      //                                     subtitle: FutureBuilder(
      //                                         future: dateFetcher(entity),
      //                                         builder: (context, snapshot) {
      //                                           if (snapshot.hasData) {
      //                                             return Text(
      //                                                 snapshot.data.toString());
      //                                           } else {
      //                                             return Center(
      //                                               child: Text(
      //                                                 '${snapshot.error} occurred',
      //                                               ),
      //                                             );
      //                                           }
      //                                         }),
      //                                     onTap: () {
      //                                       if (FileManager.isDirectory(
      //                                           entities[index])) {
      //                                         Navigator.push(
      //                                           context,
      //                                           CupertinoPageRoute(
      //                                               builder: (context) =>
      //                                                   FolderScreen(
      //                                                     entity:
      //                                                         entities[index]
      //                                                             .path,
      //                                                   )),
      //                                         );
      //                                         if (kDebugMode) {
      //                                           print(
      //                                               'current path Folder: ${controller.getCurrentPath}');
      //                                         }
      //                                         // open directory
      //                                       } else {
      //                                         // Perform file-related tasks.
      //                                         try {
      //                                           String filePath =
      //                                               '${controller.getCurrentPath}/${FileManager.basename(entities[index])}';
      //                                           OpenFile.open(filePath);
      //                                         } on Exception catch (e) {
      //                                           if (kDebugMode) {
      //                                             print('file open error : $e');
      //                                           }
      //                                         }
      //                                       }
      //                                     },
      //                                     title: Text(FileManager.isDirectory(
      //                                             entity)
      //                                         ? FileManager.basename(entity)
      //                                         : Provider.of<ShowAllExtensionPrefs>(
      //                                                     context)
      //                                                 .value
      //                                             ? entity.path
      //                                                 .split('/')
      //                                                 .last
      //                                                 .split('.')
      //                                                 .first
      //                                             : FileManager.basename(
      //                                                 entity)),
      //                                   ),
      //                                 ),
      //                               ],
      //                             );
      //                           },
      //                         );
      //                       },
      //                     ),
      //                   );
      //                 }),
      //               ],
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
