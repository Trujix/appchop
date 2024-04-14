import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class Zonas {
  String? tabla = "zonas";
  String? idUsuario;
  String? idZona;
  String? valueZona;
  String? labelZona;
  String? fechaCreacion;
  bool? activo;

  Zonas({
    this.idUsuario = "",
    this.idZona = "",
    this.valueZona = "",
    this.labelZona = "",
    this.fechaCreacion = "",
    this.activo = true,
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Zonas());
      if(!verify) {
        var _ = await storage.put([Zonas()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'           : tabla,
    'idUsuario'       : idUsuario,
    'idZona'          : idZona,
    'valueZona'       : valueZona,
    'labelZona'       : labelZona,
    'fechaCreacion'   : fechaCreacion,
    'activo'          : activo,
  };

  factory Zonas.fromJson(Map<String, dynamic> json) => Zonas(
    idUsuario: json['idUsuario'] ?? "",
    idZona: json['idZona'] ?? "",
    valueZona: json['valueZona'] ?? "",
    labelZona: json['labelZona'] ?? "",
    fechaCreacion: json['fechaCreacion'] ?? "",
    activo: json['activo'] ?? false,
  );
}