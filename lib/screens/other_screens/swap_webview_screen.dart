import 'dart:convert';

import 'package:boxch/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:solana/base58.dart';
import 'package:solana/encoder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SwapWebviewScreen extends StatefulWidget {
  SwapWebviewScreen({Key? key}) : super(key: key);

  @override
  State<SwapWebviewScreen> createState() => _SwapWebviewScreenState();
}

class _SwapWebviewScreenState extends State<SwapWebviewScreen> {
  int loading = 0;

  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          alignment: Alignment.bottomCenter,
          color: Theme.of(context).scaffoldBackgroundColor,
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(Iconsax.arrow_left, color: Theme.of(context).hintColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(Icons.close_rounded, color: Theme.of(context).hintColor)),
            ],
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          WebView(
            initialCookies: [],
            initialUrl: "https://jup.ag",
            javascriptChannels: Set.from([
              JavascriptChannel(
                name: 'slopeApp',
                onMessageReceived: (JavascriptMessage message) async {

                Map<String, dynamic> decodeJson = json.decode(message.message);
                print(decodeJson);

                    if (decodeJson.values.first.toString() == "connect") {

                    await _controller.runJavascript('window.SolflareApp(JSON.stringify({id: ${decodeJson.values.first},method: "connected",params: {publicKey: "${wallet.address}",autoApprove: true, autoSettle: true}}))');                

                  } else if (decodeJson.values.first.toString() == "signTransaction") {

                    var message = decodeJson['params']['message'];
                    var signature = await wallet.sign(base58decode(message));
                    await _controller.runJavascript('window.postMessage(JSON.stringify({id: 1,result: {signature: "${signature.toBase58()}",publicKey: "${wallet.address}"}}))');


                  } else if (decodeJson.values.first.toString() == "signAllTransactions") {
                    List list = <String>[];
                    List messages = decodeJson['params']['messages'];
                    for (var message in messages) {
                      var signature = await wallet.sign(base58decode(message));
                      list.add('"${signature.toBase58()}"');
                    }
                    await _controller.runJavascript('window.postMessage(JSON.stringify({result: {signatures: $list,publicKey: "${wallet.address}"}}))');

                   } 
              }),
        ]),
        onPageFinished: (url) async {
          try {
            await _controller.runJavascript(
              'window.Slope.connect()');

          } catch (_) {}
         },
         onWebViewCreated: (controller) async {
            _controller = controller;
          },
            onProgress: (state) {
              setState(() {
                loading = state;
              });
            },
            javascriptMode: JavascriptMode.unrestricted,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            navigationDelegate: (NavigationRequest request) async {
              if (request.url.contains("tg:")) {
                launchUrl(Uri.parse(request.url));
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            },
          ),
        (loading != 100) ? Container(
            height: 25.0,
            width: 25.0,
            child: CircularProgressIndicator(
                color:Colors.grey),
          ) : SizedBox()
        ],
      ),
    );
  }
}