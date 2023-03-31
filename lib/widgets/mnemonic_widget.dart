import 'dart:ui';

import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MnemonicWidget extends StatefulWidget {
  final String mnemonic;
  const MnemonicWidget({ Key? key, required this.mnemonic }) : super(key: key);

  @override
  _MnemonicWidgetState createState() => _MnemonicWidgetState();
}

class _MnemonicWidgetState extends State<MnemonicWidget> {

  bool isShow = false;


 List<String> getWidgetFromMnemonicList() {
    return widget.mnemonic.split(' ').toList();
  }


  @override
  void initState() {
    getWidgetFromMnemonicList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(16.0),
                    child: Stack(
                      children: [
                        Container(
                          height: 250.0,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Theme.of(context).hintColor.withOpacity(0.3),
                              width: 1.0
                            )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("1. ${getWidgetFromMnemonicList()[0]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("2. ${getWidgetFromMnemonicList()[1]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("3. ${getWidgetFromMnemonicList()[2]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("4. ${getWidgetFromMnemonicList()[3]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("5. ${getWidgetFromMnemonicList()[4]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("6. ${getWidgetFromMnemonicList()[5]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("7. ${getWidgetFromMnemonicList()[6]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("8. ${getWidgetFromMnemonicList()[7]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("9. ${getWidgetFromMnemonicList()[8]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("10. ${getWidgetFromMnemonicList()[9]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("11. ${getWidgetFromMnemonicList()[10]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 100.0,
                                    child: Text("12. ${getWidgetFromMnemonicList()[11]}"),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context).hintColor.withOpacity(0.3)
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        isShow ? SizedBox() : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: CustomInkWell(
                              onTap: () {
                                isShow = true;
                                setState(() {});
                              },
                              child: Container(
                                height: 250.0,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Iconsax.eye),
                                    SizedBox(height: 4.0),
                                    Text("Show")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
      );
  }
}