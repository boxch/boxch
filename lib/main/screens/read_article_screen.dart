import 'package:boxch/models/articles.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ReadArticleScreen extends StatelessWidget {
  final Article article;
  const ReadArticleScreen({ Key? key, required this.article }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                leading: IconButton(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
          icon: Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.network(article.imageUrl),
            ),
            SizedBox(height: 16.0),
            Text(article.title, style: TextStyle(fontSize: 21.0, color: Theme.of(context).cardColor)),
            SizedBox(height: 8.0),
            Text(article.subtitle, style: TextStyle(color: Theme.of(context).cardColor, height: 1.5))
          ],
        ),
      ),
    );
  }
}