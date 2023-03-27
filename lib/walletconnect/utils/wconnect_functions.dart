import 'package:boxch/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/sign_client_events.dart';

connectDappDialog(BuildContext context, {required SessionProposalEvent args}) => showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: getImageIcon(image: args.params.proposer.metadata.icons[0], size: 50.0),
                  ),
                  SizedBox(height: 16.0),
                  Text("${args.params.proposer.metadata.name} wants to connect to your wallet"),
                  SizedBox(height: 8.0),
                  Text(args.params.proposer.metadata.url, style: TextStyle(color: Theme.of(context).hintColor))
                ],
              ),
            ),
            SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: InkWell(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("Connect"),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.blue
                      ),
                    ),
                  ),
            )
          ],
        ),
      );
    });

signTransactionDialog(BuildContext context, {required dynamic par}) => showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(),
            SizedBox(
              child: Column(
                children: [
                  Flexible(
                    flex: 10,
                    child: Text(par.toString().substring(0, 100)))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context, false),
                    child: Container(
                      height: 50.0,
                      width: 120.0,
                      alignment: Alignment.center,
                      child: Text("Reject"),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      height: 50.0,
                      width: 150.0,
                      alignment: Alignment.center,
                      child: Text("Sign"),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.blue
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });