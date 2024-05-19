import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/models/app_backup/app_backup_data.dart';
import '../../data/models/local_storage/cargos_abonos.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/local_storage/notas.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../login/login_binding.dart';
import '../login/login_page.dart';

class ConfiguracionController extends GetInjection {
  ScrollController scrollController = ScrollController();
  String idUsuario = "";
  String usuario = "";
  String nombre = "";
  String idBackup = "";
  String fechaBackup = "--";

  final bool esAdmin = GetInjection.administrador;

  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    if(localStorage.idBackup != Literals.backUpClean && localStorage.idBackup != "") {
      idBackup = localStorage.idBackup!;
      fechaBackup = localStorage.fechaBackup!;
    } else {
      idBackup = "Sin registro de actualización";
    }
    idUsuario = localStorage.idUsuario!;
    usuario = localStorage.email!;
    nombre = "${localStorage.nombres!} ${localStorage.apellidos!}";
  }

  Future<void> verificarServidorBackup() async {
    try {
      var online = await tool.isOnline();
      if(!online) {
        tool.msg(Literals.msgOffline, 2);
      }
      tool.isBusy();
      var verificacion = await appBackupRepository.verificarBackupAsync(idUsuario);
      if(verificacion == null) {
        throw Exception();
      }
      await tool.wait(1);
      tool.isBusy(false);
      if(verificacion.idBackup != idBackup) {
        var actualizar = await tool.ask("Nueva versión", "Existe una actualización pendiente\n¿Desea sincronizar?");
        if(!actualizar) {
          return;
        }
      }
    } catch(e) {
      tool.msg("Ocurrió un error al conectarse con el servidor", 3);
    } finally {
      update();
    }
  }

  Future<void> sincronizar() async {
    try {
      tool.isBusy();
      var cobranzas = List<Cobranzas>.from(
        storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
      );
      var cargosAbonos = List<CargosAbonos>.from(
        storage.get([CargosAbonos()]).map((json) => CargosAbonos.fromJson(json))
      );
      var notas = List<Notas>.from(
        storage.get([Notas()]).map((json) => Notas.fromJson(json))
      );
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var backupData = AppBackupData(
        usuarioEnvia: esAdmin ? Literals.perfilAdministrador : localStorage.email,
        cobranzas: cobranzas,
        cargosAbonos: cargosAbonos,
        notas: notas,
      );
      var result = await appBackupRepository.sincronizarAsync(backupData);
      await tool.wait(1);
      tool.isBusy(false);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar sincronizarse con el servidor", 3);
    } finally {
      update();
    }
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