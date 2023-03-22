import 'package:flutter/material.dart';

class MenuItem extends StatefulWidget {
  final String text;
  final Function() onTap;
  final icon;
  final double? iconSize;
  MenuItem(
      {Key? key, required this.onTap, required this.text, required this.icon, this.iconSize})
      : super(key: key);

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool bezelState = false;

  // clickEffect() async {
  //   bezelState = true;
  //       setState(() {});
  //       await Future.delayed(Duration(milliseconds: 500));
  //       bezelState = false;
  //       setState(() {});
  // }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.onTap,
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
            color: Theme.of(context).hintColor.withOpacity(0.3), width: 1.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 5.0,
                  spreadRadius: 1.0)
            ]),
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 4.0),
            widget.icon,
            Text(widget.text,
                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 9.0))
          ],
        ),
      ),
    );
  }
}
