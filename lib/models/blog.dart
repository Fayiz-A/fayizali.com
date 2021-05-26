import 'dart:core';

import 'package:flutter/material.dart';

class Blog {
  String article;
  String author;
  DateTime time;
  String headerImageUrl;
  String title;
  String docId;

  Blog({@required this.article, @required this.author, @required this.time, @required this.headerImageUrl, @required this.title, @required this.docId});

  factory Blog.fromJson(Map<String, dynamic> data) {
    return Blog(
      title: data['title'],
      article: data['article'],
      time: data['time'].toDate(),
      author: data['author'],
      headerImageUrl: data['headerImageURL'],
      docId: data['docId']
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'article': article,
      'headerImageUrl': headerImageUrl,
      'time': time,
      'author': author,
      'docId': docId,
    };
  }

}