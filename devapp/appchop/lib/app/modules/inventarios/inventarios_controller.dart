import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../data/models/local_storage/inventarios.dart';
import '../../data/models/menu_popup_opciones.dart';
import '../../utils/get_injection.dart';

class InventariosController extends GetInjection {
  TextEditingController busqueda = TextEditingController();

  List<Inventarios> inventarios = [];
  String opcionSelected = "";
  List<String> opcionesBase = [
    "Descripcion~R",
    "Codigo~R",
    "Precio Venta~R",
    "Existencias~R",
    "Importar~B",
    "Exportar~B"
  ];
  List<MenuPopupOpciones> opcionesConsulta = [];
  List<IconData?> opcionesIcono = [
    null, null, null, null,
    MaterialIcons.file_upload,
    MaterialIcons.file_download,
  ];
  
  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    _cargarOpcionesPopup();
  }

  Future<void> opcionDeudaSeleccionar(int opcion) async {
    //opcionDeudaSeleccion = opcion;
    update();
    //await cargarListaCobranza();
  }

  Future<void> opcionPopupConsulta(String? id) async {
    var clicks = [];
    for (var i = 0; i < opcionesBase.length; i++) {
      if(opcionesBase[i].indexOf("~B") > 0) {
        clicks.add(i.toString());
      }
    }
    if(clicks.contains(id)) {
      return await operacionPopUp(id!);
    }
    opcionSelected = id!;
    update();
  }

  Future<void> operacionPopUp(String id) async {
    switch(id) {
      case "4":
        await elegir();
        break;
      case "5":
        
        break;
      default:
        return;
    }
  }

  Future<void> limpiarBusquedaTexto() async {
    busqueda.clear();
    //await cargarListaCobranza();
  }

  Future<void> elegir() async {
    var csvArhivo = await tool.abrirCsv();
    var csvInventario = csvArhivo.split("\n");
    inventarios = [];
    var primer = true;
    for(var inventario in csvInventario) {
      if(primer) {
        primer = false;
        continue;
      }
      var elementos = inventario.split(",");
      inventarios.add(
        Inventarios(
          codigoArticulo: elementos[0],
          descripcion: elementos[1],
          fechaCambio: elementos[7],
        )
      );
      update();
    }
  }

  void cerrar() {
    Get.back();
  }

  void _cargarOpcionesPopup() {
    try {
      opcionesConsulta = [];
      for (var i = 0; i < opcionesBase.length; i++) {
        var opciones = opcionesBase[i].split("~");
        if(opcionSelected == "" && opciones[1] == "R") {
          opcionSelected = i.toString();
        }
        opcionesConsulta.add(MenuPopupOpciones(
          id: i.toString(),
          value: opciones[0],
          tipo: opciones[1],
          icono: opcionesIcono[i],
        ));
      }
      update();
    } finally { }
  }
}