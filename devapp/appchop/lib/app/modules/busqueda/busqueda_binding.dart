import 'package:get/get.dart';

import 'busqueda_controller.dart';

class BusquedaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusquedaController());
  }
}