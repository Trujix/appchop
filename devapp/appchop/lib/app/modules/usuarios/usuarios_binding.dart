import 'package:get/get.dart';

import 'usuarios_controller.dart';

class UsuariosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsuariosController());
  }
}