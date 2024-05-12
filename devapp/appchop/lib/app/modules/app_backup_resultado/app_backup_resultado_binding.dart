import 'package:get/get.dart';

import 'app_backup_resultado_controller.dart';

class AppBackupResultadoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppBackupResultadoController());
  }
}