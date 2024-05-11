import 'package:get/get.dart';

import '../../services/api_service.dart';

class UsuariosProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<String?> verificarEstatusAsync(String idUsuario, String perfil) async {
    try {
      var result = await _api.get(
        "api/usuarios/verificarEstatus/$idUsuario/$perfil"
      );
      return result;
    } catch(e) {
      return null;
    }
  }
}