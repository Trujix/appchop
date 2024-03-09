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
  bool usuarioTextEnabled = true;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    usuario.text = localStorage.email!;
    usuarioTextEnabled = localStorage.email! == "";
    update();
  }

  Future<void> iniciarSesion() async {
    try {
      if(!_validarForm()) {
        return;
      }
      tool.isBusy();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var loginForm = LoginForm(
        usuario: usuario.text,
        password: password.text,
        firebase: localStorage.idFirebase,
        sesion: localStorage.idDispositivo,
      );
      var result = await loginRepository.iniciarsesionAsync(loginForm);
      if(result == null) {
        tool.msg('Usuario y/o contraseña incorrecto', 2);
        return;
      }
      localStorage.activo = result.status == Literals.statusActivo;
      if(!localStorage.activo!) {
        tool.msg("Su cuenta de usuario se encuentra como INACTIVA, consulte con el administrador", 2);
        return;
      }
      localStorage.login = true;
      localStorage.idUsuario = result.idSistema;
      localStorage.email = usuario.text;
      localStorage.password = password.text;
      localStorage.nombres = result.nombres;
      localStorage.apellidos = result.apellidos;
      localStorage.token = result.token;
      await storage.update(localStorage);
      tool.isBusy(false);
      Get.offAll(
        const HomePage(),
        binding: HomeBinding(),
        transition: Transition.cupertino,
        duration: 1.seconds,
      );
      return;
    } catch(e) {
      tool.msg('Ocurrio un error al iniciar sesión', 3);
      return;
    }
  }

  void verPassword() {
    ocultarPassword = !ocultarPassword;
    update();
  }

  bool _validarForm() {
    var thisContext = Get.context;
    var correcto = false;
    var mensaje = "";
    if(tool.isNullOrEmpty(usuario)) {
      mensaje = "Escriba el usuario";
      FocusScope.of(thisContext!).requestFocus(usuaroFocus);
    } else if(tool.isNullOrEmpty(password)) {
      mensaje = "Escriba la contraseña";
      FocusScope.of(thisContext!).requestFocus(passwordFocus);
    } else {
      correcto = true;
      usuaroFocus.unfocus();
      passwordFocus.unfocus();
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }
}