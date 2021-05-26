import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {

  final String title;
  final String article;

  ArticlePage({@required this.title, this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Container(
        child: Column(
          children: [
            Text(title),
            Text(article),
          ],
        ),
      ),
    );
  }
}
