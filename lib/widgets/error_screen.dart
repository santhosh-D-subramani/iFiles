import 'package:flutter/cupertino.dart';

Widget errorScreen(error) {
  RegExp regex = RegExp(r'OS Error: (.+),');
  Match? match = regex.firstMatch(error.toString());
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
          if (match != null)
            Text(
              match.group(1)!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
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
