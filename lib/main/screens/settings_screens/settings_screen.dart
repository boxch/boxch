import 'dart:io';
import 'package:boxch/main/screens/settings_screens/change_password_screen.dart';
import 'package:boxch/main/screens/settings_screens/info_screen.dart';
import 'package:boxch/main/screens/settings_screens/language_screen.dart';
import 'package:boxch/models/wallet.dart';
import 'package:boxch/main/screens/webview_screen.dart';
import 'package:boxch/utils/app_info.dart';
import 'package:boxch/utils/functions.dart';
import 'package:boxch/theme/theme_cubit.dart';
import 'package:boxch/theme/theme_icons.dart';
import 'package:boxch/theme/theme_states.dart';
import 'package:boxch/utils/constants.dart';
import 'package:boxch/utils/links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  final TextEditingController historyCount = TextEditingController();
  final TextEditingController password = TextEditingController();

  exitDialog(BuildContext context) => showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('exitText'.tr),
                Divider(),
                Text('confirmExitText'.tr, style: TextStyle(fontSize: 14.0)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  var boxWallet = Hive.box(walletBox);
                  final box = Hive.box(boxPassword);
                  await boxWallet.deleteFromDisk();
                  await box.deleteFromDisk();
                  SystemNavigator.pop();
                },
                child: Text('yesText'.tr),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('noText'.tr),
                ),
              ),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    ThemeCubit _cubit = context.read<ThemeCubit>();
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () => _cubit.changeTheme(), 
            icon: BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                  return state.icon
                      ? appicon[AppIcon.ligthIcon]!
                      : appicon[AppIcon.darkIcon]!;
                })),
          )
        ],
      ),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 32.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("GENERAL",
                  style: TextStyle(
                      fontSize: 12.0, color: Theme.of(context).hintColor)),
            ),
            ListTile(
              onTap: () => replaceWindow(context, LanguageScreen()),
              leading: Icon(Iconsax.language_square,
                  color: Theme.of(context).colorScheme.secondary, size: 21.0),
              title:
                  Text('changeLanguage'.tr, style: TextStyle(fontSize: 14.0)),
              trailing: Icon(Icons.navigate_next_outlined),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("SECURITY",
                  style: TextStyle(
                      fontSize: 12.0, color: Theme.of(context).hintColor)),
            ),
            ListTile(
              leading: Icon(Iconsax.key,
                  color: Theme.of(context).colorScheme.secondary, size: 21.0),
              title:
                  Text('privateKeyText'.tr, style: TextStyle(fontSize: 14.0)),
              trailing: Icon(Icons.navigate_next_outlined),
              onTap: () {
                var box = Hive.box(walletBox);
                final LocalWallet current = box.get(boxCurrentWalletKey);
                replaceWindow(
                    context, InfoScreen(information: current.secretKey));
              },
            ),
            ListTile(
              leading: Icon(Iconsax.password_check,
                  color: Theme.of(context).colorScheme.secondary, size: 21.0),
              title: Text('changePasswordText'.tr,
                  style: TextStyle(fontSize: 14.0)),
              trailing: Icon(Icons.navigate_next_outlined),
              onTap: () {
                replaceWindow(context, ChangePasswordScreen());
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("EXPERIENCE",
                  style: TextStyle(
                      fontSize: 12.0, color: Theme.of(context).hintColor)),
            ),
            ListTile(
              leading: Icon(Iconsax.star,
                  color: Theme.of(context).colorScheme.secondary, size: 21.0),
              title:
                  Text('likingBoxchText'.tr, style: TextStyle(fontSize: 14.0)),
              trailing: Icon(Icons.navigate_next_outlined),
              onTap: () async {
                if (Platform.isIOS) {
                  replaceWindow(context, WebviewScreen(urlLink: appInAppStore));
                }

                if (Platform.isAndroid) {
                  replaceWindow(
                      context, WebviewScreen(urlLink: appInGooglePlay));
                }
              },
            ),
            ListTile(
              leading: Icon(Iconsax.message_question,
                  color: Theme.of(context).colorScheme.secondary, size: 21.0),
              title: Text('needHelpText'.tr, style: TextStyle(fontSize: 14.0)),
              trailing: Icon(Icons.navigate_next_outlined),
              onTap: () =>
                  replaceWindow(context, WebviewScreen(urlLink: telegramChat)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("OTHERS",
                  style: TextStyle(
                      fontSize: 12.0, color: Theme.of(context).hintColor)),
            ),
            ListTile(
              leading: Icon(Iconsax.lock,
                  color: Theme.of(context).colorScheme.secondary, size: 21.0),
              title: Text('privacyPolicyText'.tr,
                  style: TextStyle(fontSize: 14.0)),
              trailing: Icon(Icons.navigate_next_outlined),
              onTap: () async => await launchUrl(Uri.parse(privacyPolicy)),
            ),
            Padding(
              padding: EdgeInsets.all(32.0),
              child: InkWell(
                onTap: () => exitDialog(context),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.5), width: 0.5)
                  ),
                  child: Text("exitText".tr,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).hintColor)),
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(appName, style: TextStyle(fontSize: 16.0, color: Theme.of(context).hintColor)),
                Text(appVersion,
                    style: TextStyle(
                        fontSize: 12.0, color: Theme.of(context).hintColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
