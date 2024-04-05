import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/local_storage/cargos_abonos.dart';
import '../../data/models/local_storage/categorias.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/local_storage/notas.dart';
import '../../utils/get_injection.dart';
import '../home/home_binding.dart';
import '../home/home_page.dart';
import '../login/login_binding.dart';
import '../login/login_page.dart';

class AlphaController extends GetInjection {

  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    try {
      await storage.init();
      await firebase.init();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      await tool.wait();
      var page = localStorage.login! ? const HomePage() : const LoginPage();
      var binding = localStorage.login! ? HomeBinding() : LoginBinding();
      await _localStorageClassInit();
      Get.offAll(
        page,
        binding: binding,
        transition: Transition.circularReveal,
        duration: 1.5.seconds,
      );
    } catch(e) {
      return;
    } finally {
      _verificarPermisos();
    }
  }

  Future<void> _localStorageClassInit() async {
    await Categorias.init();
    await Cobranzas.init();
    await Notas.init();
    await CargosAbonos.init();
    return;
  }

  void _verificarPermisos() async {
    await Permission.notification.isDenied.then((denegado) {
      if (denegado) {
        Permission.notification.request();
      }
    });
    await Permission.storage.isDenied.then((denegado) {
      if(denegado) {
        Permission.storage.request();
      }
    });
  }
}