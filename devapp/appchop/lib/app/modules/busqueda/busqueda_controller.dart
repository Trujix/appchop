import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/busqueda_elementos.dart';
import '../../data/models/local_storage/clientes.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../alta_cobranza/alta_cobranza_controller.dart';

class BusquedaController extends GetInjection {
  ScrollController scrollController = ScrollController();
  TextEditingController busquedaController = TextEditingController();
  String tipoBusqueda = "";

  List<Clientes> _listaClientes = [];

  List<BusquedaElementos> elementosBusqueda = [];
  List<BusquedaElementos> _elementosBusquedaTemp = [];
  List<String> opcionesBase = [];

  String sinResultados = "Sin resultados por mostrar";

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    try {
      var arguments = Get.arguments;
      if(arguments['tipoBusqueda'] == null) {
        return;
      }
      tipoBusqueda = arguments['tipoBusqueda'] as String;
      if(tipoBusqueda == Literals.busquedaClientes) {
        _listaClientes = List<Clientes>.from(
          storage.get([Clientes()]).map((json) => Clientes.fromJson(json))
        );
        sinResultados = "No hay clientes por mostrar";
        opcionesBase = ["Nombre", "Teléfono"];
        for(var cliente in _listaClientes) {
          elementosBusqueda.add(BusquedaElementos(
            id: tool.guid(),
            value: "${cliente.nombre} ${cliente.telefono}".toUpperCase(),
            etiqueta: "Nombre: Ø${cliente.nombre}~Telefono: Ø${cliente.telefono}",
            elemento: cliente,
          ));
        }
      }
      _elementosBusquedaTemp = elementosBusqueda;
    } finally {
      update();
    }
  }

  void buscar(String? busqueda) {
    try {
      _filtrarBusqueda();
    } finally {
      update();
    }
  }

  void limpiarBusqueda() {
    busquedaController.text = "";
    _filtrarBusqueda();
    update();
  }

  void cerrar() {
    Get.back();
  }

  void mensajeTap() {
    tool.toast("Deje presionado para seleccionar");
  }

  Future<void> seleccionarElemento(dynamic elemento) async {
    try {
      if(tipoBusqueda == Literals.busquedaClientes) {
        Get.find<AltaCobranzaController>().busquedaClienteResult(elemento);
      }
      Get.back();
    } catch(e) {
      tool.msg("Ocurrió un problema al seleccionar elemento", 3);
    }
  }

  void _filtrarBusqueda() {
    try {
      elementosBusqueda = _elementosBusquedaTemp;
      elementosBusqueda = elementosBusqueda.where(
        (e) => e.value.contains(busquedaController.text.toUpperCase())
      ).toList();
    } finally { }
  }
}