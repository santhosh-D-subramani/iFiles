import 'dart:io';

import 'package:disk_space/disk_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '/common/common.dart';
import 'screens/home_page.dart';
import 'screens/sdcard.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: appName,
      theme: CupertinoThemeData(brightness: Brightness.light),
      // home: HomePage(),
      home: MyHomePage(title: appName),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  State<MyApp1> createState() => MyApp1State();
}

class MyApp1State extends State<MyApp1> {
  double _diskSpace = 0;
  double _totalDiskSpace = 0;
  Map<Directory, double> _directorySpace = {};
  Map<Directory, double> _directorySpace2 = {};

  @override
  void initState() {
    super.initState();
    initDiskSpace();
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

  @override
  Widget build(BuildContext context) {
    double usagePercent =
        (_totalDiskSpace - _diskSpace) / _totalDiskSpace * 100;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text(
                  'Space on device (MB): ${_diskSpace.toStringAsFixed(2)}\n Total : ${_totalDiskSpace.toStringAsFixed(2)}\n'),
            ),
            Text('${usagePercent.toStringAsFixed(1)} %'),
            Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var key = _directorySpace.keys.elementAt(index);
                  var value = _directorySpace[key];
                  var key2 = _directorySpace2.keys.elementAt(index);
                  var value2 = _directorySpace2[key2];

                  return Text(
                      'Space in ${key.path} (MB): $value\n Space in ${key2.path} (MB): $value2\n');
                },
                itemCount: _directorySpace.keys.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
