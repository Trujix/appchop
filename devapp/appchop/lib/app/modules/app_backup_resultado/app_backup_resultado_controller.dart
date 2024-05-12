import 'package:get/get.dart';

import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';

class AppBackupResultadoController extends GetInjection {
  bool respaldoTerminado = false;
  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    try {
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      await tool.wait(1);
      var appBackupData = await appBackupRepository.descargarAsync(localStorage.idUsuario!);
      await storage.backup(appBackupData!);
      await tool.wait(1);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar realizar respaldo inicial", 3);
    } finally {
      respaldoTerminado = true;
      update();
    }
  }

  void salir() {
    Get.back();
  }
}