import 'dart:convert';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/literals.dart';
import '../models/cobradores/alta_cobrador.dart';
import '../models/login/login_data.dart';

class CobradoresProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<bool?> verificarCobradorAsync(String idUsuario, String usuario) async {
    try {
      var result = await _api.get(
        "api/cobradores/verificarCobrador/$idUsuario/$usuario",
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }

  Future<bool?> altaCobradorAsync(AltaCobrador cobrador) async {
    try {
      var result = await _api.post(
        "api/cobradores/altaCobrador",
        cobrador
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }

  Future<bool?> actualizarPasswordAsync(AltaCobrador cobrador) async {
    try {
      var result = await _api.post(
        "api/cobradores/actualizarPassword",
        cobrador
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }

  Future<LoginData?> consultarCobradorInfoAsync(String idUsuario, String usuario) async {
    try {
      var result = await _api.get(
        "api/cobradores/consultarCobradorInfo/$idUsuario/$usuario"
      );
      return LoginData.fromApi(jsonDecode(result!));
    } catch(e) {
      return null;
    }
  }

  Future<bool?> actualizarEstatusAsync(AltaCobrador cobrador) async {
    try {
      var result = await _api.post(
        "api/cobradores/actualizarEstatus",
        cobrador
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }
}