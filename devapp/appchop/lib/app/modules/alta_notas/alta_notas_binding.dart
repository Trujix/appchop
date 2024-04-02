import 'package:get/get.dart';

import 'alta_notas_controller.dart';

class AltaNotasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AltaNotasController());
  }
}