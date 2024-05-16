import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class Borrados {
  String? tabla = "borrados";
  String? idUsuario;
  String? idElemento;
  String? idAuxiliar;

  Borrados({
    this.idUsuario = "",
    this.idElemento = "",
    this.idAuxiliar = "",
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Borrados());
      if(!verify) {
        var _ = await storage.put([Borrados()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'           : tabla,
    'idUsuario'       : idUsuario,
    'idElemento'      : idElemento,
    'idAuxiliar'      : idAuxiliar,
  };

  factory Borrados.fromJson(Map<String, dynamic> json) => Borrados(
    idUsuario: json['idUsuario'] ?? "",
    idElemento: json['idElemento'] ?? "",
    idAuxiliar: json['idAuxiliar'] ?? "",
  );
}