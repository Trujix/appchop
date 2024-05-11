import 'package:get/get.dart';

import '../providers/usuarios_provider.dart';

class UsuariosRepository {
  Future<String?> verificarEstatusAsync(String idUsuario, String perfil) async {
    return await Get.find<UsuariosProvider>().verificarEstatusAsync(idUsuario, perfil);
  }
}