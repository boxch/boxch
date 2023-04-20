import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class SendSuccessWidget extends StatelessWidget {
  final String tx;
  const SendSuccessWidget({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
              color: Colors.grey[800]!.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.0)),
      child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 16.0),
              Icon(Iconsax.tick_circle,
                  color: Colors.greenAccent, size: 32.0),
              SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Confirmed', style: TextStyle(color: Theme.of(context).hintColor)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${(tx.length > 20) ? tx.substring(0, 20) : tx}...', style: TextStyle(color: Theme.of(context).cardColor) ),
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
    );
  }
}