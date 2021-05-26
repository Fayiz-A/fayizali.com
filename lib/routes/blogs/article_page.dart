import 'package:fayizali/controllers/article_page_controller.dart';
import 'package:fayizali/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class ArticlePage extends StatelessWidget {
  final String docId;
  final Blog blog;

  ArticlePage({@required this.docId, this.blog});

  @override
  Widget build(BuildContext context) {
    final ArticlePageController articlePageController = Get.put(
        ArticlePageController(blog: blog, docId: docId),
        tag: 'article$docId');

    return Obx(
          () {
        if (articlePageController.observableBlog.value != null) {
          Blog _blog = articlePageController.observableBlog.value;

          return Scaffold(
            body: Content(blog: _blog),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class Content extends StatelessWidget {
  final Blog blog;

  Content({@required this.blog}) : assert(blog != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scrollbar(
        isAlwaysShown: true,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2, ),
          children: [
            Header(
              blog: blog,
            ),
            HeaderImage(
              blog: blog,
            ),
            Body(
              blog: blog,
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Blog blog;

  Header({@required this.blog}) : assert(blog != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(blog.title, style: Theme.of(context).textTheme.headline2,),
        Align(
          alignment: Alignment.centerLeft,
          child: AuthorAndTime(
            blog: blog,
          ),
        ),
      ],
    );
  }
}

class AuthorAndTime extends StatelessWidget {
  final Blog blog;

  AuthorAndTime({@required this.blog}) : assert(blog != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          child: Icon(Icons.person),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.0),
                  child: Text(blog.author)
              ),
              Text(
                  '${blog.time.day}/${blog.time.month}/${blog.time.year} ${blog.time.hour}:${blog.time.minute.toString().length == 1 ? '0' : ''}${blog.time.minute}')
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderImage extends StatelessWidget {
  final Blog blog;

  HeaderImage({@required this.blog}) : assert(blog != null);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'articleHeaderImage', child: Image.network(blog.headerImageUrl));
  }
}

class Body extends StatelessWidget {
  final Blog blog;

  Body({@required this.blog}) : assert(blog != null);

  @override
  Widget build(BuildContext context) {
    debugPrint(blog.article);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: MarkdownBody(
        selectable: true,
        data: blog.article.replaceAll('  ', '\n'),
      ),
    );
  }
}
