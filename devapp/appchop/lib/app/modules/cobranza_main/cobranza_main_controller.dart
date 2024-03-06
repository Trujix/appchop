import 'package:appchop/app/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../utils/get_injection.dart';

class CobranzaMainController extends GetInjection {
  int opcionDeudaSeleccion = 0;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {

  }

  void altaCobranza() {
    Get.toNamed(
      AppRoutes.altaCobranza,
    );
  }

  Future<void> opcionDeudaSeleccionar(int opcion) async {
    opcionDeudaSeleccion = opcion;
    update();
  }
}