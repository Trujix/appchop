import 'package:get/get.dart';

import '../providers/configuracion_provider.dart';

class ConfiguracionRepository {
  Future<bool?> desvincularDispositivoAsync(String idUsuario) async {
    return await Get.find<ConfiguracionProvider>().desvincularDispositivoAsync(idUsuario);
  }
}