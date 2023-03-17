import 'package:boxch/start/cubit/start_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class RestoreWalletScreen extends StatelessWidget {
  static TextEditingController controllerRestoreWallet = TextEditingController();
  const RestoreWalletScreen({ Key? key }) : super(key: key);

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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'enterMnemonicText'.tr,
                        style: TextStyle(fontSize: 21.0),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        child: TextFormField(
                          controller: controllerRestoreWallet,
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
                                        controllerRestoreWallet.text = value!.text!);
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
                                      seed: controllerRestoreWallet.text);
                              },
                            child: Container(
                                height: 50.0,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('signInText'.tr, style: TextStyle(fontSize: 21.0)),
                                    Icon(Iconsax.arrow_right_1, size: 21.0),
                                ],),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context).hintColor.withOpacity(0.2)
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