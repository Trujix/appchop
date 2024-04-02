import 'package:get/get.dart';

import '../data/repositories/configuracion_repository.dart';
import '../data/repositories/login_repository.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';
import '../services/tool_service.dart';

abstract class GetInjection extends GetxController {
  final storage = Get.find<StorageService>();
  final firebase = Get.find<FirebaseService>();
  final tool = Get.find<ToolService>();
  final api = Get.find<ApiService>();

  final loginRepository = Get.find<LoginRepository>();
  final configuracionRepository = Get.find<ConfiguracionRepository>();
}