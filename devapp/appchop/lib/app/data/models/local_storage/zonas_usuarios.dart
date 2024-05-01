import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class ZonasUsuarios {
  String? tabla = "zonasusuarios";
  String? idUsuario;
  String? idZona;
  String? usuario;

  ZonasUsuarios({
    this.idUsuario = "",
    this.idZona = "",
    this.usuario = "",
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(ZonasUsuarios());
      if(!verify) {
        var _ = await storage.put([ZonasUsuarios()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'           : tabla,
    'idUsuario'       : idUsuario,
    'idZona'          : idZona,
    'usuario'         : usuario,
  };

  factory ZonasUsuarios.fromJson(Map<String, dynamic> json) => ZonasUsuarios(
    idUsuario: json['idUsuario'] ?? "",
    idZona: json['idZona'] ?? "",
    usuario: json['usuario'] ?? "",
  );
}