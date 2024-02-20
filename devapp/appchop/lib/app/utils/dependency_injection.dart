import 'package:get/get.dart';

import '../services/firebase_service.dart';

class DependencyInjection {
  static DependencyInjection dependencyInjection = DependencyInjection();

  static void init() {
    dependencyInjection._injectServices();
    dependencyInjection._injectDAL();
  }

  void _injectServices() {
    Get.put<FirebaseService>(FirebaseService());
  }

  void _injectDAL() {

  }
}