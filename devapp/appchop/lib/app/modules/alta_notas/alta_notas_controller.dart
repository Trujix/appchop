import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/models/local_storage/cobranzas.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';

class AltaNotasController extends GetInjection {
  TextEditingController nota = TextEditingController();
  FocusNode notaFocus = FocusNode();
  Cobranzas? cobranza = Cobranzas();
  bool opcionesTelefonia = false;
  bool abrirUbicacion = false;
  String fechaVencimiento = "";

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    var arguments = Get.arguments;
    cobranza = arguments['cobranza'] as Cobranzas;
    if(cobranza == null) {

    }
    opcionesTelefonia = cobranza!.telefono! != "";
    abrirUbicacion = cobranza!.latitud! != "" && cobranza!.longitud! != "";
    if(cobranza!.fechaVencimiento! != Literals.sinVencimiento) {
      fechaVencimiento = cobranza!.fechaVencimiento!;
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

  }

  void cerrar() {
    Get.back();
  }
}