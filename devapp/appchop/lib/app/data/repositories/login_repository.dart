import 'package:get/get.dart';

import '../models/login/login_data.dart';
import '../models/login/login_form.dart';
import '../providers/login_provider.dart';

class LoginRepository {
  Future<LoginData?> iniciarSesionAsync(LoginForm form) async {
    return await Get.find<LoginProvider>().iniciarSesionAsync(form);
  }

  Future<String?> recuperarPasswordAsync(LoginForm form) async {
    return await Get.find<LoginProvider>().recuperarPasswordAsync(form);
  }

  Future<bool?> actualizarPasswordAsync(LoginForm form) async {
    return await Get.find<LoginProvider>().actualizarPasswordAsync(form);
  }

  Future<bool?> actualizarUsuarioAsync(LoginForm form) async {
    return await Get.find<LoginProvider>().actualizarUsuarioAsync(form);
  }

  Future<bool?> aceptarTerminosCondicionesAsync(LoginForm form) async {
    return await Get.find<LoginProvider>().aceptarTerminosCondicionesAsync(form);
  }
}