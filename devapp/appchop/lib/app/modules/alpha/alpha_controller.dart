import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/local_storage/cargos_abonos.dart';
import '../../data/models/local_storage/clientes.dart';
import '../../data/models/local_storage/usuarios.dart';
import '../../data/models/local_storage/zonas.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/local_storage/notas.dart';
import '../../data/models/local_storage/zonas_usuarios.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../home/home_binding.dart';
import '../home/home_page.dart';
import '../login/login_binding.dart';
import '../login/login_page.dart';

class AlphaController extends GetInjection {
  late StatelessWidget _page;
  late Bindings _binding;
  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    try {
      await storage.init();
      await tool.wait();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      _page = localStorage.login! ? const HomePage() : const LoginPage();
      _binding = localStorage.login! ? HomeBinding() : LoginBinding();
      GetInjection.administrador = localStorage.perfil! == Literals.perfilAdministrador;
      GetInjection.perfil = localStorage.perfil!;
      await _localStorageClassInit();
      await firebase.init();
      return;
    } catch(e) {
      return;
    } finally {
      _verificarPermisos();
      Get.offAll(
        _page,
        binding: _binding,
        transition: Transition.circularReveal,
        duration: 1.5.seconds,
      );
    }
  }

  Future<void> _localStorageClassInit() async {
    await Zonas.init();
    await Clientes.init();
    await Cobranzas.init();
    await Notas.init();
    await CargosAbonos.init();
    await Usuarios.init();
    await ZonasUsuarios.init();
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