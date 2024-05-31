import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/literals.dart';

class UsuariosProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<String?> validarUsuarioAsync(String idUsuario, String usuario) async {
    try {
      var result = await _api.get(
        "api/usuarios/validarUsuario/$idUsuario/$usuario"
      );
      print(result);
      return result;
    } catch(e) {
      return null;
    }
  }

  Future<String?> verificarEstatusAsync(String idUsuario, String usuario) async {
    try {
      var result = await _api.get(
        "api/usuarios/verificarEstatus/$idUsuario/$usuario"
      );
      return result;
    } catch(e) {
      return null;
    }
  }

  Future<bool?> eliminarUsuarioAccionAsync(String idUsuario, String usuario) async {
    try {
      var result = await _api.get(
        "api/usuarios/eliminarUsuarioAccion/$idUsuario/$usuario"
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }
}