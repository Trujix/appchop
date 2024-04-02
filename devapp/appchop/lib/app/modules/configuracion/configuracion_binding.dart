import 'package:get/get.dart';

import 'configuracion_controller.dart';

class ConfiguracionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConfiguracionController());
  }
}