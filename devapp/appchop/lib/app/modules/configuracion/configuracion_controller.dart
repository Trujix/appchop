import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../login/login_binding.dart';
import '../login/login_page.dart';

class ConfiguracionController extends GetInjection {
  String idUsuario = "";
  String usuario = "";
  String nombre = "";
  String idBackup = "";
  String fechaBackup = "--";

  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    if(localStorage.idBackup != Literals.backUpClean && localStorage.idBackup != "") {
      idBackup = localStorage.idBackup!;
      fechaBackup = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
    } else {
      idBackup = "Sin registro de actualización";
    }
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