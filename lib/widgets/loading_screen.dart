import 'package:flutter/cupertino.dart';

Widget loadingScreen() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.folder_fill,
          size: 50,
          color: CupertinoColors.systemGrey,
        ),
        SizedBox(
          height: 8,
        ),
        CupertinoActivityIndicator(),
      ],
    ),
  );
}
