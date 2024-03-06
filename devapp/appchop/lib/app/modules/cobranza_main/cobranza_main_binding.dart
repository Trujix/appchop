import 'package:get/get.dart';

import 'cobranza_main_controller.dart';

class CobranzaMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CobranzaMainController());
  }
}