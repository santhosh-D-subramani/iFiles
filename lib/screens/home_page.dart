import 'dart:io';

import 'package:disk_space/disk_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex2/path_provider_ex2.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/expandable_widget.dart';
import 'documents_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<File>>? _files;
  List<Directory> storages = [];
  double _diskSpace = 0;
  double _totalDiskSpace = 0;
  Map<Directory, double> _directorySpace = {};
  Map<Directory, double> _directorySpace2 = {};

  //request permission-->
  Future<bool> requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.isGranted;
    if (!status) {
      var result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    }
    return true;
  }

  void getFileDetails(String path1) {
    File file = File(path1);

    // Get the file size
    int fileSizeInBytes = file.lengthSync();
    double fileSizeInKB = fileSizeInBytes / 1024; // Convert bytes to kilobytes
    double fileSizeInMB = fileSizeInKB / 1024; // Convert kilobytes to megabytes

    if (kDebugMode) {
      print('File Size:');
    }
    if (kDebugMode) {
      print('Bytes: $fileSizeInBytes');
    }
    if (kDebugMode) {
      print('KB: $fileSizeInKB');
    }
    if (kDebugMode) {
      print('MB: $fileSizeInMB');
    }

    // Get the file location (path)
    String filePath = file.path;

    if (kDebugMode) {
      print('File Location (Path): $filePath');
    }
  }

  Future<List<File>> getRecentFilesFromExternalStorage() async {
    if (!await requestStoragePermission()) {
      throw Exception("Storage permission not granted");
    }
    // Getting the external storage directory
    // final directory = Directory('/storage/emulated/0/Download');
    ///need to work on this doest pull recents from full storage only apps directory
    final directory =
        await getApplicationDocumentsDirectory(); //File Location (Path): /data/user/0/com.santhoshDsubramani.iFiles/app_flutter/ // This path is for Android, adjust for other platforms if needed
    final files =
        directory.listSync(recursive: true).whereType<File>().toList();

    // Sorting files by their last modified date
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

    return files;
  }

  // checks  storage permission
  void initFiles() async {
    if (await requestStoragePermission()) {
      _files = getRecentFilesFromExternalStorage();
      setState(() {});
    } else {
      if (kDebugMode) {
        print("Storage permission was denied.");
      }
    }
  }

  Future<void> initDiskSpace() async {
    double diskSpace, totalDiskSpace = 0;

    diskSpace = (await DiskSpace.getFreeDiskSpace)!;
    totalDiskSpace = (await DiskSpace.getTotalDiskSpace)!;
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
      _diskSpace = diskSpace / (1024);
      _totalDiskSpace = totalDiskSpace / (1024);
      _directorySpace = directorySpace;
      _directorySpace2 = directorySpace2;
    });
  }

  void getAllStorages() async {
    List<Directory> storagesTemp = (await getExternalStorageDirectories())!;
    storagesTemp = storagesTemp.map((Directory e) {
      final List<String> splitedPath = e.path.split("/");
      return Directory(splitedPath
          .sublist(0, splitedPath.indexWhere((element) => element == "Android"))
          .join("/"));
    }).toList();
    storages = storagesTemp;
    setState(() {});
    if (kDebugMode) {
      print(storagesTemp[0]);
      print('storage length : ${storagesTemp.length}');
    }
  }

  @override
  void initState() {
    super.initState();
    initFiles();
    initDiskSpace();
    getAllStorages();
  }

  @override
  Widget build(BuildContext context) {
    // double usagePercent =
    //    (_totalDiskSpace - _diskSpace) / _totalDiskSpace * 100;

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 60,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.clock_solid),
            label: 'Recents',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder_fill_badge_person_crop),
            label: 'Shared',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder_fill),
            label: 'Browse',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return index == 2 // home
                ? CupertinoPageScaffold(
                    backgroundColor: CupertinoColors.secondarySystemBackground,
                    child: CustomScrollView(
                      slivers: [
                        const CupertinoSliverNavigationBar(
                          middle: Text('Browse'),
                          largeTitle: Text('Browse'),
                          alwaysShowMiddle: false,
                          stretch: true,
                          trailing: Icon(CupertinoIcons.ellipsis_circle),
                        ),
                        const SliverAppBar(
                          pinned: true,
                          systemOverlayStyle: SystemUiOverlayStyle(
                              systemNavigationBarColor:
                                  CupertinoColors.secondarySystemBackground),
                          backgroundColor:
                              CupertinoColors.secondarySystemBackground,
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
                                      ...List.generate(storages.length,
                                          (index) {
                                        String locValue =
                                            storages[index].toString();
                                        var key = _directorySpace.keys
                                            .elementAt(index);
                                        var value =
                                            _directorySpace[key]! / (1024);
                                        var key2 = _directorySpace2.keys
                                            .elementAt(index);
                                        var value2 =
                                            _directorySpace2[key2]! / (1024);
                                        double usagePercent =
                                            (value2 - value) / value2 * 100;
                                        double usagePercent2 =
                                            (value2 - value) / value2 * 100;
                                        print(value2);
                                        return listTile(
                                            locValue.contains('emulated')
                                                ? 'On My iPhone'
                                                : locValue
                                                    .split("storage/")[1]
                                                    .split("/")[0]
                                                    .trim(),
                                            locValue.contains('emulated')
                                                ? CupertinoIcons
                                                    .device_phone_portrait
                                                : CupertinoIcons.tray,
                                            Row(
                                              children: [
                                                Text(locValue
                                                        .contains('emulated')
                                                    ? usagePercent > 1
                                                        ? '${usagePercent.toStringAsFixed(1)} %'
                                                        : ''
                                                    : usagePercent2 > 1
                                                        ? '${usagePercent2.toStringAsFixed(1)} %'
                                                        : ''),
                                                const Icon(CupertinoIcons
                                                    .chevron_forward),
                                              ],
                                            ), () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    const DocumentScreen(
                                                      title: 'On My iPhone',
                                                    )),
                                          );
                                        });
                                      }),
                                      listTile(
                                          'Recently Deleted',
                                          CupertinoIcons.trash,
                                          const Icon(
                                              CupertinoIcons.chevron_forward),
                                          () {}),
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
                                      listTile(
                                          'downloads',
                                          CupertinoIcons.folder,
                                          const Icon(
                                              CupertinoIcons.chevron_forward),
                                          () {}),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
                : index == 0 // Recents
                    ? CupertinoPageScaffold(
                        backgroundColor:
                            CupertinoColors.secondarySystemBackground,
                        child: CustomScrollView(
                          slivers: [
                            const CupertinoSliverNavigationBar(
                              middle: Text('Recents'),
                              largeTitle: Text('Recents'),
                              alwaysShowMiddle: false,
                              stretch: true,
                              backgroundColor:
                                  CupertinoColors.secondarySystemBackground,
                              trailing: Icon(CupertinoIcons.ellipsis_circle),
                            ),
                            // const SliverPadding(padding: EdgeInsets.symmetric(vertical: 20)),
                            const SliverAppBar(
                              automaticallyImplyLeading: false,
                              pinned: true,
                              systemOverlayStyle: SystemUiOverlayStyle(
                                  systemNavigationBarColor: CupertinoColors
                                      .secondarySystemBackground),
                              backgroundColor:
                                  CupertinoColors.secondarySystemBackground,
                              title: CupertinoSearchTextField(
                                placeholder: 'search',
                              ),
                            ),
                            SliverGrid(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Container(
                                      alignment: Alignment.center,
                                      color: Colors.teal[100 * (index % 9)],
                                      child: Text('grid item $index'),
                                    );
                                  },
                                  childCount: 40,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200.0,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio: 4.0,
                                ))
                          ],
                        ))
                    : index == 1 //shared
                        ? Scaffold(
                            body: SafeArea(
                              child: FutureBuilder<List<File>>(
                                future: _files,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text("Error: ${snapshot.error}"));
                                  } else if (snapshot.data != null) {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        File file = snapshot.data![index];
                                        if (kDebugMode) {
                                          print(file.path.split('/').last);
                                        }
                                        if (kDebugMode) {
                                          print(
                                              'Last modified: ${file.lastModifiedSync()}');
                                        }
                                        getFileDetails(file.path.toString());
                                        return ListTile(
                                          title:
                                              Text(file.path.split('/').last),
                                          subtitle: Text(
                                              'Last modified: ${formatDate(file.lastModifiedSync())} '),
                                        );
                                      },
                                    );
                                  } else {
                                    return const Center(
                                        child: Text("No files found"));
                                  }
                                },
                              ),
                            ),
                          )
                        : Text('$index');
          },
        );
      },
    );
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)} ${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}:${_addLeadingZero(dateTime.second)}';
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  Widget listTile(
      String title, IconData leading, Widget trailing, Function() click) {
    return CupertinoListTile(
      onTap: click,
      title: Text(title),
      leading: Icon(leading),
      trailing: trailing,
    );
  }
}
