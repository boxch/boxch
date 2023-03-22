import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  final String text;
  final Function() onTap;
  final IconData icon;
  final double? iconSize;
  MainMenu(
      {Key? key, required this.onTap, required this.text, required this.icon, this.iconSize})
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
      child: Container(
        height: 120.0,
        width: 100.0,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              color: Colors.black,
              width: 0.5
            )),
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 80.0,
              width: 80.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: bezelState ? Colors.grey : Colors.black, width: 0.5),
              ),
              child: Icon(widget.icon, size: widget.iconSize ?? null, color: Theme.of(context).hintColor),
            ),
            SizedBox(height: 8.0),
            Text(widget.text,
                style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12.0))
          ],
        ),
      ),
    );
  }
}
