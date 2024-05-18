import 'dart:convert';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../data/models/app_backup/app_backup_data.dart';
import '../../data/models/backup_etiquetas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../cobranza_main/cobranza_main_controller.dart';

class AppBackupResultadoController extends GetInjection {
  bool respaldoTerminado = false;
  String tituloRespaldo = "Respaldo de información";
  int tipo = 0;
  AppBackupData? appBackupData = AppBackupData();

  List<BackupEtiquetas> etiquetas = [];

  final bool esAdmin = GetInjection.administrador;

  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    try {
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var arguments = Get.arguments;
      if(arguments == null) {
        throw Exception();
      }
      tipo = arguments['tipo'] as int;
      _crearEtiquetas();
      await tool.wait(1);
      var usuario = esAdmin ? Literals.perfilAdministrador : localStorage.email;
      appBackupData = await appBackupRepository.descargarAsync(localStorage.idUsuario!, usuario!);
      if(appBackupData == null) {
        throw Exception();
      }
      print(jsonEncode(appBackupData!.cobranzas));
      await storage.backup(appBackupData!);
      localStorage.backupInicial = true;
      await storage.update(localStorage);
      await tool.wait(2);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar realizar respaldo inicial", 3);
    } finally {
      respaldoTerminado = true;
      _actualizarEtiquetas();
      update();
    }
  }

  void _crearEtiquetas() {
    switch(tipo) {
      case 1:
        tituloRespaldo = "Generando respaldo inicial";
        etiquetas = [
          BackupEtiquetas(
            tag: "cobranzas",
            texto1: "Notas de Cobranza:   ",
            icono: MaterialIcons.description,
          ),
          BackupEtiquetas(
            tag: "zonas",
            texto1: "Zonas:   ",
            icono: MaterialIcons.list_alt,
          ),
        ];
        if(esAdmin) {
          etiquetas.add(BackupEtiquetas(
            tag: "usuarios",
            texto1: "Usuarios:   ",
            icono: MaterialIcons.person_add,
          ),);
        }
      break;
      default:
        return;
    }
    update();
  }

  void _actualizarEtiquetas() {
    for (var i = 0; i < etiquetas.length; i++) {
      if(etiquetas[i].tag == "cobranzas") {
        etiquetas[i].texto2 = "${appBackupData!.cobranzas!.length} registro(s)";
      } else if(etiquetas[i].tag == "zonas") {
        etiquetas[i].texto2 = "${appBackupData!.zonas!.length} registro(s)";
      } else if(etiquetas[i].tag == "usuarios") {
        etiquetas[i].texto2 = "${appBackupData!.usuarios!.length} registro(s)";
      }
    }
  }

  Future<void> salir() async {
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    Get.back();
    if(tipo == 1) {
      await Get.find<CobranzaMainController>().configurarZonas(localStorage);
      await Get.find<CobranzaMainController>().cargarListaCobranza();
    }
  }
}