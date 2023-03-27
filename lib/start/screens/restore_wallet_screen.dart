import 'package:boxch/start/cubit/start_cubit.dart';
import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class RestoreWalletScreen extends StatefulWidget {
  static TextEditingController controllerRestoreWallet = TextEditingController();
  const RestoreWalletScreen({ Key? key }) : super(key: key);

  @override
  State<RestoreWalletScreen> createState() => _RestoreWalletScreenState();
}

class _RestoreWalletScreenState extends State<RestoreWalletScreen> {

  bool keyState = false;

  @override
  Widget build(BuildContext context) {
    final StartCubit _cubit = context.read<StartCubit>();
    return BlocProvider<StartCubit>(
      create: (context) => StartCubit(),
      child: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: IconButton(
                      focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
              icon: Icon(Iconsax.arrow_left),
              onPressed: () => _cubit.backFirstScreen(),
            ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          CustomInkWell(
                            onTap: () {
                              keyState = false;
                              setState(() {});
                            },
                            child: Text(
                              'enterMnemonicText'.tr,
                              style: TextStyle(fontSize: 18.0, color: keyState ? Theme.of(context).hintColor.withOpacity(0.5) : Theme.of(context).cardColor),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          CustomInkWell(
                            onTap: () {
                              keyState = true;
                              setState(() {});
                            },
                            child: Text(
                              'enterPrivateKeyText'.tr,
                              style: TextStyle(fontSize: 18.0, color: keyState ? Theme.of(context).cardColor : Theme.of(context).hintColor.withOpacity(0.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        child: TextFormField(
                          controller: RestoreWalletScreen.controllerRestoreWallet,
                          minLines: 4,
                          maxLines: 5,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))
                            ),
                            suffixIcon: TextButton(
                              child: Text(
                                'pasteText'.tr,
                                style: TextStyle(fontSize: 20.0, color: Colors.blue),
                              ),
                              onPressed: () {
                                Clipboard.getData(Clipboard.kTextPlain).then(
                                    (value) =>
                                        RestoreWalletScreen.controllerRestoreWallet.text = value!.text!);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                              child: InkWell(
                            onTap: () async {
                                await _cubit.signInCreateWallet(
                                      keyState: keyState,
                                      mnemonic: RestoreWalletScreen.controllerRestoreWallet.text);
                              },
                            child: Container(
                                height: 50.0,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('signInText'.tr, style: TextStyle(fontSize: 21.0, color: Theme.of(context).cardColor)),
                                    Icon(Iconsax.arrow_right_1, size: 21.0, color: Colors.grey),
                                ],),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 0.1),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context).primaryColor
                                ),
                              ),
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}