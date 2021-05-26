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

  Future<void> onInit() async {
    observableBlog.value = blog;
    if(blog == null) {
      observableBlog.value = await fetchArticle();
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
}
