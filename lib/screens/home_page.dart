import 'dart:io';

import 'package:disk_space/disk_space.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:xfiles/screens/browse_page.dart';

import '../widgets/expandable_widget.dart';
import 'documents_screen.dart';
import 'folder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<File>>? _files;

  //request permission-->
  Future<bool> requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.isGranted;
    if (!status) {
      var result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    }
    return true;
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

  @override
  void initState() {
    super.initState();
    initFiles();
  }

  @override
  Widget build(BuildContext context) {
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
                ? const Browse()
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
                            SliverGrid.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200.0,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                  childAspectRatio: 4.0,
                                ),
                                itemBuilder: (context, index) {
                                  File file = _files! as File;
                                  if (kDebugMode) {
                                    print(file.path.split('/').last);
                                  }
                                  if (kDebugMode) {
                                    print(
                                        'Last modified: ${file.lastModifiedSync()}');
                                  }
                                  return Card(
                                    child: Column(
                                      children: [
                                        const Icon(CupertinoIcons.folder_fill),
                                        Text(file.path.split('/').last),
                                        Text(
                                            'Last modified: ${formatDate(file.lastModifiedSync())} '),
                                      ],
                                    ),
                                  );
                                }
                                // FutureBuilder(
                                //   future: _files,
                                //   builder: (BuildContext context,
                                //       AsyncSnapshot<dynamic> snapshot) {
                                //
                                //     return SliverGrid.builder(
                                //         gridDelegate:
                                //             const SliverGridDelegateWithMaxCrossAxisExtent(
                                //           maxCrossAxisExtent: 200.0,
                                //           mainAxisSpacing: 10.0,
                                //           crossAxisSpacing: 10.0,
                                //           childAspectRatio: 4.0,
                                //         ),
                                //         itemBuilder: (context, index) {
                                //           File file = snapshot.data![index];
                                //           if (kDebugMode) {
                                //             print(file.path.split('/').last);
                                //           }
                                //           if (kDebugMode) {
                                //             print(
                                //                 'Last modified: ${file.lastModifiedSync()}');
                                //           }
                                //           return Card(
                                //             child: Column(
                                //               children: [
                                //                 const Icon(
                                //                     CupertinoIcons.folder_fill),
                                //                 Text(file.path.split('/').last),
                                //                 Text(
                                //                     'Last modified: ${formatDate(file.lastModifiedSync())} '),
                                //               ],
                                //             ),
                                //           );
                                //         });
                                // return SliverGrid(
                                //     delegate: SliverChildBuilderDelegate(
                                //       (BuildContext context, int index) {
                                //         return Card(
                                //           child: Column(
                                //             children: [
                                //               const Icon(CupertinoIcons
                                //                   .folder_fill),
                                //               Text(file.path
                                //                   .split('/')
                                //                   .last),
                                //               Text(
                                //                   'Last modified: ${formatDate(file.lastModifiedSync())} '),
                                //             ],
                                //           ),
                                //         );
                                //         // return Container(
                                //         //   alignment: Alignment.center,
                                //         //   color: Colors.teal[100 * (index % 9)],
                                //         //   child: Text('grid item $index'),
                                //         // );
                                //       },
                                //       childCount: snapshot.data!.length,
                                //     ),
                                //     gridDelegate:
                                //         const SliverGridDelegateWithMaxCrossAxisExtent(
                                //       maxCrossAxisExtent: 200.0,
                                //       mainAxisSpacing: 10.0,
                                //       crossAxisSpacing: 10.0,
                                //       childAspectRatio: 4.0,
                                //     ));

                                ),
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
}
