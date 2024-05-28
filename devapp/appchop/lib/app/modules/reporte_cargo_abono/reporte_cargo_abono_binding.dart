import 'package:get/get.dart';

import 'reporte_cargo_abono_controller.dart';

class ReporteCargoAbonoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReporteCargoAbonoController());
  }
}