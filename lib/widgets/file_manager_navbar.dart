import 'package:custom_pop_up_menu_fork/custom_pop_up_menu.dart';
import 'package:file_manager/controller/file_manager_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '/widgets/popup_animation_builder.dart';
import '/widgets/show_extension_widget.dart';
import '../common/common.dart';
import '../screens/support_screens/connect_ftp_page.dart';
import '../support/provider_model.dart';

ObstructingPreferredSizeWidget fileManagerNavbar(
  BuildContext context,
  CustomPopupMenuController controllerMiddle,
  FileManagerController controller,
  VoidCallback setStateCaller,
  String? appTitle,
) {
  var i = Provider.of<MyStringModel>(context, listen: false);

  return CupertinoNavigationBar(
    ///title pop up menu
    middle: CustomPopupMenu(
      controller: controllerMiddle,
      enablePassEvent: false,
      pressType: PressType.longPress,
      child: ValueListenableBuilder(
          valueListenable: controller.titleNotifier,
          builder: (context, title, _) {
            return Text(
              title == '0' ? appTitle ?? '' : title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          }),
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: CupertinoListSection(
            topMargin: 0,
            children: [
              CupertinoListTile(
                onTap: () {
                  controllerMiddle.hideMenu();
                  createFolder(context, controller);
                },
                title: const Text('New Folder'),
                trailing: const Icon(CupertinoIcons.folder_fill_badge_plus),
              ),
              if (i.isFile.isNotEmpty)
                CupertinoListTile(
                  onTap: () {
                    controllerMiddle.hideMenu();
                    if (i.isFile == 'true') {
                      i.taskName == 'Move'
                          ? moveFile(i.myString, controller.getCurrentPath)
                          : copyFiles(i.myString, controller.getCurrentPath);
                      setStateCaller();
                      // setState(() {});
                    } else if (i.isFile == 'false') {
                      i.taskName == 'Move'
                          ? movePath(i.myString, controller.getCurrentPath)
                          : copyPath(i.myString, controller.getCurrentPath);
                      setStateCaller();
                      //setState(() {});
                    }
                    if (kDebugMode) {
                      print('path: ${i.myString}');
                      print('task; ${i.taskName}');
                      print(controller.getCurrentPath);
                      print('isFile: ${i.isFile}');
                    }
                  },
                  title: const Text('Paste'),
                  trailing: const Icon(CupertinoIcons.doc_on_clipboard),
                ),
              CupertinoListTile(
                onTap: () {
                  controllerMiddle.hideMenu();
                },
                title: const Text('Get Info'),
                trailing: const Icon(CupertinoIcons.info_circle),
              ),
            ],
          ),
        ),
      ),
    ),

    ///top right pop up menu
    trailing: PopupMenuButtonWidget(
        childBuilder: (hideMenu) => ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.4,
                child: CupertinoListSection(
                  topMargin: 0,
                  children: [
                    CupertinoListTile(
                      onTap: () {
                        createFolder(context, controller);
                        hideMenu();
                      },
                      title: const Text('New Folder'),
                      trailing: const Icon(
                          CupertinoIcons.slider_horizontal_below_rectangle),
                    ),
                    if (i.isFile.isNotEmpty)
                      CupertinoListTile(
                        onTap: () {
                          hideMenu();

                          if (i.isFile == 'true') {
                            i.taskName == 'Move'
                                ? moveFile(
                                    i.myString, controller.getCurrentPath)
                                : copyFiles(
                                    i.myString, controller.getCurrentPath);
                            setStateCaller();
                            // setState(() {});
                          } else if (i.isFile == 'false') {
                            i.taskName == 'Move'
                                ? movePath(
                                    i.myString, controller.getCurrentPath)
                                : copyPath(
                                    i.myString, controller.getCurrentPath);
                            setStateCaller();
                            // setState(() {});
                          }
                          if (kDebugMode) {
                            print('path: ${i.myString}');
                            print('task; ${i.taskName}');
                            print(controller.getCurrentPath);
                            print('isFile: ${i.isFile}');
                          }
                        },
                        title: const Text('Paste'),
                        trailing:
                            const Icon(CupertinoIcons.doc_on_clipboard_fill),
                      ),
                    CupertinoListTile(
                        onTap: () {
                          hideMenu();
                          //controllerTrailing.hideMenu();
                        },
                        title: const Text('Icons')),
                    CupertinoListTile(
                        onTap: () {
                          hideMenu();
                        },
                        title: const Text('List')),
                    CupertinoListTile(
                        onTap: () {
                          hideMenu();
                        },
                        title: const Text('Name')),
                    CupertinoListTile(
                        onTap: () {
                          hideMenu();
                        },
                        title: const Text('Kind')),
                    CupertinoListTile(
                        onTap: () {
                          hideMenu();
                        },
                        title: const Text('Date')),
                    CupertinoListTile(
                        onTap: () {
                          hideMenu();
                        },
                        title: const Text('Size')),
                    CupertinoListTile(
                        onTap: () {
                          show(context, const ConnectToServer(), true);
                          hideMenu();
                        },
                        title: const Text('Tags')),

                    ///widget
                    ShowExtensionWidget(
                      hideMenu: hideMenu,
                    ),
                  ],
                ),
              ),
            )),
  );
}
