import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/local_storage/zonas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';
import '../cobranza_main/cobranza_main_controller.dart';

class AltaZonaController extends GetInjection {
  ScrollController scrollController = ScrollController();
  TextEditingController zona = TextEditingController();
  FocusNode zonaNode = FocusNode();
  List<Zonas> listaZona = [];

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    listaZona = List<Zonas>.from(
      storage.get([Zonas()]).map((json) => Zonas.fromJson(json))
    );
    update();
  }

  void cerrar() {
    Get.back();
  }

  Future<void> guardarZona() async {
    try {
      if(!_validarForm()) {
        return;
      }
      tool.isBusy();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var zonas = List<Zonas>.from(
        storage.get([Zonas()]).map((json) => Zonas.fromJson(json))
      );
      zonas.add(Zonas(
        idUsuario: localStorage.idUsuario!,
        idZona: tool.guid(),
        valueZona: tool.guid(),
        labelZona: zona.text.trim(),
        fechaCreacion: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
      ));
      await storage.update(zonas);
      listaZona = zonas;
      await Future.delayed(1.seconds);
      tool.isBusy(false);
      tool.msg("Zona guardada correctamente", 1);
      zona.text = "";
      await Get.find<CobranzaMainController>().configurarZonas(localStorage);
      await Get.find<CobranzaMainController>().cargarListaCobranza();
    } catch(e) {
      tool.msg("Ocurrió un error al intentar guardar zona", 3);
    } finally {
      update();
    }
  }

  Future<void> cambiarZonaEstatus(bool estatus, String idZona) async {
    try {
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var zonas = List<Zonas>.from(
        storage.get([Zonas()]).map((json) => Zonas.fromJson(json))
      );
      for(var zona in zonas) {
        if(zona.idZona == idZona) {
          zona.activo = estatus;
        }
      }
      await storage.update(zonas);
      listaZona = zonas;
      await Get.find<CobranzaMainController>().configurarZonas(localStorage);
      await Get.find<CobranzaMainController>().cargarListaCobranza();
    } finally {
      update();
    }
  }

  bool _validarForm() {
    var correcto = false;
    var mensaje = "";
    if(tool.isNullOrEmpty(zona)) {
      mensaje = "Escriba la zona";
      zonaNode.requestFocus();
    } else {
      correcto = true;
      zonaNode.unfocus();
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }
}