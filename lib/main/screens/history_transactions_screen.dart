import 'package:boxch/history/history_cubit.dart';
import 'package:boxch/history/history_states.dart';
import 'package:boxch/main/screens/webview_screen.dart';
import 'package:boxch/utils/constants.dart';
import 'package:boxch/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HistoryTransactionsScreen extends StatelessWidget {
  final String mint;
  final String balance;
  final String amount;
  HistoryTransactionsScreen({required this.mint, required this.balance, required this.amount});

 Widget returnWidget(context, {required double balance, required double amount, required HistoryCubit cubit, required String mint}) {

    if (balance == 0.0 && amount == 0.0 && mint != SOL || mint == WSOL) {
      return InkWell(
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        onTap: () => closeDialog(context, type: 0, cubit: cubit),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.delete, color: Colors.red),
            Text("closeAccount".tr, style: TextStyle(fontSize: 12.0)),
            SizedBox()
          ],
        ),
      );
    } else if (balance > 1.0 && mint != SOL) {
      return InkWell(
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.local_fire_department_outlined, color: Colors.red),
              Text("burnAndCloseAccountText".tr, style: TextStyle(fontSize: 12.0)),
              SizedBox()
            ],
          ),
          onTap: () => closeDialog(context, type: 1, cubit: cubit),
        );
    }
    return SizedBox();
  }

  closeDialog(BuildContext context, {required int type, required HistoryCubit cubit, }) => showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Close account?'),
                Divider(),
                Text('This feature closes the account and returns the SOL for rent to your account', style: TextStyle(fontSize: 14.0)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (type == 0) {
                    //cubit.closeTokenAccount(context, tokenAddress: mint);
                    Navigator.of(context).pop();
                  } else if (type == 1) {
                    //cubit.burnAndCloseTokenAccount(context, tokenAddress: mint, amount: double.parse(amount));
                    Navigator.of(context).pop();
                  }
                  
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
    var _cubit = context.read<HistoryCubit>();
    return BlocProvider<HistoryCubit>(
      create: (context) => HistoryCubit(state: mint),
      child: Scaffold(
        appBar: AppBar(
                  leading: IconButton(
                    focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
          icon: Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
           PopupMenuButton(
          splashRadius: 5.0,
          icon: Icon(Icons.more_vert_rounded, color: Theme.of(context).hintColor),
          itemBuilder: (context){
            return [
              PopupMenuItem<int>(
                      value: 0,
                      child: returnWidget(context, balance: double.parse(balance), 
                      amount: double.parse(amount), cubit: _cubit, mint: mint),
                  ),
                  PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/images/solscan.png", height: 20.0, width: 20.0),
                          Text("View on Solscan", style: TextStyle(fontSize: 12.0)),
                          SizedBox()
                        ],
                      ),
                  ),
              ];
          },
          onSelected:(value){
            if(value == 0){
                print("My account menu is selected.");
            }else if(value == 1){
                print("Settings menu is selected.");
            }else if(value == 2){
                print("Logout menu is selected.");
            }
          }
        ),
        ],
            elevation: 0.0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: BlocBuilder<HistoryCubit, HistoryStates>(
        builder: (context, state) {
          if (state is LoadingHistoryState) {
            return Center(child: SizedBox(
                  height: 25.0,
                  width: 25.0,
                  child: CircularProgressIndicator(color: Colors.greenAccent),
                ));
          }

          if (state is LoadedHistoryState) {
            return state.dataHistoryTransactions.isNotEmpty ? ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: state.dataHistoryTransactions.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => replaceWindow(context, WebviewScreen(urlLink: "https://solscan.io/tx/${state.dataHistoryTransactions[index].txHash}")),
                child: ListTile(
                  title: Text(state.dataHistoryTransactions[index].txHash,
                  style: TextStyle(fontSize: 11.0)),
                  //leading: state.dataHistoryTransactions[index].status == StatusType.success ? Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent) : Icon(Icons.error_outline_outlined, color: Colors.red),
                ),
              );
            }) : Center(child: Text("empty", style: TextStyle(color: Theme.of(context).hintColor)));
          }


          if (state is ErrorHistoryState) {
            return Center(child: Text('Error'));
          }

          return Container();
        },
      ),
      ),
    );
  }
}
