import 'package:get/get.dart';

import '../models/cobradores/alta_cobrador.dart';
import '../providers/cobradores_provider.dart';

class CobradoresRepository {
  Future<bool?> verificarCobradorAsync(String idUsuario, String usuario) async {
    return await Get.find<CobradoresProvider>().verificarCobradorAsync(idUsuario, usuario);
  }

  Future<bool?> altaCobradorAsync(AltaCobrador cobrador) async {
    return await Get.find<CobradoresProvider>().altaCobradorAsync(cobrador);
  }
}