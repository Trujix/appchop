import 'package:get/get.dart';

import '../models/login/login_data.dart';
import '../models/login/login_form.dart';
import '../providers/login_provider.dart';

class LoginRepository {
  Future<LoginData?> iniciarsesionAsync(LoginForm form) async {
    return await Get.find<LoginProvider>().iniciarsesionAsync(form);
  }

  Future<bool?> actualizarUsuarioAsync(LoginForm form) async {
    return await Get.find<LoginProvider>().actualizarUsuarioAsync(form);
  }

  Future<bool?> aceptarTerminosCondicionesAsync(LoginForm form) async {
    return await Get.find<LoginProvider>().aceptarTerminosCondicionesAsync(form);
  }
}