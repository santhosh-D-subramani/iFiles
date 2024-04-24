import 'dart:io';

import 'package:disk_space/disk_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import '/common/common.dart';
import 'screens/home_page.dart';
import 'screens/support_screens/modal_fit.dart';

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
      theme: const CupertinoThemeData(brightness: Brightness.light),
      // home: HomePage(),
      // home: MyHomePage(title: appName),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialWithModalsPageRoute(
                builder: (_) => const MyHomePage(
                      title: appName,
                    ),
                settings: settings);
        }
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: CupertinoScaffold(
              body: Builder(
                builder: (context) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    transitionBetweenRoutes: true,
                    middle: const Text('Normal Navigation Presentation'),
                    trailing: GestureDetector(
                      child: const Icon(Icons.arrow_upward),
                      onTap: () =>
                          CupertinoScaffold.showCupertinoModalBottomSheet(
                        expand: true,
                        context: context,
                        backgroundColor: CupertinoColors.systemBackground,
                        builder: (context) => Stack(
                          children: <Widget>[
                            Positioned(
                              height: 40,
                              left: 40,
                              right: 40,
                              bottom: 20,
                              child: MaterialButton(
                                onPressed: () => Navigator.of(context).popUntil(
                                    (route) => route.settings.name == '/'),
                                child: const Text('Pop back home'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: Center(
                    child: ModalFit(
                      title: '',
                    ),
                  ),
                ),
              ),
            ),
          ),
          settings: settings,
        );
      },
    );
  }
}
