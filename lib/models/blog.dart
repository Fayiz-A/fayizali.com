import 'dart:core';

import 'package:flutter/material.dart';

class Blog {
  String article;
  String author;
  DateTime time;
  String headerImageUrl;
  String title;

  Blog({@required this.article, @required this.author, @required this.time, @required this.headerImageUrl, @required this.title});

  factory Blog.fromJson(Map<String, dynamic> data) {
    return Blog(
      title: data['title'],
      article: data['article'],
      time: data['time'].toDate(),
      author: data['author'],
      headerImageUrl: data['headerImageURL']
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'article': article,
      'headerImageUrl': headerImageUrl,
      'time': time,
      'author': author,
    };
  }

}