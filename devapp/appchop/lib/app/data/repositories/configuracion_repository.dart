import 'package:get/get.dart';

import '../models/local_storage/configuracion.dart';
import '../providers/configuracion_provider.dart';

class ConfiguracionRepository {
  Future<bool?> desvincularDispositivoAsync(String idUsuario, String usuario) async {
    return await Get.find<ConfiguracionProvider>().desvincularDispositivoAsync(idUsuario, usuario);
  }

  Future<Configuracion?> obtenerConfiguracionUsuarioAsync(String idUsuario) async {
    return await Get.find<ConfiguracionProvider>().obtenerConfiguracionUsuarioAsync(idUsuario);
  }
}