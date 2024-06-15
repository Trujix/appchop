import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../data/models/local_storage/clientes.dart';
import '../../data/models/local_storage/configuracion.dart';
import '../../data/models/local_storage/inventarios.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/local_storage/usuarios.dart';
import '../../routes/app_routes.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/modals/gestion_csv_modal.dart';
import '../cobranza_main/cobranza_main_controller.dart';
import '../login/login_binding.dart';
import '../login/login_page.dart';

class ConfiguracionController extends GetInjection {
  ScrollController scrollController = ScrollController();
  String idUsuario = "";
  String usuario = "";
  String nombre = "";
  String idBackup = "";
  String fechaBackup = "--";
  
  List<Clientes> _clientesNuevos = [];

  Configuracion configuracion = Configuracion();

  final bool esAdmin = GetInjection.administrador;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    cargarInformacionInicial();
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
        tool.msg("Tiene notificaciones pendientes"); 
      } else {
        tool.msg("No tiene actualizaciones pendientes");
      }
    } catch(e) {
      tool.msg("Ocurrió un error al conectarse con el servidor", 3);
    } finally {
      update();
    }
  }

  Future<void> sincronizar() async {
    try {
      var online = await tool.isOnline();
      if(!online) {
        tool.msg(Literals.msgOffline, 2);
      }
      tool.isBusy();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var validarUsuario = await usuariosRepository.validarUsuarioAsync(localStorage.idUsuario!, localStorage.email!);
      if(validarUsuario == null) {
        throw Exception();
      }
      if(!await _validarUsuario(validarUsuario, localStorage)) {
        return;
      }
      var backupData = crearAppBackupData(esAdmin);
      var appBackupData = await appBackupRepository.sincronizarAsync(backupData);
      if(appBackupData == null) {
        throw Exception();
      }
      await storage.backup(appBackupData);
      idBackup = appBackupData.idBackup!;
      localStorage.idBackup = appBackupData.idBackup;
      localStorage.fechaBackup = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
      await storage.update(localStorage);
      await tool.wait(1);
      _clientesNuevos = [];
      if(esAdmin) {
        var listaClientes = List<Clientes>.from(
          storage.get([Clientes()]).map((json) => Clientes.fromJson(json))
        );
        for(var cobranza in appBackupData.cobranzas!) {
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
      }
      if(_clientesNuevos.isEmpty) {
        tool.msg("La información ha sido actualizada correctamente", 1);
      } else {
        tool.isBusy(false);
        Get.toNamed(
          AppRoutes.appBackupClientes,
          arguments: {
            'clientesNuevos': _clientesNuevos,
          },
        );
      }
    } catch(e) {
      tool.msg("Ocurrió un error al intentar sincronizarse con el servidor", 3);
    } finally {
      cargarInformacionInicial();
      update();
      try {
        await Get.find<CobranzaMainController>().cargarListaCobranza();
      } finally { }
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
      var desvincular = await _desvincularDispositivo();
      return desvincular;
    } catch(e) {
      Get.back();
      tool.msg("Ocurrió un problema al intentar desvincular dispositivo", 3);
      return false;
    }
  }

  Future<bool> _desvincularDispositivo() async {
    try {
      var desvincular = await configuracionRepository.desvincularDispositivoAsync(idUsuario, usuario);
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
    } catch(_) {
      return false;
    }
  }

  void cargarInformacionInicial() {
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    configuracion = Configuracion.fromJson(storage.get(Configuracion()));
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

  Future<bool> _validarUsuario(String validacion, LocalStorage localStorage) async {
    try {
      var correcto = false;
      if(validacion == Literals.validacionErrorEstatus || validacion == Literals.usuarioAccionReiniciar) {
        localStorage.login = false;
        localStorage.activo = false;
        await storage.update(localStorage);
        await tool.wait(1);
        tool.isBusy(false);
        Get.offAll(
          const LoginPage(),
          binding: LoginBinding(),
          duration: 1.5.seconds,
        );
        update();
        var mensaje = "Su usuario NO está Activo";
        if(validacion == Literals.usuarioAccionReiniciar) {
          mensaje = "Es necesario volver a iniciar sesión";
        }
        tool.toast(mensaje);
      } else if(validacion == Literals.validacionErrorZona) {
        await tool.wait(1);
        var _ = await _desvincularDispositivo();
        tool.msg("La zona asignada a su usuario fue modificada o eliminada. Consulte con su administrador", 2);
      } else {
        correcto = true;
      }
      return correcto;
    } catch(_) {
      throw Exception();
    }
  }

  Future<void> exportarReportes(String tipo) async {
    try {
      dynamic listaData = [];
      List<String> omisiones = [];
      var nombreCsv = "";
      if(tipo == Literals.reportesClientes) {
        listaData = List<Clientes>.from(
          storage.get([Clientes()]).map((json) => Clientes.fromJson(json))
        );
        omisiones = ["tabla", "idUsuario"];
        nombreCsv = Literals.reporteClientesCsv;
      } else if(tipo == Literals.reportesUsuarios) {
        listaData = List<Usuarios>.from(
          storage.get([Usuarios()]).map((json) => Usuarios.fromJson(json))
        );
        omisiones = ["tabla"];
        nombreCsv = Literals.reporteUsuariosCsv;
      } else if(tipo == Literals.reportesBaseInventarios) {
        List<Inventarios> inventarios = [Inventarios()];
        listaData = inventarios;
        omisiones = ["tabla", "idUsuario", "idArticulo", "fechaCambio", "usuario"];
        nombreCsv = Literals.reporteBaseInventariosCsv;
      } else {
        return;
      }
      if(listaData.isEmpty) {
        tool.msg("No hay información que mostrar");
        return;
      }
      var contenido = tool.crearCsv(listaData, omisiones);
      var archivoCsv = await tool.crearArchivo(contenido, nombreCsv);
      await Future.delayed(0.7.seconds);
      tool.modal(
        widgets: [GestionCsvModal(
          abrirAccion: () async => await OpenFile.open(archivoCsv),
          exportarAccion: () async => await tool.compartir(archivoCsv!, Literals.reporteCargosAbonosCsv),
        ),]
      );
    } catch(_) {
      tool.msg("Ocurrió un error al intentar exportar información de cargos y abonos", 3);
    }
  }

  void cerrar() {
    Get.back();
  }
}