import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class Notas {
  String? tabla = "notas";
  String? idUsuario;
  String? idNota;
  String? idCobranza;
  String? nota;
  String? usuarioCrea;
  String? usuarioVisto;
  String? fechaCrea;

  Notas({
    this.idUsuario = "",
    this.idNota = "",
    this.idCobranza = "",
    this.nota = "",
    this.usuarioCrea = "",
    this.usuarioVisto = "",
    this.fechaCrea = "",
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Notas());
      if(!verify) {
        var _ = await storage.put([Notas()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'           : tabla,
    'idUsuario'       : idUsuario,
    'idNota'          : idNota,
    'idCobranza'      : idCobranza,
    'nota'            : nota,
    'usuarioCrea'     : usuarioCrea,
    'usuarioVisto'    : usuarioVisto,
    'fechaCrea'       : fechaCrea,
  };

  factory Notas.fromJson(Map<String, dynamic> json) => Notas(
    idUsuario: json['idUsuario'] ?? "",
    idNota: json['idNota'] ?? "",
    idCobranza: json['idCobranza'] ?? "",
    nota: json['nota'] ?? "",
    usuarioCrea: json['usuarioCrea'] ?? "",
    usuarioVisto: json['usuarioVisto'] ?? "",
    fechaCrea: json['fechaCrea'] ?? "",
  );
}