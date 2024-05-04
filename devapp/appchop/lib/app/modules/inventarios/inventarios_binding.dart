import 'package:get/get.dart';

import 'inventarios_controller.dart';

class InventariosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InventariosController());
  }
}