import 'package:flutter/material.dart';

class CheckBoxWallet extends StatefulWidget {
  static bool checkBoxButton = false;
  @override
  _CheckBoxWalletState createState() => _CheckBoxWalletState();
}

class _CheckBoxWalletState extends State<CheckBoxWallet> {

  @override
  void dispose() {
    CheckBoxWallet.checkBoxButton = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        CheckBoxWallet.checkBoxButton = !CheckBoxWallet.checkBoxButton;
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CheckBoxWallet.checkBoxButton ? Container(
          height: 20.0,
          width: 20.0,
          alignment: Alignment.center,
          child: Icon(Icons.check_rounded, size: 12.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.blue
            )
          ),
        ) : Container(
          height: 20.0,
          width: 20.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.grey
            )
          ),
        ),
      ),
    );
  }
}
