import 'package:appchop/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/get_injection.dart';

class CobranzaMainController extends GetInjection {
  bool mostrarResultados = false;
  int opcionDeudaSeleccion = 0;

  List<Widget> lll = [];

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    for (var i = 0; i < 2; i++) {
      lll.add(Text("Hola $i"));
    }
  }

  void altaCobranza() {
    Get.toNamed(
      AppRoutes.altaCobranza,
    );
  }

  Future<void> opcionDeudaSeleccionar(int opcion) async {
    opcionDeudaSeleccion = opcion;
    update();
  }
}