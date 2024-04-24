import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xfiles/screens/documents_screen.dart';
import 'package:xfiles/screens/folder.dart';

class ModalFit extends StatelessWidget {
  const ModalFit({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: CupertinoPageScaffold(
        child: CupertinoListSection(
          children: [CupertinoListTile(title: Text('title'))],
        ),
        //DocumentScreen(title: title)
      ),
    ));
  }
}
