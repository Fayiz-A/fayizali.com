import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreController extends GetxController {
  FirebaseFirestore firestore;
  CollectionReference collectionRef;

  @override
  void onInit() {
    init();
    super.onInit();
  }
  void init() async {
    firestore = FirebaseFirestore.instance;
  }

  void setCollectionReference(String ref) {
    collectionRef = FirebaseFirestore.instance.collection(ref);
  }

  dynamic getData({String collection, String docId}) async {
    assert(collectionRef != null);

    CollectionReference _collectionRef;

    if(collection != null)
      _collectionRef = FirebaseFirestore.instance.collection(collection);
     else
      _collectionRef = collectionRef;

    var snapshot;


    if(docId == null)
      snapshot = await _collectionRef.get();
    else
      snapshot = await _collectionRef.doc(docId).get();

    return snapshot;
  }

}