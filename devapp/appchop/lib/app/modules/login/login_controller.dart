import 'package:flutter/widgets.dart';

import '../../data/models/login/login_form.dart';
import '../../utils/get_injection.dart';
import '../../data/models/local_storage/local_storage.dart';

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
      var result = await api.post('login/iniciarSesion', loginForm);
      print(result);
      if(result == null) {
        throw Exception();
      }
    } catch(e) {
      return;
    }
  }

  void verPassword() {
    ocultarPassword = !ocultarPassword;
    update();
  }
}