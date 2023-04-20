import 'package:flutter/material.dart';

class CircleInfoWidget extends StatelessWidget {
  final bool viewed;
  const CircleInfoWidget({super.key, required this.viewed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 55.0,
          width: 55.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: viewed ? [Colors.blueGrey.withOpacity(0.5), Colors.blueGrey.withOpacity(0.5)] : [Colors.blue.withOpacity(0.5), Colors.blue.withOpacity(0.5)])
          ),
        ),
        Container(
          height: 48.0,
          width: 48.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        Container(
          height: 42.0,
          width: 42.0,
          alignment: Alignment.center,
          child: Image.asset("assets/images/wcinfo.png"),
        ),
      ],
    );
  }
}
