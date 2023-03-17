import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

replaceWindow(BuildContext context, window) =>
    Navigator.push(context, MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => window));


String userGreeting() {
  final int data = DateTime.now().hour;
  var greeting = "";
      if (data >= 4 && data < 10) {
        greeting = "goodMorning".tr;
      } else if (data >= 10 && data < 17) {
        greeting = "goodAfternoon".tr;
      } else if (data >= 17 && data < 22) {
        greeting = "goodEvening".tr;
      } else {
        greeting = "goodNight".tr;
      }
    return greeting;
}

Color setColorForSwapText(BuildContext context, {required num impct}) {
  var color = Theme.of(context).hintColor;
  if (impct >= 2 && impct < 5) {
    color = Colors.amber;
  } else if (impct >= 5) {
    color = Colors.red;
  }
  return color;
}

    Widget getImageIcon({required String? image, required double size}) {
       if (image?.split('.').last == 'svg') {
        return SvgPicture.network(
                    image!,
                    width: size, height: size, fit: BoxFit.fill); 
       } else if (image?.split('.').last == 'png' || image?.split('.').last == 'jpg' || image?.split('.').last == 'jpeg') {
         return Image.network(
                      image!,
                      width: size,
                      height: size,
                      fit: BoxFit.fill,
          );
       } 
       return Container(height: size, width: size, alignment: Alignment.center, child: Text("?"));
      }


class StatusType {
  static const success = "Success";
  static const error = "Error";
}


