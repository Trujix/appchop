import 'dart:convert';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../models/login/login_data.dart';
import '../models/login/login_form.dart';

class LoginProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<LoginData?> iniciarsesionAsync(LoginForm form) async {
    try {
      var result = await _api.post(
        "login/iniciarSesion",
        form,
      );
      return LoginData.fromApi(jsonDecode(result!));
    } catch(e) {
      return null;
    }
  }
}