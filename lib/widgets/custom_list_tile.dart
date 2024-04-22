import 'package:flutter/cupertino.dart';

Widget listTile(
    String title, IconData leading, Widget trailing, Function() click) {
  return CupertinoListTile(
    onTap: click,
    title: Text(title),
    leading: Icon(leading),
    trailing: trailing,
  );
}
