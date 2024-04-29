import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';

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

  // Future<bool> connectToFTPServer(host, user, pass) async {
  //   FTPConnect ftpConnect = FTPConnect(
  //     host,
  //     user: user,
  //     pass: pass,
  //     showLog: true,
  //     timeout: 120,
  //   );
  //   return await ftpConnect.connect();
  //
  // }

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
                            final FTPConnect ftpConnect = FTPConnect(
                              "172.20.10.2",
                              user: "pc",
                              pass: "123",
                              showLog: true,
                            );
                            // connectToFTPServer(
                            //     serverTextEditingController.text,
                            //     nameTextEditingController.text,
                            //     passwordTextEditingController.text);
                            await ftpConnect.connect();
                            if (ftpConnect.connect().toString() !=
                                'Connecting...') {
                              print('connected ');
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              print('connecting or error ');
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
              //  trailing:
              //     GestureDetector(onTap: () {}, child: const Text('Connect')),
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
          ],
        ),
      ),
    ));
  }
}
