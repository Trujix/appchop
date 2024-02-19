import 'package:get/get.dart';

import '../services/firebase_service.dart';

class DependencyInjection {
  static void init() {
    Get.put<FirebaseService>(FirebaseService());
  }
}