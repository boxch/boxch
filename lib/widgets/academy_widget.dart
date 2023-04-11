import 'package:boxch/models/articles.dart';
import 'package:boxch/widgets/custom_inkwell.dart';
import 'package:flutter/material.dart';

class AcademyWidget extends StatelessWidget {
  final Article article;
  final Function() onTap;
  const AcademyWidget({ Key? key, required this.article, required this.onTap }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomInkWell(
        onTap: onTap,
        child: Container(
          height: 110.0,
          width: 160.0,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  height: 76.0,
                  width: 140.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: Image.network(article.imageUrl),
                ),
              ),
              Text("What is non-custodial wallet?", style: TextStyle(fontSize: 10.0, color: Theme.of(context).cardColor)),
            ],
          ),
        ),
      ),
    );
  }
}