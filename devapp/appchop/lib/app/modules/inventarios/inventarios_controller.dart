import 'dart:convert';

import 'package:get/get.dart';

import '../../data/models/local_storage/inventarios.dart';
import '../../utils/get_injection.dart';

class InventariosController extends GetInjection {
  List<Inventarios> inventarios = [];

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {

  }

  Future<void> elegir() async {
    var csvArhivo = await tool.abrirCsv();
    var csvInventario = csvArhivo.split("\n");
    print(csvInventario);
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
}