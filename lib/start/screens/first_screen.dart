import 'package:boxch/start/cubit/start_cubit.dart';
import 'package:boxch/utils/links.dart';
import 'package:boxch/utils/show_toasts.dart';
import 'package:boxch/widgets/checkbox_wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StartCubit _cubit = context.read<StartCubit>();
    return BlocProvider<StartCubit>(
      create: (context) => StartCubit(),
      child: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text("Boxch.net", style: TextStyle(fontSize: 16.0, color: Theme.of(context).hintColor)),
                centerTitle: true,
              ),
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 100.0),
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                              height: 140.0,
                              width: 140.0,
                              child: Image.asset("assets/images/boxch_welcome.png"),
                            )),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CheckBoxWallet(),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  'loginTermsText'.tr,
                                  style: TextStyle(fontSize: 12.0, color: Theme.of(context).hintColor),
                                ),
                                InkWell(
                                  onTap: () => launchUrl(Uri.parse(termsOfCond)),
                                  child: Text(
                                    'Terms of conditions',
                                    style: TextStyle(fontSize: 12.0, color: Colors.amber),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Material(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                            child: InkWell(
                              onTap: () {
                                if (CheckBoxWallet.checkBoxButton) {
                                  _cubit.replaceCreateWallet();
                                } else {
                                  errorShowToast(context, message: "Agree to the terms");
                                }
                              },
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                height: 50.0,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text('createWalletButtonText'.tr, style: TextStyle(color: Theme.of(context).hintColor)),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 0.1),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          InkWell(
                              onTap: () {
                                if (CheckBoxWallet.checkBoxButton) {
                                  _cubit.replaceRestoreWallet();
                                } else {
                                  errorShowToast(context, message: "Agree to the terms");
                                }
                              },
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                height: 50.0,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text('importWalletButtonText'.tr, style: TextStyle(color: Theme.of(context).hintColor)),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 0.1),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context).primaryColor
                                ),
                              ),
                          ),
                            ],
                          ),
                          Container(
                            height: 105.0,
                            width: 90.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Iconsax.strongbox_2, color: Theme.of(context).cardColor),
                                SizedBox(height: 8.0),
                                Text("Safe", style: TextStyle(color: Theme.of(context).cardColor, fontSize: 12.0))
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(color: Colors.grey, width: 0.1),
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                          ),
                        ],
                      ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
    );
  }
}