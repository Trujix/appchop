import 'package:get/get.dart';

import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';
import '../login/login_binding.dart';
import '../login/login_page.dart';

class ConfiguracionController extends GetInjection {
  String idUsuario = "";
  String usuario = "";
  String nombre = "";

  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    idUsuario = localStorage.idUsuario!;
    usuario = localStorage.email!;
    nombre = "${localStorage.nombres!} ${localStorage.apellidos!}";
  }

  Future<bool> desvincularDispositivo() async {
    try {
      var validar = await tool.ask("Desvincular dispositivo", "¿Desea continuar?");
      if(!validar) {
        Get.back();
        return false;
      }
      tool.isBusy();
      var desvincular = await configuracionRepository.desvincularDispositivoAsync(idUsuario);
      if(!desvincular!) {
        throw Exception();
      }
      await storage.clearAll();
      //await storage.update(LocalStorage());
      await storage.init();
      await localStorageClassInit();
      await firebase.init();
      tool.isBusy(false);
      Get.offAll(
        const LoginPage(),
        binding: LoginBinding(),
        transition: Transition.cupertino,
        duration: 1.seconds,
      );
      update();
      return true;
    } catch(e) {
      Get.back();
      tool.msg("Ocurrió un problema al intentar desvincular dispositivo", 3);
      return false;
    }
  }

  void cerrar() {
    Get.back();
  }
}