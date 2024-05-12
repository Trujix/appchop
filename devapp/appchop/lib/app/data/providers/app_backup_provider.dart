import 'dart:convert';

import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../utils/literals.dart';
import '../models/app_backup/app_backup_data.dart';
import '../models/local_storage/zonas.dart';
import '../models/local_storage/zonas_usuarios.dart';

class AppBackupProvider {
  final ApiService _api = Get.find<ApiService>();

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
}