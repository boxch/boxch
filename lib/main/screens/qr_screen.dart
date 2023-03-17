import 'dart:io';
import 'package:boxch/main/screens/send_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get/get.dart';

class QRScreen extends StatefulWidget {
  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  
  var result;
  var controller;

   void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
                leading: IconButton(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
          icon: Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
            allowDuplicates: false,
            onDetect: (barcode, args) {
              if (barcode.rawValue == null) {
                debugPrint('Failed to scan Barcode');
              } else {
                final String code = barcode.rawValue!;
                SendScreen.destinationWallet.text = code;
                Navigator.pop(context);
              }
          }),
          ),
          Text('scanQrDestinationText'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          SizedBox(
            height: 16.0,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


