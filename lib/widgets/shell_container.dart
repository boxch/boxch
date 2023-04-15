import 'package:flutter/material.dart';

class ShellContainer extends StatelessWidget {
  final Widget child;
  const ShellContainer({ Key? key, required this.child }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                height: 42.0,
                width: 42.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor
                ),
                alignment: Alignment.center,
                child: child);
  }
}