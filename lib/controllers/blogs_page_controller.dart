import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fayizali/models/blog.dart';
import 'package:get/get.dart';

import 'firebase_controllers/firestore_controller.dart';

class BlogsPageController extends GetxController {
  RxList<Blog> blogList = <Blog>[].obs;

  FirestoreController firestoreController;

  @override
  Future<void> onInit() async {
    firestoreController = Get.put(FirestoreController(), tag: 'blog');
    firestoreController.setCollectionReference('blogs');
    await fetchArticles();

    super.onInit();
  }

  Future<void> fetchArticles() async {
    QuerySnapshot blogsSnapshot = await firestoreController.getData();
    if(blogsSnapshot != null) {
      List<Blog> _blogList = [];

      blogsSnapshot.docs.forEach((doc) {
         if(doc != null) {
           Map<String, dynamic> data = doc.data();
           data['docId'] = doc.id;
           Blog blog = Blog.fromJson(data);

           _blogList.add(blog);
         }
      });

      blogList.value = _blogList;
    }
  }

}