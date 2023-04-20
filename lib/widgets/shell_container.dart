import 'package:flutter/material.dart';

class ShellContainer extends StatelessWidget {
  final Widget child;
  const ShellContainer({ Key? key, required this.child }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.0,
      alignment: Alignment.center,
      child: child);
  }
}