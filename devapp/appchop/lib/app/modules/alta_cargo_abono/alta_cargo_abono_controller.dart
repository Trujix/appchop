import 'package:get/get.dart';

import '../../utils/get_injection.dart';

class AltaCargoAbonoController extends GetInjection {
  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {

  }

  void cerrar() {
    Get.back();
  }
}