import 'package:get/get.dart';

import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/login/login_form.dart';
import '../../utils/get_injection.dart';
import '../home/home_controller.dart';

class PdfViewerController extends GetInjection {
  bool salir = true;
  String archivo = "";
  String descripcion = "";
  bool widgetTerminosCondiciones = false;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    var arguments = Get.arguments;
    var tipo = arguments['tipo'] ?? "";
    salir = arguments['salir'] ?? true;
    archivo = arguments['archivo'] ?? "";
    descripcion = arguments['descripcion'] ?? "";
    if(tipo == "TYC") {
      widgetTerminosCondiciones = true;
    }
    update();
  }

  void errorCargarPdf(dynamic error) {
    tool.msg("Ocurrió un error al cargar documento ($descripcion)", 3);
  }

  Future<bool> aceptarTerminos() async {
    try {
      tool.isBusy();
      widgetTerminosCondiciones = false;
      update();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var aceptarForm = LoginForm(
        idUsuario: localStorage.idUsuario,
        acepta: 1,
      );
      var aceptar = await loginRepository.aceptarTerminosCondicionesAsync(aceptarForm);
      if(!aceptar!) {
        throw Exception();
      }
      localStorage.acepta = 1;
      await storage.update(localStorage);
      await tool.wait(1);
      tool.isBusy(false);
      Get.back();
      tool.toast("Gracias por aceptar los Términos y condiciones");
      Get.find<HomeController>().ejecutarAppBackup();
      return true;
    } catch(e) {
      tool.msg("Ocurrió un error al intentar aceptar Términos y condiciones", 3);
      return false;
    }
  }

  void cerrar() {
    if(!salir) {
      return;
    }
    Get.back();
  }
}