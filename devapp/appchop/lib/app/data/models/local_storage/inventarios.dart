import 'package:get/get.dart';

import '../../../services/storage_service.dart';
import '../../../services/tool_service.dart';

class Inventarios {
  String? tabla = "inventarios";
  String? idUsuario;
  String? idArticulo;
  String? codigoArticulo;
  String? descripcion;
  String? marca;
  String? talla;
  double? precioCompra;
  double? precioVenta;
  double? existencia;
  double? maximo;
  double? minimo;
  String? fechaCambio;
  String? usuario;

  Inventarios({
    this.idUsuario = "",
    this.idArticulo = "",
    this.codigoArticulo = "",
    this.descripcion = "",
    this.marca = "",
    this.talla = "",
    this.precioCompra = 0.0,
    this.precioVenta = 0.0,
    this.existencia = 0.0,
    this.maximo = 0.0,
    this.minimo = 0.0,
    this.fechaCambio = "",
    this.usuario = "",
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
    'idArticulo'      : idArticulo,
    'codigoArticulo'  : codigoArticulo,
    'descripcion'     : descripcion,
    'marca'           : marca,
    'talla'           : talla,
    'precioCompra'    : precioCompra,
    'precioVenta'     : precioVenta,
    'existencia'      : existencia,
    'maximo'          : maximo,
    'minimo'          : minimo,
    'fechaCambio'     : fechaCambio,
    'usuario'         : usuario,
  };

  factory Inventarios.fromJson(Map<String, dynamic> json) => Inventarios(
    idUsuario: json['idUsuario'] ?? "",
    idArticulo: json['idArticulo'] ?? "",
    codigoArticulo: json['codigoArticulo'] ?? "",
    descripcion: json['descripcion'] ?? "",
    marca: json['marca'] ?? "",
    talla: json['talla'] ?? "",
    precioCompra: Get.find<ToolService>().str2double(json['precioCompra'].toString()),
    precioVenta: Get.find<ToolService>().str2double(json['precioVenta'].toString()),
    existencia: Get.find<ToolService>().str2double(json['existencia'].toString()),
    maximo: Get.find<ToolService>().str2double(json['maximo'].toString()),
    minimo: Get.find<ToolService>().str2double(json['minimo'].toString()),
    fechaCambio: json['fechaCambio'] ?? "",
    usuario: json['usuario'] ?? "",
  );
}