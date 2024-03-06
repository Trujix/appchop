import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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
      print(jsonEncode(localStorage));
      var version = localStorage.version! != LocalStorage().version!;
      if(!localStorage.init! || version) {
        var nuevoStorage = _nuevoLocalStorage(actual: localStorage);
        _storage!.put(nuevoStorage!.tabla, jsonEncode(nuevoStorage));
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
      if(storage == null) {
        return jsonData;
      }
      return jsonDecode(storage);
    } catch(e) {
      return null;
    }
  }

  Future<void> update<S>(dynamic elem) async {
    try {
      var jsonData = jsonDecode(jsonEncode(elem));
      var tabla = _tool.isArray(jsonData) ? jsonData[0]['tabla'] : jsonData['tabla'];
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

  LocalStorage? _nuevoLocalStorage({
    bool nuevo = true,
    LocalStorage? actual,
  }) {
    try {
      var nuevoStorage = LocalStorage();
      nuevoStorage.init = true;
      var version = actual != null ? actual.version == nuevoStorage.version! : true;
      if(nuevo && version) {
        return nuevoStorage;
      } else {
        Map<String, dynamic> nuevoStorageTemp = jsonDecode(jsonEncode(nuevoStorage));
        Map<String, dynamic> actualStorageTemp = jsonDecode(jsonEncode(actual));
        actualStorageTemp.forEach((key, value) {
          if(nuevoStorageTemp[key] != null) {
            nuevoStorageTemp[key] = value;
          }
        });
        var storageString = jsonEncode(nuevoStorageTemp);
        return LocalStorage.fromString(storageString);
      }
    } catch(e) {
      return null;
    }
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