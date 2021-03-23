import 'dart:async';

import 'package:flutter/material.dart';

enum ImageType {asset, network}

class ImageWithPlaceholderBeforeLoadWidget extends StatefulWidget {

  final String imagePath;
  final double width;
  final double height;
  final ImageType imageType;

  ImageWithPlaceholderBeforeLoadWidget({this.width, this.height, @required this.imagePath, this.imageType = ImageType.network});

  @override
  _ImageWithPlaceholderBeforeLoadWidgetState createState() => _ImageWithPlaceholderBeforeLoadWidgetState();
}

class _ImageWithPlaceholderBeforeLoadWidgetState extends State<ImageWithPlaceholderBeforeLoadWidget> {

  Future<Image> imgFuture;

  @override
  void initState() {
    super.initState();

    imgFuture = Future<Image>(() async {
      switch(widget.imageType) {
        case ImageType.network:
          return Image.network(widget.imagePath, width: widget.width, height: widget.height,);
          break;
        case ImageType.asset:
          return Image.asset(widget.imagePath, width: widget.width, height: widget.height,);
        default:
          return Image.network(widget.imagePath, width: widget.width, height: widget.height,);
      }
    });
        // ..add(Image.network(widget.imageURL, width: widget.width ?? null, height: widget.height ?? null,));
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Image>(
        future: imgFuture,
        builder: (context, future) {
          if(future.connectionState == ConnectionState.waiting) {
            return Container(width: widget.width, height: widget.height,);
          } else if(future.connectionState == ConnectionState.done) {
            return future.data;
          } else {
            return Text('Oops! An error occurred while fetching the image', style: TextStyle(color: Colors.red),);
          }
        }
    );
  }
}
