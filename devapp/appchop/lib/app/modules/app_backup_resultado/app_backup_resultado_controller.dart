import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/app_backup/app_backup_data.dart';
import '../../data/models/backup_etiquetas.dart';
import '../../data/models/local_storage/clientes.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../cobranza_main/cobranza_main_controller.dart';
import '../login/login_binding.dart';
import '../login/login_page.dart';

class AppBackupResultadoController extends GetInjection {
  bool respaldoTerminado = false;
  bool errorRespaldo = false;
  String tituloRespaldo = "Respaldo de información";
  String estatusRespaldo = "Por favor espere...";
  int tipo = 0;
  AppBackupData? appBackupData = AppBackupData();

  List<Clientes> _clientesNuevos = [];

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
      await storage.backup(appBackupData!);
      localStorage.backupInicial = true;
      localStorage.fechaBackup = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
      await storage.update(localStorage);
      var listaClientes = List<Clientes>.from(
        storage.get([Clientes()]).map((json) => Clientes.fromJson(json))
      );
      _clientesNuevos = [];
      for(var cobranza in appBackupData!.cobranzas!) {
        var verificar = listaClientes.where((c) => c.telefono == cobranza.telefono).firstOrNull;
        if(verificar != null) {
          continue;
        }
        var idCliente = tool.guid();
        _clientesNuevos.add(Clientes(
          idUsuario: localStorage.idUsuario,
          idCliente: idCliente,
          nombre: cobranza.nombre,
          telefono: cobranza.telefono,
          fechaCreacion: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
        ));
      }
      await tool.wait(2);
      estatusRespaldo = "Respaldo terminado con éxito";
    } catch(e) {
      errorRespaldo = true;
      estatusRespaldo = "Error en el respaldo";
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
            tag: "cargos_abonos",
            texto1: "Cargos y abonos   ",
            icono: MaterialIcons.attach_money,
          ),
          BackupEtiquetas(
            tag: "notas",
            texto1: "Notas:   ",
            icono: MaterialIcons.note_add,
          ),
          BackupEtiquetas(
            tag: "zonas",
            texto1: "Zonas:   ",
            icono: MaterialIcons.list_alt,
          ),
        ];
        if(esAdmin) {
          etiquetas.add(
            BackupEtiquetas(
              tag: "clientes",
              texto1: "Clientes:   ",
              icono: MaterialIcons.contact_phone,
            ),
          );
          etiquetas.add(
            BackupEtiquetas(
              tag: "usuarios",
              texto1: "Usuarios:   ",
              icono: MaterialIcons.person_add,
            ),
          );
          etiquetas.add(
            BackupEtiquetas(
              tag: "inventarios",
              texto1: "Inventario:   ",
              icono: MaterialIcons.inventory,
            ),
          );
        }
      break;
      default:
        return;
    }
    update();
  }

  void _actualizarEtiquetas() {
    try {
      for (var i = 0; i < etiquetas.length; i++) {
        if(etiquetas[i].tag == "cobranzas") {
          etiquetas[i].texto2 = "${appBackupData!.cobranzas!.length} registro(s)";
        } else if(etiquetas[i].tag == "cargos_abonos") {
          etiquetas[i].texto2 = "${appBackupData!.cargosAbonos!.length} registro(s)";
        } else if(etiquetas[i].tag == "notas") {
          etiquetas[i].texto2 = "${appBackupData!.notas!.length} registro(s)";
        } else if(etiquetas[i].tag == "zonas") {
          etiquetas[i].texto2 = "${appBackupData!.zonas!.length} registro(s)";
        } else if(etiquetas[i].tag == "clientes") {
          etiquetas[i].texto2 = "${appBackupData!.clientes!.length} registro(s)";
        } else if(etiquetas[i].tag == "usuarios") {
          etiquetas[i].texto2 = "${appBackupData!.usuarios!.length} registro(s)";
        } else if(etiquetas[i].tag == "inventarios") {
          etiquetas[i].texto2 = "${appBackupData!.inventarios!.length} registro(s)";
        } 
      }
    } finally {
      update();
    }
  }

  Future<void> salir() async {
    if(errorRespaldo) {
      Get.offAll(
        const LoginPage(),
        binding: LoginBinding(),
        transition: Transition.circularReveal,
        duration: 1.5.seconds,
      );
      return;
    }
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    Get.back();
    if(tipo == 1) {
      await Get.find<CobranzaMainController>().configurarZonas(localStorage);
      await Get.find<CobranzaMainController>().cargarListaCobranza();
      await Get.find<CobranzaMainController>().validarNuevosClientes(_clientesNuevos);
    }
  }
}