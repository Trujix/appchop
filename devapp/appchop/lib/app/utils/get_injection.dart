import 'package:get/get.dart';

import '../services/firebase_service.dart';
import '../services/storage_service.dart';
import '../services/tool_service.dart';

abstract class GetInjection extends GetxController {
  final storageService = Get.find<StorageService>();
  final firebaseService = Get.find<FirebaseService>();
  final tool = Get.find<ToolService>();
}