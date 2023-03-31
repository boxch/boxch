import 'package:boxch/start/cubit/start_cubit.dart';
import 'package:boxch/utils/show_toasts.dart';
import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:boxch/widgets/mnemonic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                      child: CustomInkWell(
                        onTap: () => Clipboard.setData(ClipboardData(text: mnemonic)),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.copy, size: 16.0, color: Theme.of(context).cardColor),
                              SizedBox(width: 8.0),
                              Text("Copy to clipboard", style: TextStyle(color: Theme.of(context).cardColor)),
                            ],
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
                                await _cubit.signInCreateWallet(mnemonic: mnemonic);
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
                                  color:  Theme.of(context).primaryColor
                                  
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