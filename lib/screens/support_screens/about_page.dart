import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

aboutPage(BuildContext context) {
  String about =
      "iNotes is a powerful and intuitive notes taking app designed to streamline your note-taking experience with ease and simplicity. Whether you're a student, professional, or simply someone who loves to stay organized, iNotes offers a feature-rich platform that ensures you never miss a beat.";
  return Material(
    child: SafeArea(
      child: CupertinoPageScaffold(
          // backgroundColor: const CupertinoDynamicColor.withBrightness(
          //     color: CupertinoColors.secondarySystemBackground,
          //     darkColor: Color(0xFF1f1e1e)),
          backgroundColor: CupertinoColors.secondarySystemBackground,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                          fontSize: 20,
                          color: CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.systemYellow,
                              darkColor: CupertinoColors.systemYellow)),
                    ),
                    Container(
                      height: 10,
                    ),
                    Text(
                      about,
                      style: const TextStyle(
                          color: CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.black,
                              darkColor: CupertinoColors.white)),
                    ),
                    Container(
                      height: 10,
                    ),
                  ],
                )
              ],
            ),
          )),
    ),
  );
}
