import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

replaceWindow(BuildContext context, window) => Navigator.push(context,
    MaterialPageRoute(fullscreenDialog: true, builder: (context) => window));


Widget getImageIcon({required String? image, required double size}) {
  if (image?.split('.').last == 'svg') {
    return SvgPicture.network(image!,
        width: size, height: size, fit: BoxFit.fill);
  } else if (image?.split('.').last == 'png' ||
      image?.split('.').last == 'jpg' ||
      image?.split('.').last == 'jpeg') {
    return Image.network(
      image!,
      width: size,
      height: size,
      fit: BoxFit.fill,
    );
  }
  return Container(
      height: size, width: size, alignment: Alignment.center, child: Text("?"));
}

class RunOnce {
  bool _hasRun = false;
  void call(void Function() function) {
    if (_hasRun) return;
    _hasRun = true;
    function();
  }
}
