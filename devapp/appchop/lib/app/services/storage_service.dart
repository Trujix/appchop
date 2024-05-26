import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/app_backup/app_backup_data.dart';
import '../data/models/local_storage/local_storage.dart';
import '../utils/literals.dart';
import 'tool_service.dart';

class StorageService {
  Box? _storage;
  final ToolService _tool = Get.find<ToolService>();

  Future<void> init() async {
    try {
      await _openBox();
      var localStorage = LocalStorage.fromJson(get(LocalStorage()));
      var version = localStorage.version! != LocalStorage().version!;
      if(!localStorage.creado! || version) {
        var nuevoStorage = _nuevoLocalStorage(actual: localStorage);
        await _storage!.put(nuevoStorage!.tabla, jsonEncode(nuevoStorage));
      }
      return;
    } catch(e) {
      return;
    }
  }

  dynamic get(dynamic elem) {
    try {
      var jsonData = jsonDecode(jsonEncode(elem));
      var tabla = _tool.isArray(jsonData) ? jsonData[0]['tabla'] : jsonData['tabla'];
      var storage = _storage!.get(tabla);
      if(storage != null) {
        return jsonDecode(storage);
      }
      return jsonData;
    } catch(e) {
      return null;
    }
  }

  Future<bool> put(dynamic elem) async {
    try {
      var jsonData = jsonDecode(jsonEncode(elem));
      var isArray = _tool.isArray(jsonData);
      var tabla = isArray ? jsonData[0]['tabla'] : jsonData['tabla'];
      await _storage!.put(tabla, jsonEncode(isArray ? [] : elem));
      return true;
    } catch(e) {
      return false;
    }
  }

  Future<void> update<S>(dynamic elem) async {
    var tabla = "";
    try {
      var jsonData = jsonDecode(jsonEncode(elem));
      tabla = _tool.isArray(jsonData) ? jsonData[0]['tabla'] : jsonData['tabla'];
      await _storage!.delete(tabla);
      await _storage!.put(tabla, jsonEncode(elem));
      return;
    } catch(e) {
      return;
    }
  }

  Future<void> delete<S>(S clase) async {
    try {
      var jsonData = jsonDecode(jsonEncode(clase));
      var tabla = _tool.isArray(jsonData) ? jsonData[0]['tabla'] : jsonData['tabla'];
      await _storage!.delete(tabla);
      return;
    } catch(e) {
      return;
    }
  }

  bool verify(dynamic elem) {
    try {
      var jsonData = jsonDecode(jsonEncode(elem));
      var tabla = jsonData['tabla'];
      var storage = _storage!.get(tabla);
      return storage != null;
    } finally { }
  }

  Future<void> clearAll() async {
    try {
      await _storage!.deleteFromDisk();
    } finally { }
  }

  Future<void> backup(AppBackupData appBackupData) async {
    try {
      await update(appBackupData.cobranzas);
      await update(appBackupData.cargosAbonos);
      await update(appBackupData.notas);
      await update(appBackupData.clientes);
      await update(appBackupData.usuarios);
      await update(appBackupData.zonas);
      await update(appBackupData.zonasUsuarios);
      await update(appBackupData.inventarios);
    } finally { }
  }

  LocalStorage? _nuevoLocalStorage({
    LocalStorage? actual,
  }) {
    try {
      var nuevoStorage = LocalStorage();
      if(actual!.idDispositivo == "") {
        actual.idDispositivo = _tool.cadenaAleatoria(25);
      }
      if(!actual.creado!) {
        actual.creado = true;
      }
      Map<String, dynamic> nuevoStorageTemp = jsonDecode(jsonEncode(nuevoStorage));
      Map<String, dynamic> actualStorageTemp = jsonDecode(jsonEncode(actual));
      actualStorageTemp.forEach((key, value) {
        if(nuevoStorageTemp[key] != null) {
          nuevoStorageTemp[key] = value;
        }
      });
      var storageString = jsonEncode(nuevoStorageTemp);
      return LocalStorage.fromString(storageString);
    } catch(e) {
      return null;
    }
  }

  Future<void> change(String tabla) async {
    try {
      if(tabla == "local_storage") {
        return;
      }
      var localStorage = LocalStorage.fromJson(get(LocalStorage()));
      if(localStorage.change) {
        return;
      }
      localStorage.change = true;
      await _storage!.delete(localStorage.tabla);
      await _storage!.put(localStorage.tabla, jsonEncode(localStorage));
    } finally { }
  }

  Future<void> _openBox() async {
    try {
      var directorio = await getApplicationDocumentsDirectory();
      Hive.init(directorio.path);
      await Hive.openBox(Literals.storageBoxName);
      _storage = Hive.box(Literals.storageBoxName);
      return;
    } catch(e) { return; }
  }
}