import 'package:get/get.dart';

import '../models/app_backup/app_backup_data.dart';
import '../models/app_backup/app_backup_info.dart';
import '../models/local_storage/cobranzas.dart';
import '../models/local_storage/zonas.dart';
import '../models/local_storage/zonas_usuarios.dart';
import '../providers/app_backup_provider.dart';

class AppBackupRepository {
  Future<AppBackupData?> sincronizarAsync(AppBackupData backupInfo) async {
    return await Get.find<AppBackupProvider>().sincronizarAsync(backupInfo);
  }

  Future<AppBackupInfo?> verificarBackupAsync(String idUsuario) async {
    return await Get.find<AppBackupProvider>().verificarBackupAsync(idUsuario);
  }

  Future<AppBackupData?> descargarAsync(String idUsuario, String usuario) async {
    return await Get.find<AppBackupProvider>().descargarAsync(idUsuario, usuario);
  }

  Future<bool?> backupZonasAsync(List<Zonas> zonas) async {
    return await Get.find<AppBackupProvider>().backupZonasAsync(zonas);
  }

  Future<bool?> backupZonasUsuariosAsync(List<ZonasUsuarios> zonasUsuarios) async {
    return await Get.find<AppBackupProvider>().backupZonasUsuariosAsync(zonasUsuarios);
  }

  Future<bool?> removerZonasUsuariosAsync(String idUsuario) async {
    return await Get.find<AppBackupProvider>().removerZonasUsuariosAsync(idUsuario);
  }

  Future<bool?> desbloquearCobranzasAdministradorAsync(List<Cobranzas> cobranzas) async {
    return await Get.find<AppBackupProvider>().desbloquearCobranzasAdministradorAsync(cobranzas);
  }

  Future<bool?> agregarUsuarioAccionAsync(String idUsuario, String usuario, String accion) async {
    return await Get.find<AppBackupProvider>().agregarUsuarioAccionAsync(idUsuario, usuario, accion);
  }

  Future<bool?> eliminarCargoAbonoAsync(String idUsuario, String idCobranza, String idMovimiento) async {
    return await Get.find<AppBackupProvider>().eliminarCargoAbonoAsync(idUsuario, idCobranza, idMovimiento);
  }
}