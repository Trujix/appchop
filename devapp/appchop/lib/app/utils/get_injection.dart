import 'package:get/get.dart';

import '../data/models/app_backup/app_backup_data.dart';
import '../data/models/local_storage/borrados.dart';
import '../data/models/local_storage/cargos_abonos.dart';
import '../data/models/local_storage/clientes.dart';
import '../data/models/local_storage/cobranzas.dart';
import '../data/models/local_storage/configuracion.dart';
import '../data/models/local_storage/inventarios.dart';
import '../data/models/local_storage/local_storage.dart';
import '../data/models/local_storage/notas.dart';
import '../data/models/local_storage/usuarios.dart';
import '../data/models/local_storage/zonas.dart';
import '../data/models/local_storage/zonas_usuarios.dart';
import '../data/repositories/app_backup_repository.dart';
import '../data/repositories/cobradores_repository.dart';
import '../data/repositories/configuracion_repository.dart';
import '../data/repositories/firebase_repository.dart';
import '../data/repositories/login_repository.dart';
import '../data/repositories/usuarios_repository.dart';
import '../services/api_service.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';
import '../services/tool_service.dart';
import 'literals.dart';

abstract class GetInjection extends GetxController {
  final storage = Get.find<StorageService>();
  final firebase = Get.find<FirebaseService>();
  final tool = Get.find<ToolService>();
  final api = Get.find<ApiService>();

  final loginRepository = Get.find<LoginRepository>();
  final configuracionRepository = Get.find<ConfiguracionRepository>();
  final cobradoresRepository = Get.find<CobradoresRepository>();
  final firebaseRepository = Get.find<FirebaseRepository>();
  final usuariosRepository = Get.find<UsuariosRepository>();
  final appBackupRepository = Get.find<AppBackupRepository>();

  static bool administrador = false;
  static String perfil = "";

  Future<void> localStorageClassInit() async {
    await Zonas.init();
    await Clientes.init();
    await Cobranzas.init();
    await Notas.init();
    await CargosAbonos.init();
    await Usuarios.init();
    await Inventarios.init();
    await ZonasUsuarios.init();
    await Configuracion.init();
    await Borrados.init();
    return;
  }

  AppBackupData createAppBackupData() {
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    var cobranzas = List<Cobranzas>.from(
      storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
    );
    var cargosAbonos = List<CargosAbonos>.from(
      storage.get([CargosAbonos()]).map((json) => CargosAbonos.fromJson(json))
    );
    var notas = List<Notas>.from(
      storage.get([Notas()]).map((json) => Notas.fromJson(json))
    );
    var clientes = List<Clientes>.from(
      storage.get([Clientes()]).map((json) => Clientes.fromJson(json))
    );
    var usuarios = List<Usuarios>.from(
      storage.get([Usuarios()]).map((json) => Usuarios.fromJson(json))
    );
    var zonas = List<Zonas>.from(
      storage.get([Zonas()]).map((json) => Zonas.fromJson(json))
    );
    var zonasUsuarios = List<ZonasUsuarios>.from(
      storage.get([ZonasUsuarios()]).map((json) => ZonasUsuarios.fromJson(json))
    );
    var inventarios = List<Inventarios>.from(
      storage.get([Inventarios()]).map((json) => Inventarios.fromJson(json))
    );
    var backupData = AppBackupData(
      idUsuario: localStorage.idUsuario,
      usuarioEnvia: administrador ? Literals.perfilAdministrador : localStorage.email,
      cobranzas: cobranzas,
      cargosAbonos: cargosAbonos,
      notas: notas,
      clientes: clientes,
      usuarios: usuarios,
      zonas: zonas,
      zonasUsuarios: zonasUsuarios,
      inventarios: inventarios,
    );
    return backupData;
  }
}