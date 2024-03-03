import 'dart:convert';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ToolService extends GetxController {
  String guid() {
    const uuid = Uuid();
    var newGuid = uuid.v4();
    return newGuid;
  }

  bool isObject(dynamic data) {
    return isJson(data) || isArray(data) || isJsonArray(data);
  }

  bool isJson(dynamic elemento) {
    try {
      var jsonCadena = jsonEncode(elemento);
      return jsonCadena[jsonCadena.length - 1] == "}";
    } catch(e) {
      return false;
    }
  }

  bool isArray(dynamic elemento) {
    try {
      var jsonCadena = jsonEncode(elemento);
      return jsonCadena[jsonCadena.length -1] == "]";
    } catch(e) {
      return false;
    }
  }

  bool isJsonArray(dynamic data) {
    try {
      var cadAux = jsonEncode(data);
      var cadJson = cadAux[cadAux.length - 2] + cadAux[cadAux.length - 1];
      return cadJson == "}]";
    } catch(e) {
      return false;
    }
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  bool str2bool(String cadena) {
    return cadena.toLowerCase() == 'true';
  }

  double str2double(String cadena) {
    return double.tryParse(cadena) ?? 0.0;
  }

  int str2int(String cadena) {
    return int.tryParse(cadena) ?? 0;
  }

  Future<void> wait([int segundos = 2]) async {
    await Future.delayed(Duration(seconds: segundos));
    return;
  }
}