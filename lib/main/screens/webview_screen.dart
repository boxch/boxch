import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  final String urlLink;
  WebviewScreen({Key? key, required this.urlLink}) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {

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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(Iconsax.arrow_left, color: Theme.of(context).hintColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          WebView(
            initialCookies: [],
            initialUrl: widget.urlLink.toString(),
            javascriptMode: JavascriptMode.unrestricted,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            navigationDelegate: (NavigationRequest request) async {
              print(request.url);
              if (request.url.contains("tg:")) {
                launchUrl(Uri.parse(request.url));
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            },
          ),
        SizedBox()
        ],
      ),
    );
  }
}
