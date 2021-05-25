import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class FirebaseController extends GetxController {

  @override
  Future<void> onInit() async {
    await init();
    super.onInit();
  }

  Future<void> init() async {
    await Firebase.initializeApp();
  }
}