import 'package:fayizali/controllers/blogs_page_controller.dart';
import 'package:fayizali/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class BlogsPage extends StatelessWidget {
  final BlogsPageController blogsPageController =
      Get.put(BlogsPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Blogs'),
        ),
        body: Obx(
          () {
            if (blogsPageController.blogList.length > 0) {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: Get.width * 0.3,
                  ),
                  itemCount: blogsPageController.blogList.length,
                  itemBuilder: (BuildContext context, int index) {
                    List<Blog> bloglist = blogsPageController.blogList;
                    return BlogCard(blog: bloglist[index], index: index);
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

class BlogCard extends StatefulWidget {
  final Blog blog;
  final int index;

  BlogCard({@required this.blog, @required this.index});

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> doorAnimation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    doorAnimation = Tween<double>(
      begin: 0.0,
      end: math.pi / 2,
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.linear));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: doorAnimation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(2, 3, 0.001)
            ..rotateY(doorAnimation.value),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        child: InkWell(
          onTap: () => animationController.forward().then(
                (value) => Navigator.pushNamed(
                    context, 'blogs/${widget.blog.docId}',
                    arguments: {'article': widget.blog}),
              ),
          child: Card(
            elevation: 20.0,
            child: Column(
              children: [
                Hero(
                    tag: 'articleHeaderImage',
                    child: Image.network(widget.blog.headerImageUrl)),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(widget.blog.title)),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                          '${widget.blog.time.day}/${widget.blog.time.month}/${widget.blog.time.year} ${widget.blog.time.hour}:${widget.blog.time.minute.toString().length == 1 ? '0' : ''}${widget.blog.time.minute}'),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(widget.blog.author),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
