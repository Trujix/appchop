import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';
import '../services/tool_service.dart';

abstract class GetInjection extends GetxController {
  final storage = Get.find<StorageService>();
  final firebase = Get.find<FirebaseService>();
  final tool = Get.find<ToolService>();
  final api = Get.find<ApiService>();
}