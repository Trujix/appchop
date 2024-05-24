import 'package:get/get.dart';

import '../../../services/storage_service.dart';
import '../../../services/tool_service.dart';
import '../../../utils/literals.dart';

class CargosAbonos {
  String? tabla = "cargos_abonos";
  String? idUsuario;
  String? idCobranza;
  String? idMovimiento;
  String? tipo;
  double? monto;
  String? referencia;
  String? usuarioRegistro;
  String? fechaRegistro;
  String? genera = Literals.cargoAbonoManual;

  CargosAbonos({
    this.idUsuario = "",
    this.idCobranza = "",
    this.idMovimiento = "",
    this.tipo = "",
    this.monto = 0.0,
    this.referencia = "",
    this.usuarioRegistro = "",
    this.fechaRegistro = "",
    this.genera = Literals.cargoAbonoManual,
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(CargosAbonos());
      if(!verify) {
        var _ = await storage.put([CargosAbonos()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'           : tabla,
    'idUsuario'       : idUsuario,
    'idCobranza'      : idCobranza,
    'idMovimiento'    : idMovimiento,
    'tipo'            : tipo,
    'monto'           : monto,
    'referencia'      : referencia,
    'usuarioRegistro' : usuarioRegistro,
    'fechaRegistro'   : fechaRegistro,
    'genera'          : genera,
  };

  factory CargosAbonos.fromJson(Map<String, dynamic> json) => CargosAbonos(
    idUsuario: json['idUsuario'] ?? "",
    idCobranza: json['idCobranza'] ?? "",
    idMovimiento: json['idMovimiento'] ?? "",
    tipo: json['tipo'] ?? "",
    monto: Get.find<ToolService>().str2double(json['monto'].toString()),
    referencia: json['referencia'] ?? "",
    usuarioRegistro: json['usuarioRegistro'] ?? "",
    fechaRegistro: json['fechaRegistro'] ?? "",
    genera: json['genera'] ?? Literals.cargoAbonoManual,
  );
}