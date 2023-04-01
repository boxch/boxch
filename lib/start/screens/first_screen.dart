import 'package:boxch/start/cubit/start_cubit.dart';
import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

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
              ),
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Expanded(
                    child: RiveAnimation.asset("assets/back_anim.riv")),
                  // Container(
                  //     padding: EdgeInsets.symmetric(vertical: 100.0),
                  //     alignment: Alignment.topCenter,
                  //     height: MediaQuery.of(context).size.height,
                  //     width: MediaQuery.of(context).size.width,
                  //     child: Container(
                  //             height: 140.0,
                  //             width: 140.0,
                  //             child: Image.asset("assets/images/boxch_welcome.png"),
                  //           )),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                            child: CustomInkWell(
                          onTap: () => _cubit.replaceCreateWallet(),
                          child: Container(
                            height: 50.0,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
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
                          CustomInkWell(
                          onTap: () => _cubit.replaceRestoreWallet(),
                          child: Container(
                            height: 50.0,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: Text('importWalletButtonText'.tr, style: TextStyle(color: Theme.of(context).hintColor)),
                          ),
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