import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/local_storage/categorias.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';
import '../cobranza_main/cobranza_main_controller.dart';

class AltaCategoriaController extends GetInjection {
  ScrollController scrollController = ScrollController();
  TextEditingController categoria = TextEditingController();
  FocusNode categoriaNode = FocusNode();
  List<Categorias> listaCategoria = [];

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    listaCategoria = List<Categorias>.from(
      storage.get([Categorias()]).map((json) => Categorias.fromJson(json))
    );
    update();
  }

  void cerrar() {
    Get.back();
  }

  Future<void> guardarCategoria() async {
    try {
      if(!_validarForm()) {
        return;
      }
      tool.isBusy();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var categorias = List<Categorias>.from(
        storage.get([Categorias()]).map((json) => Categorias.fromJson(json))
      );
      categorias.add(Categorias(
        idUsuario: localStorage.idUsuario!,
        idCategoria: tool.guid(),
        valueCategoria: tool.guid(),
        labelCategoria: categoria.text.trim(),
        fechaCreacion: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
      ));
      await storage.update(categorias);
      listaCategoria = categorias;
      await Future.delayed(1.seconds);
      tool.isBusy(false);
      tool.msg("Categoría guardada correctamente", 1);
      categoria.text = "";
      await Get.find<CobranzaMainController>().configurarCategorias(localStorage);
      await Get.find<CobranzaMainController>().cargarListaCobranza();
    } catch(e) {
      tool.msg("Ocurrió un error al intentar guardar categoria", 3);
    } finally {
      update();
    }
  }

  Future<void> cambiarCategoriaEstatus(bool estatus, String idCategoria) async {
    try {
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var categorias = List<Categorias>.from(
        storage.get([Categorias()]).map((json) => Categorias.fromJson(json))
      );
      for(var categoria in categorias) {
        if(categoria.idCategoria == idCategoria) {
          categoria.activo = estatus;
        }
      }
      await storage.update(categorias);
      listaCategoria = categorias;
      await Get.find<CobranzaMainController>().configurarCategorias(localStorage);
      await Get.find<CobranzaMainController>().cargarListaCobranza();
    } finally {
      update();
    }
  }

  bool _validarForm() {
    var correcto = false;
    var mensaje = "";
    if(tool.isNullOrEmpty(categoria)) {
      mensaje = "Escriba la categoria";
      categoriaNode.requestFocus();
    } else {
      correcto = true;
      categoriaNode.unfocus();
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }
}