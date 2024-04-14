import 'package:get/get.dart';

import 'alta_zona_controller.dart';

class AltaZonaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AltaZonaController());
  }
}