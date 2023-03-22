import 'package:boxch/walletconnect/cubit/walletconnect_cubit.dart';
import 'package:boxch/walletconnect/cubit/walletconnect_states.dart';
import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class WalletConnectScreen extends StatelessWidget {
  const WalletConnectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WalletConnectCubit _walletConnectCubit =
        context.read<WalletConnectCubit>();
    return BlocBuilder<WalletConnectCubit, WalletConnectStates>(
        builder: (context, builderState) {
      if (builderState is WalletConnectScreenState) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(Iconsax.arrow_left),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Connect your wallet to Dapp via WalletConnect",
                      style: TextStyle(
                          fontSize: 16.0, color: Theme.of(context).hintColor)),
                  SizedBox(height: 16.0),
                  CustomInkWell(
                    onTap: () => scanWalletConnectRQ(context,
                        cubit: _walletConnectCubit),
                    child: Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("New connect",
                          style: TextStyle(color: Colors.black)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.blue),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  Expanded(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: builderState.session.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                height: 70.0,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    border: Border.all(
                                        color: Theme.of(context).hintColor,
                                        width: 0.5),
                                    borderRadius: BorderRadius.circular(5.0)),
                                alignment: Alignment.center,
                                child: ListTile(
                                  leading: Icon(Icons.monitor),
                                  title: Text(builderState.session[index]!
                                      .session.peer.metadata.name),
                                  trailing: TextButton(
                                    style: ButtonStyle(),
                                    child: Text("Disconnect",
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () =>
                                        _walletConnectCubit.disconnect(
                                            index: index,
                                            sessionData: builderState
                                                .session[index]!.session),
                                  ),
                                ),
                              ),
                            );
                          })),
                ],
              )),
        );
      }

      return Container();
    });
  }

  scanWalletConnectRQ(BuildContext context,
      {required WalletConnectCubit cubit}) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (builder) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: MobileScanner(
                    allowDuplicates: false,
                    onDetect: (barcode, args) async {
                      if (barcode.rawValue == null) {
                        debugPrint('Failed to scan Barcode');
                      } else {
                        await cubit.init(wsUrl: barcode.rawValue!);
                        Navigator.pop(context);
                      }
                    }),
              ),
              TextButton(onPressed: () => cubit.init(wsUrl: "wc:2cc1ce8b2dbff965466616d7fe0d8484a6a8f7b0333664a104ad18eb04e5256c@2?relay-protocol=irn&symKey=368fe8a38e8c125c9599cffb3c8a4ae699e9b7fca75f7a218b914f781dea6eff"), child: Text("sdf"))
            ],
          ),
        );
      },
    );
  }
}
