import 'package:get/get.dart';

import 'alta_cargo_abono_controller.dart';

class AltaCargoAbonoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AltaCargoAbonoController());
  }
}