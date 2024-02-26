import 'package:get/get.dart';

import 'alpha_controller.dart';

class AlphaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlphaController());
  }
}