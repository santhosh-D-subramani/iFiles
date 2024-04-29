import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '/screens/browse_page.dart';
import '/screens/recents_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.isGranted;
    if (!status) {
      await Permission.manageExternalStorage.request();
    }
  }

  @override
  void initState() {
    requestStoragePermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Browse();
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        height: 70,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder_fill),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.clock_solid),
            label: 'Recents',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return index == 0 // home
                ? const Browse()
                : index == 1 // Recents
                    ? const RecentsPage()
                    : Text('$index');
          },
        );
      },
    );
  }
}
