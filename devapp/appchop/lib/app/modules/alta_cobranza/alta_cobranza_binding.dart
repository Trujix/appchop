import 'package:get/get.dart';

import 'alta_cobranza_controller.dart';

class AltaCobranzaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AltaCobranzaController());
  }
}