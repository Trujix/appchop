import 'package:get/get.dart';

import '../providers/usuarios_provider.dart';

class UsuariosRepository {
  Future<String?> validarUsuarioAsync(String idUsuario, String usuario) async {
    return await Get.find<UsuariosProvider>().validarUsuarioAsync(idUsuario, usuario);
  }

  Future<String?> verificarEstatusAsync(String idUsuario, String usuario) async {
    return await Get.find<UsuariosProvider>().verificarEstatusAsync(idUsuario, usuario);
  }
}