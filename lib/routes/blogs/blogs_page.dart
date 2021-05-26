import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fayizali/controllers/blogs_page_controller.dart';
import 'package:fayizali/controllers/firebase_controllers/firestore_controller.dart';
import 'package:fayizali/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogsPage extends StatelessWidget {

  final BlogsPageController blogsPageController = Get.put(BlogsPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs'),
      ),
      body: Obx(
        () {
          if(blogsPageController.blogList.length > 0) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: Get.width * 0.3,
                ),
                itemCount: blogsPageController.blogList.length,
                itemBuilder: (BuildContext context, int index) {
                  List<Blog> bloglist = blogsPageController.blogList;
                  return BlogCard(blog: bloglist[index], index: index);
                }
            );
          } else {
            return Center(
                child: CircularProgressIndicator()
            );
          }
        },
      )
    );
  }
}

class BlogCard extends StatelessWidget {

  final Blog blog;
  final int index;

  BlogCard({@required this.blog, @required this.index});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, 'blogs/${blog.docId}', arguments: {'article': blog}),
        child: Card(
          elevation: 20.0,
          child: Column(
            children: [
              Hero(
                  tag: 'articleHeaderImage',
                  child: Image.network(blog.headerImageUrl)
              ),
              Align(
                alignment: Alignment.topLeft,
                  child: Text(blog.title)
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('${blog.time.day}/${blog.time.month}/${blog.time.year} ${blog.time.hour}:${blog.time.minute.toString().length == 1 ? '0':''}${blog.time.minute}'),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(blog.author),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
