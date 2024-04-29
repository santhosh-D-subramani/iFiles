import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xfiles/screens/documents_screen.dart';
import 'package:xfiles/screens/folder.dart';

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
        child: CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemFill,
      navigationBar:
          CupertinoNavigationBar(leading: Text(''), middle: Text('Help')),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '1.Click on your favourite food \n 2.Choose the quantity and click add to cart \n 3.click cart icon on top left \n 4.check and remove items and click pay \n 5. Select payment method and pay \n Your order will be placed , if shopkeeper calls your token number go fetch your food',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    ));
  }
}
