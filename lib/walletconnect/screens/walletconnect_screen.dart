import 'package:boxch/utils/functions.dart';
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
        builder: (context, state) {

      if (state is WalletConnectScreenState) {
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
                          itemCount: state.session.length,
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
                                  title: Text(state.session[index]!.peer.metadata.name),
                                  subtitle: Text(state.session[index]!.peer.metadata.url),
                                  trailing: TextButton(
                                    style: ButtonStyle(),
                                    child: Text("Disconnect",
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () =>
                                        _walletConnectCubit.disconnect(
                                            sessionData: state
                                                .session[index]!),
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
      { required WalletConnectCubit cubit}) {
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
                      } else{
                          RunOnce().call(() async => await cubit.connect(wsUrl: barcode.rawValue!));
                          Navigator.pop(context);
                        
                        
                      }
                    }),
              ),
              TextButton(onPressed: () => cubit.connect(wsUrl: "wc:bb01e6ad6b9fa29c5fa5ef5fd36fdefe0c0038a76f2222a8556fc55bf84e4575@2?relay-protocol=irn&symKey=9be8f4119f73948486c88809d4b80312bc40f0f22c7747526ff437f44fdc4255"), child: Text("sdf"))
            ],
          ),
        );
      },
    );
  }
}
