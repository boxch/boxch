import 'package:boxch/utils/constants.dart';
import 'package:boxch/utils/show_toasts.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({ Key? key }) : super(key: key);

  final TextEditingController _controllerOldPassword = TextEditingController();
  final TextEditingController _controllerNewPassword = TextEditingController();

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
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            controller: _controllerOldPassword,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: InputDecoration(
                                hintText: 'Input old password',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                )),
                          ),
      ),
      SizedBox(height: 16.0),
      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextField(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            controller: _controllerNewPassword,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: InputDecoration(
                                hintText: 'Input new password',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                )),
                          ),
      ),
      SizedBox(height: 32.0),
                  Padding(
                    padding: EdgeInsets.all(32.0),
                    child: InkWell(
                      onTap: () {
                        if (Hive.box(boxPassword).get(boxPasswordKey) == _controllerOldPassword.text) {
                          Hive.box(boxPassword).put(boxPasswordKey, _controllerNewPassword.text);
                          okCopyToast(context, message: "Success");
                          Navigator.of(context).pop();
                        } else {
                          errorShowToast(context, message: "Invalid password");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text("Change", style: TextStyle(fontWeight: FontWeight.bold)),
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
      ])
    );
  }
}