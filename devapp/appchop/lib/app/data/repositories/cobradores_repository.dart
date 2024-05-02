import 'package:get/get.dart';

import '../models/cobradores/alta_cobrador.dart';
import '../models/login/login_data.dart';
import '../providers/cobradores_provider.dart';

class CobradoresRepository {
  Future<bool?> verificarCobradorAsync(String idUsuario, String usuario) async {
    return await Get.find<CobradoresProvider>().verificarCobradorAsync(idUsuario, usuario);
  }

  Future<bool?> altaCobradorAsync(AltaCobrador cobrador) async {
    return await Get.find<CobradoresProvider>().altaCobradorAsync(cobrador);
  }

  Future<bool?> actualizarPasswordAsync(AltaCobrador cobrador) async {
    return await Get.find<CobradoresProvider>().actualizarPasswordAsync(cobrador);
  }

  Future<LoginData?> consultarCobradorInfoAsync(String idUsuario, String usuario) async {
    return await Get.find<CobradoresProvider>().consultarCobradorInfoAsync(idUsuario, usuario);
  }
}