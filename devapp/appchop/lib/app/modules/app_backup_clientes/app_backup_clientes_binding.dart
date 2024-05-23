import 'package:get/get.dart';

import 'app_backup_clientes_controller.dart';

class AppBackupClientesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppBackupClientesController());
  }
}