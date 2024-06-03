import 'dart:convert';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/literals.dart';
import '../models/login/login_data.dart';
import '../models/login/login_form.dart';

class LoginProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<LoginData?> iniciarSesionAsync(LoginForm form) async {
    try {
      var result = await _api.post(
        "api/login/iniciarSesion",
        form,
      );
      return LoginData.fromApi(jsonDecode(result!));
    } catch(e) {
      return null;
    }
  }

  Future<String?> recuperarPasswordAsync(LoginForm form) async {
    try {
      var result = await _api.post(
        "api/login/recuperarPassword",
        form,
      );
      return result;
    } catch(e) {
      return null;
    }
  }

  Future<bool?> actualizarPasswordAsync(LoginForm form) async {
    try {
      var result = await _api.post(
        "api/login/actualizarPassword",
        form,
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }

  Future<bool?> actualizarUsuarioAsync(LoginForm form) async {
    try {
      var result = await _api.post(
        "api/login/actualizarUsuario",
        form,
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }

  Future<bool?> aceptarTerminosCondicionesAsync(LoginForm form) async {
    try {
      var result = await _api.post(
        "api/login/acpetaTerminosCondiciones",
        form,
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }
}