import 'package:get/get.dart';

import 'alta_clientes_controller.dart';

class AltaClientesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AltaClientesController());
  }
}