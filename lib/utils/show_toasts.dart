import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

okShowToast({required String tx}) {
  showToastWidget(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Container(
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 16.0),
              Icon(Icons.check_circle_outline,
                  color: Colors.greenAccent, size: 35.0),
              SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Confirmed', style: TextStyle(color: Colors.white)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${(tx.length > 20) ? tx.substring(0, 20) : tx}...'),
                      SizedBox(width: 8.0),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () async {
                              await launchUrl(
                                  Uri.parse("https://solscan.io/tx/$tx"));
                            },
                            child: Container(
                                child: Text('view',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold)))),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      duration: Duration(seconds: 10),
      handleTouch: true,
      dismissOtherToast: true,
      position: ToastPosition.bottom);
}

okCopyToast(BuildContext context, {String? message}) {
  showToastWidget(
      Container(
        height: 70.0,
        width: 65.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 10.0,
                  spreadRadius: 5.0)
            ],
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline_outlined,
                size: 32.0, color: Colors.green),
            Text(message ?? "copy",
                style: TextStyle(
                    color: Theme.of(context).hintColor, fontSize: 12.0)),
          ],
        ),
      ),
      duration: const Duration(seconds: 2),
      handleTouch: true,
      dismissOtherToast: true,
      position: ToastPosition.center);
}

errorShowToast(BuildContext context, {required String message}) {
  showToastWidget(
      Container(
        height: 70.0,
        width: 100.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.grey[800], borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.info, size: 32.0, color: Colors.red),
            Text(message,
                style: TextStyle(
                    color: Theme.of(context).hintColor, fontSize: 10.0)),
          ],
        ),
      ),
      duration: const Duration(seconds: 2),
      handleTouch: true,
      dismissOtherToast: true,
      position: ToastPosition.center);
}


processingShowToast({required status, required message}) {
  showToastWidget(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 64.0),
        child: Container(
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 16.0),
              SizedBox(
                  height: 25.0,
                  width: 25.0,
                  child: CircularProgressIndicator(color: Colors.grey)),
              SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    status,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(message, style: TextStyle(fontSize: 12.0), maxLines: 2)
                ],
              ),
            ],
          ),
        ),
      ),
      duration: Duration(minutes: 2),
      dismissOtherToast: true,
      position: ToastPosition.bottom);
}

warningShowToast(BuildContext context, {required message}) {
  showToastWidget(
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 64.0),
        child: Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 8.0),
              SizedBox(
                  height: 25.0,
                  width: 25.0,
                  child: Icon(Iconsax.info_circle, color: Colors.amber)),
              SizedBox(width: 16.0),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      duration: Duration(seconds: 3),
      dismissOtherToast: true,
      position: ToastPosition.bottom);
}
