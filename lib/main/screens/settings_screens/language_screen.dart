import 'package:boxch/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    changeLanguage(List<String> lang) {
      var local = Locale(lang.first, lang.last);
      Get.updateLocale(local);
      Hive.box(mainBox).put(boxLanguageKey, lang);
    }

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
      body: ListView(
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text("languageText".tr, style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold))),
          ListTile(
            onTap: () {
              changeLanguage(['en', 'US']);
              Navigator.pop(context);
            },
            title: Text('english'.tr),
          ),
        ],
      ),
    );
  }
}