import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../data/models/local_storage/configuracion.dart';
import '../../data/models/login/login_form.dart';
import '../../utils/get_injection.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../utils/literals.dart';
import '../../widgets/columns/password_column.dart';
import '../../widgets/containers/basic_bottom_sheet_container.dart';
import '../home/home_binding.dart';
import '../home/home_page.dart';

class LoginController extends GetInjection {
  TextEditingController usuario = TextEditingController();
  FocusNode usuarioFocus = FocusNode();
  TextEditingController password = TextEditingController();
  FocusNode passwordFocus = FocusNode();

  TextEditingController nuevaPassword = TextEditingController();
  FocusNode nuevaPasswordFocus = FocusNode();
  TextEditingController repetirPassword = TextEditingController();
  FocusNode repetirPasswordFocus = FocusNode();

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
    usuario.text = "manuel_trujillo@ucol.mx";
    update();
  }

  Future<void> iniciarSesion() async {
    try {
      if(!_validarForm()) {
        return;
      }
      tool.isBusy();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var usuarioLogin = tool.isEmail(usuario.text) ? usuario.text.toLowerCase() : usuario.text.toUpperCase();
      var loginForm = LoginForm(
        usuario: usuarioLogin,
        password: password.text,
        firebase: localStorage.idFirebase,
        sesion: localStorage.idDispositivo,
      );
      var result = await loginRepository.iniciarSesionAsync(loginForm);
      if(result == null) {
        tool.msg('Usuario y/o contraseña incorrecto', 2);
        return;
      }
      localStorage.token = result.token;
      bool? actualizar = false;
      if(result.sesion != Literals.statusIdDispositivo
        && result.sesion != localStorage.idDispositivo) {
          tool.msg('No se pudo iniciar sesión (dispositivo incorrecto)', 2);
          return;
      } else {
        loginForm.idUsuario = result.idSistema;
        await storage.update(localStorage);
        actualizar = await loginRepository.actualizarUsuarioAsync(loginForm);
      }
      if(!actualizar!) {
        tool.msg('No se pudo actualizar su información en el inicio de sesión', 2);
        return;
      }
      if(result.status == Literals.statusPassTemporal) {
        await tool.wait(1);
        tool.isBusy(false);
        _abrirActualizaPasswordForm();
        return;
      }
      localStorage.activo = result.status == Literals.statusActivo;
      if(!localStorage.activo!) {
        tool.msg("Su cuenta de usuario se encuentra como INACTIVA, consulte con el administrador", 2);
        return;
      }
      var configuracion = await configuracionRepository.obtenerConfiguracionUsuarioAsync(result.idSistema!) 
        ?? Configuracion(idUsuario: result.idSistema,);
      GetInjection.administrador = result.perfil == Literals.perfilAdministrador;
      GetInjection.perfil = result.perfil!;
      localStorage.login = true;
      localStorage.idUsuario = result.idSistema;
      localStorage.email = usuarioLogin;
      localStorage.perfil = result.perfil!;
      localStorage.password = password.text;
      localStorage.nombres = result.nombres;
      localStorage.apellidos = result.apellidos;
      localStorage.acepta = result.acepta;
      if(usuarioTextEnabled) {
        localStorage.backupInicial = false;
      }
      var accionUsuario = false;
      if(result.accion == Literals.usuarioAccionReiniciar) {
        accionUsuario = true;
        localStorage.backupInicial = false;
      }
      await storage.update(localStorage);
      await storage.update(configuracion);
      if(accionUsuario) {
        tool.wait(1);
        var _ = await usuariosRepository.eliminarUsuarioAccionAsync(result.idSistema!, usuarioLogin);
        await localStorageClassInit();
      }
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

  Future<void> recuperarPassword() async {
    try {
      if(!_validarFormPassword()) {
        return;
      }
      tool.isBusy();
      var passwordForm = LoginForm(
        usuario: usuario.text,
      );
      var nuevaPassword = await loginRepository.recuperarPasswordAsync(passwordForm);
      if(nuevaPassword == null || nuevaPassword == Literals.newPasswordError) {
        throw Exception();
      }
      if(nuevaPassword == Literals.newPasswordNoUsuario) {
        tool.msg('No se encontró ningun registro con el usuario proporcionado.', 2);
        return;
      }
      await tool.wait(1);
      tool.msg('Contraseña enviada a su correo; puede tardar unos minutos en llegar, le sugerimos revisar su bandeja de Spam', 1);
      return;
    } catch(e) {
      tool.msg('Ocurrio un error al intentar recuperar contraseña', 3);
      return;
    }
  }

  void verPassword() {
    ocultarPassword = !ocultarPassword;
    update();
  }

  void _abrirActualizaPasswordForm() {
    password.text = "";
    var context = Get.context;
    nuevaPassword.text = "";
    repetirPassword.text = "";
    showMaterialModalBottomSheet(
      context: context!,
      expand: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => BasicBottomSheetContainer(
        context: context,
        cerrar: true,
        child: PasswordColumn(
          nuevaPassword: nuevaPassword,
          nuevaPasswordFocus: nuevaPasswordFocus,
          repetirPassword: repetirPassword,
          repetirPasswordFocus: repetirPasswordFocus,
          esNueva: false,
          guardarPassword: _actualizarPassword,
        ),
      ),
    );
  }

  Future<void> _actualizarPassword() async {
    try {
      if(!_validarFormActualizarPassword()) {
        return;
      }
      tool.isBusy();
      var loginForm = LoginForm(
        usuario: usuario.text,
        password: nuevaPassword.text,
      );
      var result = await loginRepository.actualizarPasswordAsync(loginForm);
      if(result == null || !result) {
        throw Exception();
      }
      await tool.wait(1);
      tool.closeBottomSheet();
      tool.msg('Usuario actualizado. Ya puede iniciar sesión con su nueva contraseña.', 1);
    } catch(e) {
      tool.msg('Ocurrio un error al intentar actualizar contraseña', 3);
      return;
    }
  }

  bool _validarForm() {
    var thisContext = Get.context;
    var correcto = false;
    var mensaje = "";
    if(tool.isNullOrEmpty(usuario)) {
      mensaje = "Escriba el usuario";
      FocusScope.of(thisContext!).requestFocus(usuarioFocus);
    } else if(tool.isNullOrEmpty(password)) {
      mensaje = "Escriba la contraseña";
      FocusScope.of(thisContext!).requestFocus(passwordFocus);
    } else {
      correcto = true;
      usuarioFocus.unfocus();
      passwordFocus.unfocus();
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }

  bool _validarFormPassword() {
    var thisContext = Get.context;
    var correcto = false;
    var mensaje = "";
    if(tool.isNullOrEmpty(usuario)) {
      mensaje = "Escriba el usuario";
      FocusScope.of(thisContext!).requestFocus(usuarioFocus);
    } else if(!tool.isEmail(usuario.text)) {
      mensaje = "El usuario no es válido";
      FocusScope.of(thisContext!).requestFocus(usuarioFocus);
    } else {
      correcto = true;
      usuarioFocus.unfocus();
      passwordFocus.unfocus();
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }

  bool _validarFormActualizarPassword() {
    var correcto = false;
    var mensaje = "";
    if(tool.isNullOrEmpty(nuevaPassword)) {
      mensaje = "Escriba la nueva contraseña";
    } else if(tool.isNullOrEmpty(repetirPassword)) {
      mensaje = "Escriba repetir contraseña";
    } else if(nuevaPassword.text != repetirPassword.text) {
      mensaje = "Las contraseñas NO coinciden";
    } else {
      correcto = true;
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }
}