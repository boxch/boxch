import 'package:boxch/utils/functions.dart';
import 'package:boxch/walletconnect/cubit/walletconnect_cubit.dart';
import 'package:boxch/walletconnect/cubit/walletconnect_states.dart';
import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class WalletConnectScreen extends StatelessWidget {
  WalletConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletConnectCubit _walletConnectCubit =
        context.read<WalletConnectCubit>();
    return BlocBuilder<WalletConnectCubit, WalletConnectStates>(
      builder: (context, state) {
       if (state is WalletConnectScreenState) {
        return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.0),
          alignment: Alignment.bottomRight,
          child: CustomInkWell(
            onTap: ()  => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 35.0,
                width: 60.0,
                child: Text("Back", style: TextStyle(color: Theme.of(context).cardColor)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.grey.withOpacity(0.1)
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(60.0)),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/wc_scan.png"))
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
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
                            }),
                ),
              ),
              InkWell(
                radius: 100.0,
                onTap: () => scanWalletConnectRQ(context, cubit: WalletConnectCubit(context)),
                child: Container(
                  height: 70.0,
                  width: 70.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).cardColor, width: 0.5)
                  ),
                  child: Icon(Iconsax.scan_barcode, size: 32.0)),
              ),
              SizedBox(height: 32.0),
              Text("1. Go to the Dapp website", style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 16.0),
              Text("2. Click connect wallet using WalletConnect", style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 64.0),
            ],
          ),
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
            mainAxisAlignment: MainAxisAlignment.end,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 50.0,
                  width: 150.0,
                  alignment: Alignment.center,
                  child: Text("Enter the code"),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Color(0xFF5460C8)
                  ),
                ),
              ),
              ],
          ),
        );
      },
    );
  }
}
