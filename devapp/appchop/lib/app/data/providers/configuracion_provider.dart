import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/literals.dart';

class ConfiguracionProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<bool?> desvincularDispositivoAsync(String idUsuario) async {
    try {
      var result = await _api.get(
        "api/configuracion/desvincularDispositivo/$idUsuario",
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }
}