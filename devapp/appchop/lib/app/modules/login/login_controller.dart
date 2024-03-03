import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/models/login/login_form.dart';
import '../../utils/get_injection.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../utils/literals.dart';
import '../home/home_binding.dart';
import '../home/home_page.dart';

class LoginController extends GetInjection {
  TextEditingController usuario = TextEditingController();
  FocusNode usuaroFocus = FocusNode();
  TextEditingController password = TextEditingController();
  FocusNode passwordFocus = FocusNode();

  bool ocultarPassword = true;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    usuario.text = "manuel@mail.com";
    password.text = "12345";
  }

  Future<void> iniciarSesion() async {
    try {
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var loginForm = LoginForm(
        usuario: usuario.text,
        password: password.text,
        firebase: localStorage.idFirebase,
      );
      var result = await loginRepository.iniciarsesionAsync(loginForm);
      if(result == null) {
        throw Exception();
      }
      localStorage.activo = result.status == Literals.statusActivo;
      if(!localStorage.activo!) {
        
      }
      localStorage.login = true;
      localStorage.idUsuario = result.idSistema;
      localStorage.email = usuario.text;
      localStorage.password = password.text;
      localStorage.nombres = result.nombres;
      localStorage.apellidos = result.apellidos;
      localStorage.token = result.token;
      storage.update(localStorage);
      Get.offAll(
        const HomePage(),
        binding: HomeBinding(),
        transition: Transition.cupertino,
        duration: 1.seconds,
      );
      return;
    } catch(e) {
      return;
    }
  }

  void verPassword() {
    ocultarPassword = !ocultarPassword;
    update();
  }
}