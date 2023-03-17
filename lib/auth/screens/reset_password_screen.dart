import 'package:boxch/utils/constants.dart';
import 'package:boxch/utils/show_toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({ Key? key }) : super(key: key);

  final TextEditingController _controllerMnemonic = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        child: TextFormField(
                          controller: _controllerMnemonic,
                          minLines: 4,
                          maxLines: 5,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Colors.grey.withOpacity(0.4))
                            ),
                            suffixIcon: TextButton(
                              child: Text(
                                'pasteText'.tr,
                                style: TextStyle(fontSize: 20.0, color: Colors.blue),
                              ),
                              onPressed: () {
                                Clipboard.getData(Clipboard.kTextPlain).then(
                                    (value) =>
                                        _controllerMnemonic.text = value!.text!);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 32.0),
                  Padding(
                    padding: EdgeInsets.all(32.0),
                    child: InkWell(
                      onTap: () async {
                        if (Hive.box(walletBox).get(boxCurrentWalletKey).secretKey == _controllerMnemonic.text) {
                           var boxWallet = Hive.box(walletBox);
                            final box = Hive.box(boxPassword);
                            await boxWallet.deleteFromDisk();
                            await box.deleteFromDisk();
                            SystemNavigator.pop();
                        } else {
                          errorShowToast(context, message: "Invalid seed");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text("Reset", style: TextStyle(fontWeight: FontWeight.bold)),
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
      ])
    );
  }
}