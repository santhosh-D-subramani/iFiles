import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '/common/common.dart';
import '/screens/support_screens/about_page.dart';
import '/support/provider_model.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyStringModel()),
      ],
      child: const MyApp(),
    ),
  );
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
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialWithModalsPageRoute(
                builder: (_) => const MyHomePage(), settings: settings);
        }
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: CupertinoScaffold(
              body: Builder(
                builder: (context) => CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    transitionBetweenRoutes: false,
                    middle: const Text('Normal Navigation'),
                    trailing: GestureDetector(
                      child: const Icon(Icons.arrow_upward),
                      onTap: () =>
                          CupertinoScaffold.showCupertinoModalBottomSheet(
                        expand: true,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Stack(
                          children: <Widget>[
                            aboutPage(context),
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
                    child: Container(),
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
