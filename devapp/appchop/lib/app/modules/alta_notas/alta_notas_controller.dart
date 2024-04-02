import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/local_storage/notas.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';

class AltaNotasController extends GetInjection {
  TextEditingController nota = TextEditingController();
  FocusNode notaFocus = FocusNode();
  Cobranzas? cobranza = Cobranzas();
  bool opcionesTelefonia = false;
  bool abrirUbicacion = false;
  String fechaVencimiento = "";
  String idUsuario = "";
  List<Notas> listaNotas = [];
  Notas? notaCargada;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    var arguments = Get.arguments;
    cobranza = arguments['cobranza'] as Cobranzas;
    if(cobranza == null) {
      Get.back();
      tool.msg("Ocurrió un problema al cargar información de la nota", 3);
    }
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    idUsuario = localStorage.idUsuario!;
    listaNotas = List<Notas>.from(
      storage.get([Notas()]).map((json) => Notas.fromJson(json))
    );
    notaCargada = listaNotas.where((n) => n.idCobranza == cobranza!.idCobranza).firstOrNull;
    if(notaCargada != null) {
      nota.text = notaCargada!.nota!;
    }
    opcionesTelefonia = cobranza!.telefono! != "";
    abrirUbicacion = cobranza!.latitud! != "" && cobranza!.longitud! != "";
    if(cobranza!.fechaVencimiento! != Literals.sinVencimiento) {
      fechaVencimiento = cobranza!.fechaVencimiento!;
    }
  }

  Future<void> abrirWhatsapp() async {
    //await tool.whatsapp(cobranza!.telefono!);
  }

  Future<void> marcarTelefono() async {
    //await tool.marcar(cobranza!.telefono!);
  }

  Future<void> abrirGoogleMaps() async {
    //await tool.googleMaps(cobranza!.latitud!, cobranza!.longitud!);
  }

  Future<void> guardarNota() async {
    try {
      if(!_formValidaNota()) {
        return;
      }
      tool.isBusy();
      await Future.delayed(1.seconds);
      if(notaCargada != null) {
        for(var notaEdit in listaNotas) {
          if(notaEdit.idNota == notaCargada!.idNota) {
            notaEdit.nota = nota.text;
          }
        }
      } else {
        var idNota = tool.guid();
        listaNotas.add(Notas(
          idUsuario: idUsuario,
          idCobranza: cobranza!.idCobranza,
          idNota: idNota,
          nota: nota.text,
        ));
      }
      await storage.update(listaNotas);
      Get.back();
      tool.msg("Nota almacenada correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un problema al intentar guardar nota", 3);
    }
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