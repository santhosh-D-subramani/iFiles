import 'package:flutter/cupertino.dart';

Widget errorScreen(error) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            CupertinoIcons.folder_fill,
            size: 50,
            color: CupertinoColors.systemGrey,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            error.toString(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
