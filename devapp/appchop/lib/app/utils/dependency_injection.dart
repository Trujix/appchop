import 'package:get/get.dart';

import '../services/firebase_service.dart';
import '../services/storage_service.dart';
import '../services/tool_service.dart';

class DependencyInjection {
  static DependencyInjection dependencyInjection = DependencyInjection();

  static void init() {
    dependencyInjection._injectServices();
    dependencyInjection._injectDAL();
  }

  void _injectServices() {
    Get.put<StorageService>(StorageService());
    Get.put<FirebaseService>(FirebaseService());
    Get.put<ToolService>(ToolService());
  }

  void _injectDAL() {

  }
}