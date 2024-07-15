import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/local_storage/notas.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/columns/nota_detalle_column.dart';
import '../../widgets/containers/basic_bottom_sheet_container.dart';

class AltaNotasController extends GetInjection {
  ScrollController scrollController = ScrollController();
  TextEditingController nota = TextEditingController();
  FocusNode notaFocus = FocusNode();
  Cobranzas? cobranza = Cobranzas();
  bool opcionesTelefonia = false;
  bool abrirUbicacion = false;
  String fechaVencimiento = "";
  String idUsuario = "";
  List<Notas> listaNotas = [];

  String usuario = "";

  final bool esAdmin = GetInjection.administrador;

  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  @override
  void onClose() async {
    var actualizar = false;
    var notas = List<Notas>.from(
      storage.get([Notas()]).map((json) => Notas.fromJson(json))
    );
    for (var i = 0; i < notas.length; i++) {
      if(notas[i].idCobranza != cobranza!.idCobranza) {
        continue;
      }
      if(notas[i].usuarioCrea == usuario) {
        continue;
      }
      if(notas[i].usuarioVisto == "") {
        notas[i].usuarioVisto = usuario;
        actualizar = true;
      }
    }
    if(actualizar) {
      await storage.update(notas);
    }
    super.onClose();
  }

  Future<void> _init() async {
    try {
      var arguments = Get.arguments;
      cobranza = arguments['cobranza'] as Cobranzas;
      if(cobranza == null) {
        Get.back();
        tool.msg("Ocurrió un problema al cargar información de la nota", 3);
      }
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      usuario = esAdmin ? Literals.perfilAdministrador : localStorage.email!;
      idUsuario = localStorage.idUsuario!;
      var notas = List<Notas>.from(
        storage.get([Notas()]).map((json) => Notas.fromJson(json))
      );
      listaNotas = notas.where((n) => n.idCobranza == cobranza!.idCobranza).toList();
      opcionesTelefonia = cobranza!.telefono! != "";
      abrirUbicacion = cobranza!.latitud! != "" && cobranza!.longitud! != "";
      if(cobranza!.fechaVencimiento! != Literals.sinVencimiento) {
        fechaVencimiento = cobranza!.fechaVencimiento!;
      }
    } finally {
      update();
    }
  }

  Future<void> abrirWhatsapp() async {
    await tool.whatsapp(cobranza!.telefono!);
  }

  Future<void> marcarTelefono() async {
    await tool.marcar(cobranza!.telefono!);
  }

  Future<void> abrirGoogleMaps() async {
    await tool.googleMaps(cobranza!.latitud!, cobranza!.longitud!);
  }

  Future<void> guardarNota() async {
    try {
      if(!_formValidaNota()) {
        return;
      }
      tool.isBusy();
      await tool.wait(1);
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var notas = List<Notas>.from(
        storage.get([Notas()]).map((json) => Notas.fromJson(json))
      );
      var idNota = tool.guid();
      var nuevaNota = Notas(
        idUsuario: idUsuario,
        idCobranza: cobranza!.idCobranza,
        idNota: idNota,
        nota: nota.text,
        usuarioCrea: esAdmin ? Literals.perfilAdministrador : localStorage.email,
        fechaCrea: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
      );
      notas.add(nuevaNota);
      await storage.update(notas);
      listaNotas.add(nuevaNota);
      tool.closeBottomSheet();
      tool.msg("Nota almacenada correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un problema al intentar guardar nota", 3);
    } finally {
      update();
    }
  }

  Future<void> detalleNota(Notas nota) async {
    var context = Get.context;
    showMaterialModalBottomSheet(
      context: context!,
      expand: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return BasicBottomSheetContainer(
          context: context,
          cerrar: true,
          child: NotaDetalleColumn(
            nota: nota,
          ),
        );
      },),
    );
  }

  void cerrar() {
    Get.back();
  }

  bool _formValidaNota() {
    var correcto = false;
    var mensaje = "";
    if(tool.isNullOrEmpty(nota)) {
      mensaje = "Escriba algo en la nota";
    } else if(tool.soloSaltos(nota.text)) {
      mensaje = "La nota NO puede estar vacia";
    } else {
      correcto = true;
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }
}