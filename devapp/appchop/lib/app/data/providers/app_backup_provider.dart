import 'dart:convert';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/literals.dart';
import '../models/app_backup/app_backup_data.dart';
import '../models/app_backup/app_backup_info.dart';
import '../models/local_storage/cobranzas.dart';
import '../models/local_storage/zonas.dart';
import '../models/local_storage/zonas_usuarios.dart';

class AppBackupProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<AppBackupData?> sincronizarAsync(AppBackupData backupInfo) async {
    try {
      var result = await _api.post(
        "api/appbackup/sincronizar",
        backupInfo
      );
      return AppBackupData.fromApi(jsonDecode(result!));
    } catch(e) {
      return null;
    }
  }

  Future<AppBackupInfo?> verificarBackupAsync(String idUsuario) async {
    try {
      var result = await _api.get(
        "api/appbackup/verificarBackup/$idUsuario"
      );
      return AppBackupInfo.fromApi(jsonDecode(result!));
    } catch(e) {
      return null;
    }
  }

  Future<AppBackupData?> descargarAsync(String idUsuario, String usuario) async {
    try {
      var result = await _api.get(
        "api/appbackup/descargar/$idUsuario/$usuario"
      );
      return AppBackupData.fromApi(jsonDecode(result!));
    } catch(e) {
      return null;
    }
  }

  Future<bool?> backupZonasAsync(List<Zonas> zonas) async {
    try {
      var result = await _api.post(
        "api/appbackup/backupZonas",
        zonas,
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }

  Future<bool?> backupZonasUsuariosAsync(List<ZonasUsuarios> zonasUsuarios) async {
    try {
      var result = await _api.post(
        "api/appbackup/backupZonasUsuarios",
        zonasUsuarios,
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }

  Future<bool?> removerZonasUsuariosAsync(String idUsuario) async {
    try {
      var result = await _api.get(
        "api/appbackup/removerZonasUsuarios/$idUsuario"
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }

  Future<bool?> desbloquearCobranzasAdministradorAsync(List<Cobranzas> cobranzas) async {
    try {
      var result = await _api.post(
        "api/appbackup/desbloquearCobranzasAdministrador",
        cobranzas,
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }

  Future<bool?> agregarUsuarioAccionAsync(String idUsuario, String usuario, String accion) async {
    try {
      var result = await _api.get(
        "api/appbackup/agregarUsuarioAccion/$idUsuario/$usuario/$accion"
      );
      return result == Literals.apiTrue;
    } catch(e) {
      return null;
    }
  }
}