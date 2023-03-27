import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  final String text;
  final Function() onTap;
  final IconData icon;
  final double? iconSize;
  MainMenu(
      {Key? key,
      required this.onTap,
      required this.text,
      required this.icon,
      this.iconSize})
      : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
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
            height: 65.0,
            width: 65.0,
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 79, 79, 83), width: 0.1
              ),
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(100.0)),
            padding: EdgeInsets.all(8.0),
            child: Icon(widget.icon,
                size: widget.iconSize ?? null,
                color: Theme.of(context).hintColor),
          ),
          SizedBox(height: 8.0),
          Text(
            widget.text,
            style:
                TextStyle(fontSize: 11.0, color: Theme.of(context).hintColor),
          )
        ],
      ),
    );
  }
}
