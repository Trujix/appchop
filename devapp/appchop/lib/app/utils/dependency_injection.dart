import 'package:get/get.dart';

import '../services/api_service.dart';
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
    Get.put<ToolService>(ToolService());
    Get.put<StorageService>(StorageService());
    Get.put<FirebaseService>(FirebaseService());
    Get.put<ApiService>(ApiService());
  }

  void _injectDAL() {

  }
}