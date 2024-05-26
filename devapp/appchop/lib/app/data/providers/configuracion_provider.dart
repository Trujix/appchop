import 'dart:convert';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/literals.dart';
import '../models/configuracion/imagen_logo.dart';
import '../models/local_storage/configuracion.dart';

class ConfiguracionProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<bool?> desvincularDispositivoAsync(String idUsuario, String usuario) async {
    try {
      var result = await _api.get(
        "api/configuracion/desvincularDispositivo/$idUsuario/$usuario",
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }

  Future<Configuracion?> obtenerConfiguracionUsuarioAsync(String idUsuario) async {
    try {
      var result = await _api.get(
        "api/configuracion/obtenerConfiguracionUsuario/$idUsuario",
      );
      return Configuracion.fromApi(jsonDecode(result!));
    } catch(e) {
      return null;
    }
  }

  Future<bool?> guardarImagenLogoAsync(ImagenLogo imagenLogo) async {
    try {
      var result = await _api.post(
        "api/configuracion/guardarImagenLogo",
        imagenLogo,
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }
}