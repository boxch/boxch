import 'package:boxch/start/cubit/start_cubit.dart';
import 'package:boxch/widgets/mnemonic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CreateWalletScreen extends StatelessWidget {
  final String mnemonic;
  const CreateWalletScreen({ Key? key, required this.mnemonic }) : super(key: key);

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
              body: Column(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      height: 55.0,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.amber.withOpacity(0.15)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Iconsax.info_circle, color: Colors.amber),
                          SizedBox(width: 8.0),
                          Text(
                            'createWalletScreenText'.tr,
                            style: TextStyle(color: Colors.amber),
                          ),
                        ],
                      ),
                    ),),
                    SizedBox(height: 16.0),
                    MnemonicWidget(mnemonic: mnemonic),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.camera_slash, color: Theme.of(context).hintColor),
                                SizedBox(width: 8.0),
                                Text("Don't take a screenshot"),
                              ],
                            ),
                            SizedBox(height: 32.0),
                            Row(
                              children: [
                                Icon(Iconsax.message_edit, color: Theme.of(context).hintColor),
                                SizedBox(width: 8.0),
                                Text("Write down on paper"),
                              ],
                            )
                          ],
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
                                      seed: mnemonic);
                              },
                            child: Container(
                                height: 50.0,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('signInText'.tr, style: TextStyle(fontSize: 21.0, color: Colors.black)),
                                    Icon(Iconsax.arrow_right_1, size: 21.0, color: Colors.black),
                                ],),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color:  Theme.of(context).colorScheme.onPrimary
                                  
                                ),
                              ),
                            ),
                          ),
                      ),
                    ),
                  ],
                ),
            ),
    );
  }
}