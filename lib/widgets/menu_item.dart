import 'package:flutter/material.dart';

class MenuItem extends StatefulWidget {
  final String text;
  final Function() onTap;
  final icon;
  MenuItem(
      {Key? key, required this.onTap, required this.text, required this.icon})
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
      child: Column(
        children: [
          Container(
            height: 55.0,
            width: 55.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 5.0,
                      spreadRadius: 1.0)
                ]),
            padding: EdgeInsets.all(12.0),
            child: widget.icon,
          ),
          Text(widget.text,
                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 9.0))
        ],
      ),
    );
  }
}
