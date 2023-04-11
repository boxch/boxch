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
import 'package:boxch/walletconnect/cubit/walletconnect_cubit.dart';
import 'package:boxch/walletconnect/screens/walletconnect_screen.dart';
import 'package:boxch/widgets/custom_switch.dart';
import 'package:boxch/widgets/mdivider.dart';
import 'package:boxch/widgets/shell_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController historyCount = TextEditingController();

  final TextEditingController password = TextEditingController();

  bool _enable = Hive.box(mainBox).get(boxBiometricKey) ?? true;

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
            ListTile(
              onTap: () => replaceWindow(context, BlocProvider<WalletConnectCubit>(
                        create: (context) => WalletConnectCubit(context),
                        child: WalletConnectScreen(),
                      )),
              leading: ShellContainer(child: Image.asset("assets/images/wallet_connect.png", height: 28.0, width: 28.0)),
              title:
                  Text('WalletConnect', style: TextStyle(fontSize: 14.0, color: Theme.of(context).cardColor)),
            ),
            Mdivider(),
            ListTile(
              leading: ShellContainer(child: Icon(Iconsax.key5,
                  color: Theme.of(context).hintColor, size: 21.0)),
              title:
                  Text('privateKeyText'.tr, style: TextStyle(fontSize: 14.0, color: Theme.of(context).cardColor)),
              onTap: () {
                var box = Hive.box(walletBox);
                final LocalWallet current = box.get(boxCurrentWalletKey);
                replaceWindow(
                    context, InfoScreen(information: current.secretKey));
              },
            ),
            Mdivider(),
            ListTile(
              leading: ShellContainer(child: SvgPicture.asset("assets/icons/users.svg", height: 21.0, width: 21.0)),
              title:
                  Text('referralProgramText'.tr, style: TextStyle(fontSize: 14.0, color: Theme.of(context).cardColor)),
              onTap: () {
                

              },
            ),
            Mdivider(),
            ListTile(
              leading: ShellContainer(child: Icon(Iconsax.password_check5,
                  color: Theme.of(context).hintColor, size: 21.0)),
              title: Text('changePasswordText'.tr,
                  style: TextStyle(fontSize: 14.0, color: Theme.of(context).cardColor)),
              onTap: () {
                replaceWindow(context, ChangePasswordScreen());
              },
            ),
            SizedBox(height: 8.0),
            ListTile(
              leading: ShellContainer(child: Icon(Iconsax.finger_scan,
                  color: Theme.of(context).hintColor, size: 21.0)),
              title: Text('biometricAuthText'.tr,
                  style: TextStyle(fontSize: 14.0, color: Theme.of(context).cardColor)),
              trailing: CustomSwitch(
                  value: _enable,
                  onChanged: (bool val) async {
                        _enable = val;
                        await Hive.box(mainBox).put(boxBiometricKey, val);
                      setState(() {});
                  },
                ),
            ),
            SizedBox(height: 8.0),
            ListTile(
              onTap: () => replaceWindow(context, LanguageScreen()),
              leading: ShellContainer(child: Icon(Iconsax.global5,
                  color: Theme.of(context).hintColor, size: 21.0)),
              title:
                  Text('changeLanguage'.tr, style: TextStyle(fontSize: 14.0, color: Theme.of(context).cardColor)),
            ),
            SizedBox(height: 8.0),
            ListTile(
              leading: ShellContainer(child: Icon(Iconsax.star5,
                  color: Theme.of(context).hintColor)),
              title:
                  Text('likingBoxchText'.tr, style: TextStyle(fontSize: 14.0, color: Theme.of(context).cardColor)),
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
            SizedBox(height: 8.0),
            ListTile(
              leading: ShellContainer(child: Icon(Iconsax.message_question5,
                  color: Theme.of(context).hintColor, size: 21.0)),
              title: Text('needHelpText'.tr, style: TextStyle(fontSize: 14.0, color: Theme.of(context).cardColor)),
              onTap: () =>
                  replaceWindow(context, WebviewScreen(urlLink: telegramChat)),
            ),
            Mdivider(),
            ListTile(
              leading: ShellContainer(child: Icon(Iconsax.lock5,
                  color: Theme.of(context).hintColor, size: 21.0)),
              title: Text('privacyPolicyText'.tr,
                  style: TextStyle(fontSize: 14.0, color: Theme.of(context).cardColor)),
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
                    border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.5), width: 0.1)
                  ),
                  child: Text("exitText".tr,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).cardColor)),
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/boxch_welcome.png", height: 30.0, width: 30.0),
                SizedBox(width: 8.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appName, style: TextStyle(fontSize: 14.0, color: Theme.of(context).hintColor.withOpacity(0.5))),
                    Text(appVersion,
                        style: TextStyle(
                            fontSize: 10.0, color: Theme.of(context).hintColor.withOpacity(0.5))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
