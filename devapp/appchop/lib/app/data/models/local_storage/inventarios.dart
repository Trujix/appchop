import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class Inventarios {
  String? tabla = "inventarios";
  String? idUsuario;
  String? codigoArticulo;
  String? descripcion;
  double? precioCompra;
  double? precioVenta;
  double? existencia;
  double? maximo;
  double? minimo;
  String? fechaCambio;

  Inventarios({
    this.idUsuario = "",
    this.codigoArticulo = "",
    this.descripcion = "",
    this.precioCompra = 0.0,
    this.precioVenta = 0.0,
    this.existencia = 0.0,
    this.maximo = 0.0,
    this.minimo = 0.0,
    this.fechaCambio = "",
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Inventarios());
      if(!verify) {
        var _ = await storage.put([Inventarios()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'           : tabla,
    'idUsuario'       : idUsuario,
    'codigoArticulo'  : codigoArticulo,
    'descripcion'     : descripcion,
    'precioCompra'    : precioCompra,
    'precioVenta'     : precioVenta,
    'existencia'      : existencia,
    'maximo'          : maximo,
    'minimo'          : minimo,
    'fechaCambio'     : fechaCambio,
  };

  factory Inventarios.fromJson(Map<String, dynamic> json) => Inventarios(
    idUsuario: json['idUsuario'] ?? "",
    codigoArticulo: json['codigoArticulo'] ?? "",
    descripcion: json['descripcion'] ?? "",
    precioCompra: json['precioCompra'] ?? 0.0,
    precioVenta: json['precioVenta'] ?? 0.0,
    existencia: json['existencia'] ?? 0.0,
    maximo: json['maximo'] ?? 0.0,
    minimo: json['minimo'] ?? 0.0,
    fechaCambio: json['fechaCambio'] ?? "",
  );
}