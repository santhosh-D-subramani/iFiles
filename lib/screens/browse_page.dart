import 'dart:io';

import 'package:disk_space/disk_space.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:samba_browser/samba_browser.dart';
import 'package:xfiles/common/common.dart';
import 'package:xfiles/screens/support_screens/connect_ftp_page.dart';
import 'package:xfiles/screens/support_screens/modal_fit.dart';
import 'package:xfiles/screens/support_screens/settings_page.dart';

import '../support/share_prefs.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/expandable_widget.dart';
import 'documents_screen.dart';
import 'folder.dart';
import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';

import 'support_screens/about_page.dart';

class Browse extends StatefulWidget {
  const Browse({super.key});

  @override
  State<Browse> createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  List<Directory> storages = [];
  final FileManagerController controller = FileManagerController();
  final CustomPopupMenuController _controller = CustomPopupMenuController();
  Future<List>? shareFuture;

  Map<Directory, double> _directorySpace = {};
  Map<Directory, double> _directorySpace2 = {};
  BoolStorage boolBunk = BoolStorage();
  String s = '', n = '', p = '';

  void getAllStorages() async {
    List<Directory> storagesTemp = (await getExternalStorageDirectories())!;
    storagesTemp = storagesTemp.map((Directory e) {
      final List<String> splitedPath = e.path.split("/");
      return Directory(splitedPath
          .sublist(0, splitedPath.indexWhere((element) => element == "Android"))
          .join("/"));
    }).toList();
    storages = storagesTemp;
    createTrashDirectory();
    setState(() {});
    if (kDebugMode) {
      print('getAllStorage 1: ${storagesTemp[0]}');
      print('getAllStorage 2:${storagesTemp[1]}');
      print('storage length : ${storagesTemp.length}');
    }
  }

  Future<void> initDiskSpace() async {
    List<Directory> directories;
    Map<Directory, double> directorySpace = {};
    Map<Directory, double> directorySpace2 = {};
    directories = await getExternalStorageDirectories().then(
      (list) async => list ?? [await getApplicationDocumentsDirectory()],
    );

    for (var directory in directories) {
      var space = await DiskSpace.getFreeDiskSpaceForPath(directory.path);
      directorySpace.addEntries([MapEntry(directory, space!)]);
    }
    for (var directory in directories) {
      var space = await DiskSpace.getTotalDiskSpaceForPath(directory.path);
      directorySpace2.addEntries([MapEntry(directory, space!)]);
    }
    if (!mounted) return;

    setState(() {
      _directorySpace = directorySpace;
      _directorySpace2 = directorySpace2;
    });
  }

  String getFileSize(String path) {
    File file = File(path);
    int fileSizeInBytes = file.lengthSync();
    double fileSizeInKB = fileSizeInBytes / 1024; // Convert bytes to kilobytes
    double fileSizeInMB = fileSizeInKB / 1024;
    double fileSizeInGB = fileSizeInMB / 1024;
    return fileSizeInKB < 1
        ? '$fileSizeInBytes B'
        : fileSizeInMB < 1
            ? '$fileSizeInKB Kb'
            : fileSizeInGB < 1
                ? '$fileSizeInMB Mb'
                : fileSizeInGB > 1
                    ? '$fileSizeInGB Gb'
                    : '';
  }

  Future<void> _loadStringValue() async {
    String s1 = await boolBunk.getServerUrl();
    String n1 = await boolBunk.getUsername();
    String p1 = await boolBunk.getPassword();
    setState(() {
      s = s1;
      n = n1;
      p = p1;
    });
    getSmbFiles();
    print('$s ,$n ,$p');
  }

  void getSmbFiles() async {
    setState(() {
      s.isNotEmpty && n.isNotEmpty && p.isNotEmpty
          ? shareFuture = SambaBrowser.getShareList(s, '', n, p)
          : null;
    });
    shareFuture != null
        ? print('shareFuture alive')
        : print('shareFuture dead null');
  }

  // smb://172.20.10.2/
  @override
  void initState() {
    super.initState();
    _loadStringValue();

    initDiskSpace();
    getAllStorages();
  }

  void createTrashDirectory() async {
    var folderName = '.trash';
    try {
      // Create Folder
      if (storages.isNotEmpty) {
        controller.setCurrentPath = storages[0].path;
        await FileManager.createFolder(controller.getCurrentPath, folderName);
        print('trash folder created ${controller.getCurrentPath}/.trash');
        // Open Created Folder
        // controller.setCurrentPath = controller.getCurrentPath + "/" + folderName;
      }
    } catch (e) {
      print('trash folder cant create /.trash $e');
    }
  }

  Future<void> moveToTrash(String path, String fileName) async {
    final trashDir = Directory('${storages[0].path}/.trash');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPath = '$trashDir/${timestamp}_$fileName';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CupertinoColors.secondarySystemBackground,
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              middle: const Text(browsePageTitle),
              largeTitle: const Text(browsePageTitle),
              alwaysShowMiddle: false,
              stretch: true,
              trailing: CustomPopupMenu(
                controller: _controller,
                menuBuilder: () => ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: CupertinoListSection(
                      topMargin: 0,
                      children: [
                        CupertinoListTile(
                          onTap: () {
                            show(context, aboutPage(context), true);
                            _controller.hideMenu();
                          },
                          title: const Text('Scan Documents'),
                          trailing:
                              const Icon(CupertinoIcons.doc_text_viewfinder),
                        ),
                        CupertinoListTile(
                          onTap: () {
                            _controller.hideMenu();
                            show(context, const ConnectToServer(), true);
                          },
                          title: const Text('Connect to Server'),
                          trailing: const Icon(
                              CupertinoIcons.slider_horizontal_below_rectangle),
                        ),
                        CupertinoListTile(
                            onTap: () {
                              _controller.hideMenu();
                            },
                            title: const Text('Edit')),
                      ],
                    ),
                  ),
                ),
                pressType: PressType.singleClick,
                child: const Icon(CupertinoIcons.ellipsis_circle,
                    color: Colors.blue),
              ),
            ),
            const SliverAppBar(
              pinned: true,
              // systemOverlayStyle: SystemUiOverlayStyle(
              //     systemNavigationBarColor:
              //         CupertinoColors.secondarySystemBackground),
              backgroundColor: CupertinoColors.secondarySystemBackground,
              title: CupertinoSearchTextField(
                placeholder: 'search',
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    ExpandableWidget(
                      header: 'Locations',
                      content: CupertinoListSection.insetGrouped(
                        children: [
                          ...List.generate(storages.length, (index) {
                            if (kDebugMode) {
                              print(
                                  'onTap: ${storages[index].path.toString()}');
                            }
                            String locValue = storages[index].toString();
                            if (kDebugMode) {
                              print('locValue: $locValue');
                            }

                            var key = _directorySpace.keys.elementAt(index);
                            var value = _directorySpace[key]! / (1024);
                            var key2 = _directorySpace2.keys.elementAt(index);
                            var value2 = _directorySpace2[key2]! / (1024);
                            double usagePercent =
                                (value2 - value) / value2 * 100;
                            double usagePercent2 =
                                (value2 - value) / value2 * 100;

                            return listTile(
                                locValue.contains('emulated')
                                    ? 'On My iPhone'
                                    : index == 1
                                        ? 'SD Card'
                                        : storages[index]
                                            .toString()
                                            .split("storage/")[1]
                                            .split("/")[0]
                                            .trim(),
                                locValue.contains('emulated')
                                    ? CupertinoIcons.device_phone_portrait
                                    : CupertinoIcons.tray,
                                Row(
                                  children: [
                                    Text(locValue.contains('emulated')
                                        ? usagePercent > 1
                                            ? '${usagePercent.toStringAsFixed(1)} %'
                                            : ''
                                        : usagePercent2 > 1
                                            ? '${usagePercent2.toStringAsFixed(1)} %'
                                            : ''),
                                    const Icon(CupertinoIcons.chevron_forward),
                                  ],
                                ), () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        locValue.contains('emulated')
                                            ? const DocumentScreen(
                                                title: 'On My iPhone',
                                              )
                                            : FolderScreen(
                                                entity: storages[index].path,
                                              )),
                              );
                            });
                          }),
                          listTile('Recently Deleted', CupertinoIcons.trash,
                              const Icon(CupertinoIcons.chevron_forward), () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => FolderScreen(
                                          entity: '${storages[0].path}/.trash',
                                        )));
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ExpandableWidget(
                      header: 'Favourites',
                      content: CupertinoListSection.insetGrouped(
                        children: [
                          listTile('iPhone downloads', CupertinoIcons.folder,
                              const Icon(CupertinoIcons.chevron_forward), () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => FolderScreen(
                                          entity:
                                              '${storages[0].path}/Download',
                                        )));
                          }),
                          listTile('SD Card downloads', CupertinoIcons.folder,
                              const Icon(CupertinoIcons.chevron_forward), () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => FolderScreen(
                                          entity:
                                              '${storages[1].path}/Download',
                                        )));
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (shareFuture != null)
                      ExpandableWidget(
                        header: 'Shared',
                        content: FutureBuilder(
                            future: shareFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CupertinoActivityIndicator(); // Placeholder for loading state
                              }
                              if (snapshot.hasError) {
                                return Text(
                                    'Error: ${snapshot.error}'); // Placeholder for error state
                              }
                              String title = s;
                              if (kDebugMode) {
                                print(s);
                              }
                              return listTile(
                                  title,
                                  CupertinoIcons.globe,
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {},
                                          child: const Icon(
                                              CupertinoIcons.eject_fill)),
                                      const Icon(
                                          CupertinoIcons.chevron_forward),
                                    ],
                                  ), () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => FolderScreen(
                                              entity: s,
                                            )));
                              });
                            }),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
