import 'package:boxch/utils/functions.dart';
import 'package:flutter/material.dart';

class TokenListTile extends StatelessWidget {
  final String? image;
  final String title;
  final String trailingTitle;
  final String trailingSubtitle;
  final onPressed;
  final Color backgroundColor;

  const TokenListTile(
      {required this.image,
      required this.title,
      required this.trailingTitle,
      required this.trailingSubtitle,
      required this.onPressed,
      required this.backgroundColor})
      : super();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        highlightColor: Theme.of(context).scaffoldBackgroundColor,
        overlayColor: MaterialStateProperty.all(
            Theme.of(context).scaffoldBackgroundColor),
        onTap: onPressed,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              //border: Border.all(color: Colors.grey, width: 0.1),
                              color: Theme.of(context).primaryColor
                            ),
                            padding: EdgeInsets.all(4.0),
                            child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            child: getImageIcon(image: image, size: 30.0),
                          ),
                          ),
                          SizedBox(width: 12.0),
                          Text(title, style: TextStyle(fontSize: 18.0, color: Theme.of(context).cardColor)),
                        ],
                      ),
                    ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(trailingTitle, style: TextStyle(fontSize: 16.0, color: Theme.of(context).cardColor)),
                    Text(trailingSubtitle,
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Theme.of(context).cardColor
                            )),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
