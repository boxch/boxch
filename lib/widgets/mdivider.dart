import 'package:flutter/material.dart';

class Mdivider extends StatelessWidget {
  const Mdivider({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Divider());
  }
}