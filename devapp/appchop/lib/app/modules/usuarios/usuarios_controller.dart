import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/models/cobradores/alta_cobrador.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/local_storage/usuarios.dart';
import '../../data/models/local_storage/zonas.dart';
import '../../data/models/local_storage/zonas_usuarios.dart';
import '../../utils/get_injection.dart';
import '../../widgets/texts/combo_texts.dart';

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

  List<Usuarios> listaUsuarios = [];

  List<Zonas> zonasLista = [];
  List<BottomSheetAction> listaZonas = [];
  String zonaSelected = "";

  List<ZonasUsuarios> listaZonasUsuarios = [];

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    _cargarZonas();
    listaUsuarios = List<Usuarios>.from(
      storage.get([Usuarios()]).map((json) => Usuarios.fromJson(json))
    );
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
      await Future.delayed(1.seconds);
      var altaContext = Get.context!;
      // ignore: use_build_context_synchronously
      Navigator.of(altaContext, rootNavigator: true).pop(true);
      tool.msg("El usuario registrado correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar guardar el nuevo usuario", 3);
    }
  }

  void crearPasswordRandom() {
    password.text = tool.cadenaAleatoria(5, 'N');
  }

  bool clearForm() {
    if(listaZonas.isEmpty) {
      tool.msg("No tiene Zonas registradas o ya fueron todas asignadas");
    }
    usuario.clear();
    password.clear();
    nombres.clear();
    apellidos.clear();
    zona.clear();
    return listaZonas.isNotEmpty;
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
    zonasLista = zonas;
    List<String> zonasAsiggnadas = [];
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

  bool _validarForm() {
    var correcto = false;
    var mensaje = "";
    if(tool.isNullOrEmpty(usuario)) {
      mensaje = "Escriba el usuario";
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
}