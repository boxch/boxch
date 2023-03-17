import 'dart:io';
import 'package:boxch/main/cubit/main_cubit.dart';
import 'package:boxch/main/screens/qr_screen.dart';
import 'package:boxch/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';

// ignore: must_be_immutable
class SendScreen extends StatefulWidget {
  final String name;
  final String symbol;
  final String address;
  final tokenBalance;
  Map? quick;
  SendScreen({required this.name, required this.address, required this.symbol, required this.tokenBalance, this.quick});
  static TextEditingController destinationWallet = TextEditingController();

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
    var valueNumber;
    var tx;

  Widget? setStateSubmit({required tx}) {
    if (tx != null && tx != false) {
      return Icon(Icons.check_circle_outline_rounded);
    } else if (tx != null && tx == false) {
      return Icon(Icons.clear);
    } else {
      return SizedBox(height: 25.0, width: 25.0, child: CircularProgressIndicator(color: Colors.amber, strokeWidth: 2.0,));
    }
  }

  tapNumber({required String number}) {
    if (number == "clear") {
      setState(() {
       valueNumber = valueNumber.toString().replaceRange(valueNumber.toString().length - 1, valueNumber.toString().length , '');
      });
    } else {
      if (valueNumber == null) {
        valueNumber = "";
      }
      setState(() {
        valueNumber = "$valueNumber$number";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _cubit = context.read<MainCubit>();
    return BlocProvider<MainCubit>(
        create: (context) => MainCubit(context),
        child: Scaffold(
            appBar: AppBar(
                      leading: IconButton(
                        focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
          icon: Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
              elevation: 0.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                   widget.quick != null ? Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 32.0),
                     child: Container(
                       height: 100.0,
                       padding: EdgeInsets.symmetric(horizontal: 16.0),
                       width: MediaQuery.of(context).size.width,
                       decoration: BoxDecoration(
                         color: Theme.of(context).primaryColor,
                         borderRadius: BorderRadius.circular(30.0),
                       ),
                       child: Row(
                         children: [
                           ClipRRect(
                             borderRadius: BorderRadius.circular(20.0),
                             child: Container(
                               alignment: Alignment.center,
                               height: 80.0,
                               width: 80.0,
                               child: widget.quick!['image'] != "" ? Image.file(File.fromUri(Uri.parse(widget.quick!['image'])), height: 80.0, width: 80.0, fit: BoxFit.fill) : Text(widget.quick!['name'].toString().substring(0, 1), style: TextStyle(fontSize: 21.0)),
                               decoration: BoxDecoration(
                                 color: Colors.grey.withOpacity(0.3),
                                 borderRadius: BorderRadius.circular(20.0)
                               ),
                             ),
                           ),
                           SizedBox(width: 16.0),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text(widget.quick!["name"], style: TextStyle(fontSize: 18.0)),
                               SizedBox(height: 8.0),
                               Text("${widget.quick!["address"].toString().substring(0, 2)} . . . ${widget.quick!["address"].toString().substring(widget.quick!["address"].toString().length - 16, widget.quick!["address"].toString().length)}", style: TextStyle(color: Theme.of(context).hintColor)),
                             ],
                           ),
                         ],
                       ),
                     ),
                   )  : Column(
                     children: [
                      SizedBox(),
                       Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: 140.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: TextField(
                                    controller: SendScreen.destinationWallet,
                                    decoration: InputDecoration(
                                        fillColor: Colors.transparent,
                                        hintText: 'inputAddressWith'.tr,
                                        suffixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(width: 8.0),
                                            InkWell(
                                              onTap: () { 
                                                try {
                                                Clipboard.getData(Clipboard.kTextPlain).then((value) => SendScreen.destinationWallet.text = value!.text!);
                                              } catch (_) {} 
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text("paste", style: TextStyle(color: Colors.blue)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        )),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: Theme.of(context).scaffoldBackgroundColor
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset("assets/blockchains/solana.svg", height: 25.0, width: 25.0),
                                            SizedBox(width: 8.0),
                                            Text("Solana")
                                          ],
                                        ),
                                      ),
                                      Text("Fee 0.000005 SOL", style: TextStyle(color: Theme.of(context).hintColor)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                     ],
                   ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: Text('${valueNumber ?? 0}', style: TextStyle(fontSize: 44.0, fontWeight: FontWeight.bold)),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text('Balance: ${widget.tokenBalance} ${widget.symbol}'),
                        ),
                      widget.quick == null ?  Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () => replaceWindow(context, QRScreen()),
                        child: SizedBox(
                          height: 35.0,
                          width: 35.0,
                          child: Icon(Iconsax.scan, color: Colors.amber),
                        )),
                    ) : Container(),
                      ],
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
                Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 250.0,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: () => tapNumber(number: "1"), icon: Text("1", style: TextStyle(fontSize: 21.0))),
                IconButton(onPressed: () => tapNumber(number: "2"), icon: Text("2", style: TextStyle(fontSize: 21.0))),
                IconButton(onPressed: () => tapNumber(number: "3"), icon: Text("3", style: TextStyle(fontSize: 21.0))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: () => tapNumber(number: "4"), icon: Text("4", style: TextStyle(fontSize: 21.0))),
                IconButton(onPressed: () => tapNumber(number: "5"), icon: Text("5", style: TextStyle(fontSize: 21.0))),
                IconButton(onPressed: () => tapNumber(number: "6"), icon: Text("6", style: TextStyle(fontSize: 21.0))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: () => tapNumber(number: "7"), icon: Text("7", style: TextStyle(fontSize: 21.0))),
                IconButton(onPressed: () => tapNumber(number: "8"), icon: Text("8", style: TextStyle(fontSize: 21.0))),
                IconButton(onPressed: () => tapNumber(number: "9"), icon: Text("9", style: TextStyle(fontSize: 21.0))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(onPressed: () => tapNumber(number: "."), icon: Text(".", style: TextStyle(fontSize: 21.0))),
                IconButton(onPressed: () => tapNumber(number: "0"), icon: Text("0", style: TextStyle(fontSize: 21.0))),
                IconButton(onPressed: () => tapNumber(number: "clear"), icon: Icon(Iconsax.arrow_left)),
              ],
            )
          ],
        ),
      ),
    ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                  child: SlideAction(
                    height: 75.0,
                    sliderRotate: false,
                    sliderButtonIcon: Icon(Icons.arrow_forward_ios_rounded),
                    borderRadius: 20.0,
                    innerColor: Theme.of(context).primaryColor,
                    outerColor: Colors.grey.withOpacity(0.2),
                    child: Text("swipeToSendText".tr, style: TextStyle(color: Theme.of(context).hintColor)),
                    animationDuration: Duration.zero,
                    submittedIcon: setStateSubmit(tx: tx),
                    onSubmit: () async {
                      if (valueNumber != null) {
                          tx = await _cubit.sendTokenTransaction(address: widget.quick != null ? widget.quick!['address'] : SendScreen.destinationWallet.text,
                          amount: double.parse(valueNumber), mintAddress: widget.address, symbol: widget.symbol);
                          setState(() {});
                        }
                        
                    },
                  ),
                ),
              ],
            )));
  }
}