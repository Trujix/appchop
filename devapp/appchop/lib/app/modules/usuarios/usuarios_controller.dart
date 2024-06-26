import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/models/cobradores/alta_cobrador.dart';
import '../../data/models/firebase/notificacion.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/local_storage/usuarios.dart';
import '../../data/models/local_storage/zonas.dart';
import '../../data/models/local_storage/zonas_usuarios.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/modals/usuario_password_modal.dart';
import '../../widgets/texts/combo_texts.dart';
import '../cobranza_main/cobranza_main_controller.dart';

class UsuariosController extends GetInjection {
  ScrollController scrollController = ScrollController();

  TextEditingController usuario = TextEditingController();
  FocusNode usuarioFocus = FocusNode();
  TextEditingController password = TextEditingController();
  FocusNode passwordFocus = FocusNode();
  TextEditingController nombres = TextEditingController();
  FocusNode nombresFocus = FocusNode();
  TextEditingController apellidos = TextEditingController();
  FocusNode apellidosFocus = FocusNode();
  TextEditingController zona = TextEditingController();
  FocusNode zonaFocus = FocusNode();

  ZonasUsuarios? _zonasUsuariosVerify;
  List<Usuarios> listaUsuarios = [];

  List<Zonas> zonasLista = [];
  List<BottomSheetAction> listaZonas = [];
  String zonaSelected = "";

  List<ZonasUsuarios> listaZonasUsuarios = [];

  final bool esAdmin = GetInjection.administrador;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    await _ready();
    super.onReady();
  }

  void _init() {
    _cargarZonas();
    listaUsuarios = List<Usuarios>.from(
      storage.get([Usuarios()]).map((json) => Usuarios.fromJson(json))
    );
  }

  Future<void> _ready() async {
    try {
      tool.isBusy();
      var verificarOnline = await tool.isOnline();
      if(!verificarOnline) {
        return;
      }
      await _backupZonas();
    } finally {
      tool.isBusy(false);
    }
  }

  Future<void> guardarNuevoUsuario() async {
    try {
      if(!_validarForm()) {
        return;
      }
      tool.isBusy();
      var internet = await tool.isOnline();
      if(!internet) {
        tool.msg("Necesita conección a internet para agregar nuevos usuarios", 2);
        return;
      }
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var usuarioAlta = usuario.text.toUpperCase();
      var verificar = await cobradoresRepository.verificarCobradorAsync(localStorage.idUsuario!, usuarioAlta);
      if(verificar == null) {
        throw Exception();
      }
      if(!verificar) {
        tool.msg("Ya existe un registro con el nombre de usuario ($usuarioAlta)", 2);
        return;
      }
      var crearBackup = await _crearBackup();
      if(!crearBackup) {
        throw Exception();
      }
      var altaForm = AltaCobrador(
        idUsuario: localStorage.idUsuario!,
        usuario: usuarioAlta,
        password: password.text,
        nombres: nombres.text,
        apellidos: apellidos.text,
      );
      var alta = await cobradoresRepository.altaCobradorAsync(altaForm);
      if(alta == null || !alta) {
        throw Exception();
      }
      listaUsuarios.add(Usuarios(
        idUsuario: localStorage.idUsuario!,
        usuario: usuarioAlta,
        password: password.text,
        nombres: nombres.text,
        apellidos: apellidos.text,
      ));
      await storage.update(listaUsuarios);
      listaZonasUsuarios.add(ZonasUsuarios(
        idUsuario: localStorage.idUsuario!,
        idZona: zonaSelected,
        usuario: usuarioAlta,
      ));
      await storage.update(listaZonasUsuarios);
      await _backupZonas();
      _cargarZonas();
      var _ = _verificarUsuarioZona(usuarioAlta);
      await _modificarCobranzas(Literals.bloqueoSi);
      await tool.wait(1);
      await _desbloquearCobranzas();
      await Future.delayed(1.seconds);
      tool.closeBottomSheet();
      tool.msg("El usuario registrado correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar guardar el nuevo usuario", 3);
    } finally {
      update();
    }
  }

  void crearPasswordRandom() {
    password.text = tool.cadenaAleatoria(5, 'N');
  }

  bool clearForm() {
    if(listaZonas.isEmpty) {
      tool.msg("No tiene Zonas registradas, activas o ya fueron todas asignadas");
    }
    usuario.clear();
    password.clear();
    nombres.clear();
    apellidos.clear();
    zona.clear();
    return listaZonas.isNotEmpty;
  }

  Future<void> actualizarPassword(Usuarios usuario) async {
    try {
      tool.isBusy();
      var online = await tool.isOnline();
      if(!online) {
        tool.msg(Literals.msgOffline, 2);
        return;
      }
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var cobradorInfo = await cobradoresRepository.consultarCobradorInfoAsync(localStorage.idUsuario!, usuario.usuario!);
      if(cobradorInfo == null) {
        throw Exception();
      }
      await Future.delayed(1.seconds);
      tool.isBusy(false);
      tool.modal(
        widgets: [
          UsuarioPasswordModal(
            usuario: usuario.usuario!,
            cambiarMostrar: () => _actualizarPassword(localStorage.idUsuario!, usuario.usuario!, null),
            cambiarEnviar: () => _actualizarPassword(localStorage.idUsuario!, usuario.usuario!, cobradorInfo.idFirebase),
          ),
        ],
        height: 160,
      );
    } catch(e) {
      tool.msg("Ocurrió un error al consultar información del usuario", 3);
    }
  }

  Future<void> _actualizarPassword(String idUsuario, String usuario, String? idFirebase) async {
    try {
      tool.modalClose();
      tool.isBusy();
      var password = tool.cadenaAleatoria(5, 'N');
      var cobrador = AltaCobrador(
        idUsuario: idUsuario,
        usuario: usuario,
        password: password,
      );
      var actualizar = await cobradoresRepository.actualizarPasswordAsync(cobrador);
      if(actualizar == null || !actualizar) {
        throw Exception();
      }
      var mensaje = "Contraseña actualizada: $password";
      if(idFirebase != null) {
        var notificacion = Notificacion(
          titulo: "Nueva contraseña",
          cuerpo: "$password es su nueva contraseña",
          ids: [idFirebase],
          data: {
            "accion": Literals.notificacionUsuarioPassword,
            "password": password,
          },
        );
        try {
          var _ = await firebaseRepository.enviarNotificacionAsync(notificacion);
        } finally { }
        mensaje = "La contraseña fue generada correctamente";
      }
      await Future.delayed(1.seconds);
      tool.msg(mensaje, 1);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar actualizar la contraseña del usuario", 3);
    }
  }

  Future<void> cambiarEstatus(Usuarios usuario) async {
    try {
      var titulo = "${usuario.activo! ? "INACTIVAR" : "ACTIVAR"} Usuario ${usuario.usuario}";
      var cuerpo = "¿Desea continuar?";
      var usuarioZonaVerif = _verificarUsuarioZona(usuario.usuario!);
      if(usuarioZonaVerif && usuario.activo!) {
        cuerpo = "Se quitará la zona asignada al usuario\n$cuerpo";
      }
      var modificar = await tool.ask(titulo, cuerpo);
      if(!modificar) {
        return;
      }
      tool.isBusy();
      var online = await tool.isOnline();
      if(!online) {
        tool.msg(Literals.msgOffline, 2);
        return;
      }
      if(usuario.activo!) {
        var crearBackup = await _crearBackup();
        if(!crearBackup) {
          throw Exception();
        }
      }
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var cobrador = AltaCobrador(
        idUsuario: localStorage.idUsuario,
        usuario: usuario.usuario,
        estatus: usuario.activo! ? Literals.statusInactivo : Literals.statusActivo,
      );
      var actualizar = await cobradoresRepository.actualizarEstatusAsync(cobrador);
      if(actualizar == null || !actualizar) {
        throw Exception();
      }
      for(var usuarioIn in listaUsuarios) {
        if(usuarioIn.usuario == usuario.usuario) {
          usuarioIn.activo = !usuario.activo!;
        }
      }
      await storage.update(listaUsuarios);
      if(usuarioZonaVerif) {
        listaZonasUsuarios.removeWhere((zu) => zu.usuario == usuario.usuario);
        if(listaZonasUsuarios.isNotEmpty) {
          await storage.update(listaZonasUsuarios);
        } else {
          var _ = await storage.put([ZonasUsuarios()]);
        }
        await _modificarCobranzas(Literals.bloqueoNo);
        await tool.wait(1);
        await _desbloquearCobranzas();
      }
      await _backupZonas();
      _cargarZonas();
      await Future.delayed(1.seconds);
      tool.msg("El usuario fue actualizado correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar actualizar info. del usuario", 3);
    } finally {
      update();
    }
  }

  Future<void> modificarZona(Usuarios usuario, bool agregar) async {
    try {
      if(agregar) {
        if(tool.isNullOrEmpty(zona)) {
          tool.toast("Elige la Zona");
          return;
        }
      } else {
        var removerZona = await tool.ask("Remover zona a ${usuario.usuario}", "¿Desea continuar?");
        if(!removerZona) {
          return;
        }
      }
      tool.isBusy();
      if(agregar) {
        var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
        var crearBackup = await _crearBackup();
        if(!crearBackup) {
          throw Exception();
        }
        listaZonasUsuarios.add(ZonasUsuarios(
          idUsuario: localStorage.idUsuario!,
          idZona: zonaSelected,
          usuario: usuario.usuario,
        ));
        var _ = await appBackupRepository.agregarUsuarioAccionAsync(localStorage.idUsuario!, usuario.usuario!, Literals.usuarioAccionReiniciar);
      } else {
        listaZonasUsuarios.removeWhere((zu) => zu.usuario == usuario.usuario);
      }
      if(listaZonasUsuarios.isNotEmpty) {
        await storage.update(listaZonasUsuarios);
      } else {
        var _ = await storage.put([ZonasUsuarios()]);
      }
      await _backupZonas();
      _cargarZonas();
      var _ = _verificarUsuarioZona(usuario.usuario!);
      await _modificarCobranzas(agregar ? Literals.bloqueoSi : Literals.bloqueoNo);
      await tool.wait(1);
        await _desbloquearCobranzas();
      await Future.delayed(1.seconds);
      if(agregar) {
        tool.closeBottomSheet();
      }
      tool.msg("Usuario configurado correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar actualizar config. del usuario", 3);
    } finally {
      update();
    }
  }

  void cerrar() {
    Get.back();
  }

  void _cargarZonas() {
    listaZonasUsuarios = List<ZonasUsuarios>.from(
      storage.get([ZonasUsuarios()]).map((json) => ZonasUsuarios.fromJson(json))
    );
    var zonas = List<Zonas>.from(
      storage.get([Zonas()]).map((json) => Zonas.fromJson(json))
    );
    zonas = zonas.where((z) => z.activo!).toList();
    zonasLista = zonas;
    List<String> zonasAsiggnadas = [];
    listaZonas = [];
    for(var zonaUsuario in listaZonasUsuarios) {
      zonasAsiggnadas.add(zonaUsuario.idZona!);
    }
    for(var zonaIn in zonas) {
      if(zonasAsiggnadas.contains(zonaIn.valueZona)) {
        continue;
      }
      listaZonas.add(BottomSheetAction(
          title: ComboText(
            texto: zonaIn.labelZona!,
          ),
          onPressed: (context) {
            zona.text = zonaIn.labelZona!;
            zonaSelected = zonaIn.valueZona!;
            update();
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  Future<bool> _crearBackup() async {
    try {
      var backupData = crearAppBackupData(esAdmin);
      var appBackupData = await appBackupRepository.sincronizarAsync(backupData);
      if(appBackupData == null) {
        throw Exception();
      }
      await storage.backup(appBackupData);
      return true;
    } catch(_) {
      return false;
    }
  }

  Future<void> _modificarCobranzas(String bloqueo) async {
    var listaCobranzas = List<Cobranzas>.from(
      storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
    );
    var actualizar = false;
    for (var i = 0; i < listaCobranzas.length; i++) {
      if(listaCobranzas[i].zona == _zonasUsuariosVerify!.idZona) {
        listaCobranzas[i].bloqueado = bloqueo;
        actualizar = true;
      }
    }
    if(actualizar) {
      await storage.update(listaCobranzas);
      try {
        await Get.find<CobranzaMainController>().cargarListaCobranza();
      } finally { }
    }
  }

  bool _verificarUsuarioZona(String usuario) {
    _zonasUsuariosVerify = listaZonasUsuarios.where((zu) => zu.usuario == usuario).firstOrNull;
    return _zonasUsuariosVerify != null;
  }

  Future<bool> _desbloquearCobranzas() async {
    try {
      var listaCobranzas = List<Cobranzas>.from(
        storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
      );
      listaCobranzas = listaCobranzas.where((c) => c.zona == _zonasUsuariosVerify!.idZona).toList();
      var desbloquearCobranzas = await appBackupRepository.desbloquearCobranzasAdministradorAsync(listaCobranzas);
      if(desbloquearCobranzas == null || !desbloquearCobranzas) {
        throw Exception();
      }
      return true;
    } catch(_) {
      return false;
    }
  }

  bool _validarForm() {
    var correcto = false;
    var mensaje = "";
    var espacios = 0;
    for (var i = 0; i < usuario.text.length; i++) {
      if(usuario.text[i] == " ") {
        espacios++;
      }
    }
    if(tool.isNullOrEmpty(usuario)) {
      mensaje = "Escriba el usuario";
    } else if(espacios > 0) {
      mensaje = "El usuario NO puede contener espacios";
    } else if(usuario.text.trim() == Literals.perfilAdministrador) {
      mensaje = "Nombre de usuario incorrecto";
    } else if(tool.isEmail(usuario.text.trim())) {
      mensaje = "Nombre de usuario incorrecto";
    } else if(tool.isNullOrEmpty(password)) {
      mensaje = "Escriba la contraseña";
    } else if(tool.isNullOrEmpty(nombres)) {
      mensaje = "Escriba el nombre";
    } else if(tool.isNullOrEmpty(apellidos)) {
      mensaje = "Escriba el apellido";
    } else if(tool.isNullOrEmpty(zona)) {
      mensaje = "Elige una zona";
    } else {
      correcto = true;
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }

  Future<void> _backupZonas() async {
    try {
      await tool.wait(1);
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var zonasBack = List<Zonas>.from(
        storage.get([Zonas()]).map((json) => Zonas.fromJson(json))
      );
      var zonasUsuariosBack = List<ZonasUsuarios>.from(
        storage.get([ZonasUsuarios()]).map((json) => ZonasUsuarios.fromJson(json))
      );
      var _ = await appBackupRepository.backupZonasAsync(zonasBack);
      if(zonasUsuariosBack.isNotEmpty) {
        _ = await appBackupRepository.backupZonasUsuariosAsync(zonasUsuariosBack);
      } else {
         _ = await appBackupRepository.removerZonasUsuariosAsync(localStorage.idUsuario!);
      }
    } finally { }
  }
}