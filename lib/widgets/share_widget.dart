import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';

class ShareWidget extends StatelessWidget {
  final Function() onTap;
  final String name;
  final String icon;
  const ShareWidget({super.key, required this.onTap, required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      child: Column(
                      children: [
                        Image.asset(icon, height: 30.0, width: 30.0),
                        SizedBox(height: 8.0),
                        Text("Twitter", style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12.0))
                      ],
                    ), 
      onTap: onTap);
  }
}