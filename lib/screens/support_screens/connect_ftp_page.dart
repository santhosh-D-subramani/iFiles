import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samba_browser/samba_browser.dart';
import '/support/share_prefs.dart';

class ConnectToServer extends StatefulWidget {
  const ConnectToServer({super.key});

  @override
  State<ConnectToServer> createState() => _ConnectToServerState();
}

class _ConnectToServerState extends State<ConnectToServer> {
  TextEditingController serverTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool guest = false;
  bool registeredUser = true;
  Future<List>? shareFuture;

  void toggleBoolValue(bool isGuest) {
    setState(() {
      if (isGuest) {
        guest = true;
        registeredUser = false;
      } else {
        guest = false;
        registeredUser = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: CupertinoPageScaffold(
        backgroundColor: const CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.secondarySystemBackground,
            darkColor: CupertinoColors.black),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoNavigationBar(
              // middle: const Text('Connect to Server'),
              leading: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  const Text('Connect to Server'),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          if (serverTextEditingController.text.isNotEmpty) {
                            setState(() {
                              shareFuture = SambaBrowser.getShareList(
                                  serverTextEditingController.text,
                                  '',
                                  nameTextEditingController.text,
                                  passwordTextEditingController.text);
                            });
                            if (shareFuture != null) {
                              BoolStorage boolBunk = BoolStorage();
                              boolBunk.setServerUrl(
                                  serverTextEditingController.text);
                              boolBunk
                                  .setUsername(nameTextEditingController.text);
                              boolBunk.setPassword(
                                  passwordTextEditingController.text);
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text(
                          'Connect',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ))
                ],
              ),
            ),
            CupertinoFormSection.insetGrouped(
                margin: const EdgeInsets.all(8.0),
                children: [
                  CupertinoListTile(
                      title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Server'),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: CupertinoTextField(
                        decoration: const BoxDecoration(),
                        controller: serverTextEditingController,
                        autocorrect: true,
                      )),
                    ],
                  ))
                ]),
            CupertinoFormSection.insetGrouped(
                margin: const EdgeInsets.all(8.0),
                header: const Text('CONNECT AS'),
                children: [
                  CupertinoListTile(
                    onTap: () => toggleBoolValue(true),
                    title: const Text('Guest'),
                    trailing:
                        guest ? const Icon(CupertinoIcons.check_mark) : null,
                  ),
                  CupertinoListTile(
                    onTap: () => toggleBoolValue(false),
                    title: const Text('Registered User'),
                    trailing: registeredUser
                        ? const Icon(CupertinoIcons.check_mark)
                        : null,
                  ),
                ]),
            Visibility(
              visible: registeredUser,
              child: CupertinoFormSection.insetGrouped(
                  margin: const EdgeInsets.all(8.0),
                  children: [
                    CupertinoListTile(
                        title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Name'),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: CupertinoTextField(
                          decoration: const BoxDecoration(),
                          controller: nameTextEditingController,
                          autocorrect: true,
                        )),
                      ],
                    )),
                    CupertinoListTile(
                        title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text('Password'),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: CupertinoTextField(
                          decoration: const BoxDecoration(),
                          controller: passwordTextEditingController,
                          autocorrect: true,
                        )),
                      ],
                    ))
                  ]),
            ),
            if (shareFuture != null)
              FutureBuilder(
                  future: shareFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Column(children: [
                        const Text('An error has occurred.'),
                        Text(snapshot.error.toString())
                      ]);
                    }

                    if (!snapshot.hasData) {
                      return const CupertinoActivityIndicator();
                    }

                    List<String> shares =
                        (snapshot.data as List).cast<String>();
                    return Column(
                        children: shares.map((e) => Text(e)).toList());
                  })
          ],
        ),
      ),
    ));
  }
}
