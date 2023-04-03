import 'package:flutter/material.dart';

class AcademyWidget extends StatelessWidget {
  final String imageUrl;
  const AcademyWidget({ Key? key, required this.imageUrl }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.0,
      width: 160.0,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Container(
              height: 76.0,
              width: 140.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: Image.network(imageUrl),
            ),
          ),
          Text("What is non-custodial wallet?", style: TextStyle(fontSize: 10.0)),
          Text("4 min read", style: TextStyle(fontSize: 7.0, color: Theme.of(context).hintColor)),
        ],
      ),
    );
  }
}