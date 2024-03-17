import 'package:get/get.dart';

import 'alta_categoria_controller.dart';

class AltaCategoriaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AltaCategoriaController());
  }
}