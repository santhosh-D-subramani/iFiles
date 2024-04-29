import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import 'about_page.dart';

settingsPage(BuildContext ctx) {
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
          const CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            middle: Text('Settings'),
          ),
          CupertinoFormSection.insetGrouped(
              margin: const EdgeInsets.all(8.0),
              children: [
                CupertinoListTile(
                  onTap: () => show(ctx, aboutPage(ctx), false),
                  title: const Row(
                    children: [
                      Icon(
                        CupertinoIcons.info,
                        color: CupertinoColors.systemYellow,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'About',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                CupertinoListTile(
                  title: const Row(
                    children: [
                      Icon(
                        CupertinoIcons.star_fill,
                        color: CupertinoColors.systemYellow,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Rate',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                CupertinoListTile(
                    title: const Row(
                  children: [
                    Icon(
                      CupertinoIcons.money_dollar_circle,
                      color: CupertinoColors.systemYellow,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Donate to Me'),
                  ],
                )),
                CupertinoListTile(
                    title: const Row(
                  children: [
                    Icon(
                      CupertinoIcons.lock_shield_fill,
                      color: CupertinoColors.systemYellow,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Privacy Policy'),
                  ],
                ))
              ]),
        ],
      ),
    ),
  ));
}
