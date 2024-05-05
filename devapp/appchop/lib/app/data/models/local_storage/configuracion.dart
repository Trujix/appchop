import 'package:get/get.dart';

import '../../../services/storage_service.dart';
import '../../../services/tool_service.dart';

class Configuracion {
  final ToolService _tool = Get.find<ToolService>();
  String? tabla = "configuracion";
  String? idUsuario;
  double? porcentajeBonificacion;
  double? porcentajeMoratorio;

  Configuracion({
    this.idUsuario = "",
    this.porcentajeBonificacion = 0,
    this.porcentajeMoratorio = 0,
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Configuracion());
      if(!verify) {
        var _ = await storage.put([Configuracion()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'                     : tabla,
    'idUsuario'                 : idUsuario,
    'porcentajeBonificacion'    : porcentajeBonificacion,
    'porcentajeMoratorio'       : porcentajeMoratorio,
  };

  Configuracion.fromApi(Map<String, dynamic> json) {
    idUsuario = json['id_sistema'].toString();
    porcentajeBonificacion = _tool.str2double(json['porcentajeBonificacion'].toString());
    porcentajeMoratorio = _tool.str2double(json['porcentajeMoratorio'].toString());
  }

  factory Configuracion.fromJson(Map<String, dynamic> json) => Configuracion(
    idUsuario: json['idUsuario'] ?? "",
    porcentajeBonificacion: json['porcentajeBonificacion'] ?? 0,
    porcentajeMoratorio: json['porcentajeMoratorio'] ?? 0,
  );
}