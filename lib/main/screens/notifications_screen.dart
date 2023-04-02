import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
                  leading: IconButton(
                    focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
          icon: Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
    ),
    body: Center(
      child: Text("empty", style: TextStyle(color: Theme.of(context).hintColor)),
    ));
  }
}