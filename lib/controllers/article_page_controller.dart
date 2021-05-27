import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fayizali/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_controllers/firestore_controller.dart';

class ArticlePageController extends GetxController {
  Blog blog;
  String docId;

  ArticlePageController({this.blog, @required this.docId}):assert(docId != null);

  Rx<Blog> observableBlog = Rx(null);

  FirestoreController firestoreController;

  Rx<ScrollPosition> _scrollPosition = Rx(null);
  Rx<double> scrollPercent = 0.0.obs;

  Future<void> onInit() async {
    observableBlog.value = blog;
    if(blog == null) {
      Blog _blog = await fetchArticle();
      _blog.docId = docId;
      observableBlog.value = _blog;
    }
    super.onInit();
  }

  Future<Blog> fetchArticle() async {
    firestoreController = Get.put(FirestoreController(), tag: 'article$docId');
    firestoreController.setCollectionReference('blogs');

    DocumentSnapshot blogSnapshot =
        await firestoreController.getData(docId: docId);

    if (blogSnapshot != null) {
      Blog _blog = Blog.fromJson(blogSnapshot.data());
      return _blog;
    }
    return null;
  }

  void setScrollPosition(ScrollPosition pos) {
    _scrollPosition.value = pos;
    scrollPercent.value = _mapFromOneRangeToAnother(pos.pixels, pos.minScrollExtent, pos.maxScrollExtent, 0.0, 1.0);
    update(['article$docId']);
  }

  double _mapFromOneRangeToAnother(double value, double oldMin, double oldMax, double newMin, double newMax) {
    double newValue = (((value - oldMin) * (newMax - newMin)) / (oldMax - oldMin)) + newMin;
    return newValue;
  }
}
