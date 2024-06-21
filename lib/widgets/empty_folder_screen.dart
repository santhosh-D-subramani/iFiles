import 'package:flutter/cupertino.dart';

Widget emptyFolderScreen() {
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
        Text(
          'Folder is Empty',
          style: TextStyle(
            fontSize: 30,
            // fontWeight: FontWeight.bold
          ),
        ),
      ],
    ),
  );
}
