import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../support/show_all_extension_prefs.dart';

class ShowExtensionWidget extends StatefulWidget {
  const ShowExtensionWidget({
    super.key,
    required this.hideMenu,
  });

  final VoidCallback hideMenu;

  @override
  State<ShowExtensionWidget> createState() => _ShowExtensionWidgetState();
}

class _ShowExtensionWidgetState extends State<ShowExtensionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
        leading: !Provider.of<ShowAllExtensionPrefs>(context).value
            ? const Icon(CupertinoIcons.check_mark)
            : null,
        onTap: () async {
          Provider.of<ShowAllExtensionPrefs>(context, listen: false)
              .toggleValue();
          widget.hideMenu();
        },
        title: const Text('Show All Extensions'));
  }
}
