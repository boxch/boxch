import 'package:boxch/utils/show_toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oktoast/oktoast.dart';

class InfoScreen extends StatelessWidget {
  final String information;
  InfoScreen({ Key? key, required this.information }) : super(key: key);

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
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("seedPhraseText".tr, style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold))),
          Expanded(
            child: Container(
              alignment: Alignment.center,
            child: Row(
          mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200.0,
                child: Text(information, style: TextStyle(fontWeight: FontWeight.bold))),
                 SizedBox(width: 10.0),
              IconButton(onPressed: () {
                Clipboard.setData(ClipboardData(text: information))
                            .then((result) {
                          okCopyToast(context);
                          Navigator.pop(context);
                        });
              }, icon: Icon(Iconsax.copy))
            ],
          ),
          )),
        ])
    );
  }
}