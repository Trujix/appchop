import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class Cobranzas {
  String? tabla = "cobranzas";
  String? idUsuario;
  String? idCobranza;
  String? tipoCobranza;
  String? categoria;
  String? nombre;
  double? cantidad;
  String? descripcion;
  String? telefono;
  String? direccion;
  String? correo;
  String? fechaRegistro;
  String? fechaVencimiento;
  String? latitud;
  String? longitud;
  String? idCobrador;

  Cobranzas({
    this.idUsuario = "",
    this.idCobranza = "",
    this.tipoCobranza = "",
    this.categoria = "",
    this.nombre = "",
    this.cantidad = 0.0,
    this.descripcion = "",
    this.telefono = "",
    this.direccion = "",
    this.correo = "",
    this.fechaRegistro = "",
    this.fechaVencimiento = "",
    this.latitud = "",
    this.longitud = "",
    this.idCobrador = "",
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Cobranzas());
      if(!verify) {
        var _ = await storage.put([Cobranzas()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'             : tabla,
    'idUsuario'         : idUsuario,
    'idCobranza'        : idCobranza,
    'tipoCobranza'      : tipoCobranza,
    'categoria'         : categoria,
    'nombre'            : nombre,
    'cantidad'          : cantidad,
    'descripcion'       : descripcion,
    'telefono'          : telefono,
    'direccion'         : direccion,
    'correo'            : correo,
    'fechaRegistro'     : fechaRegistro,
    'fechaVencimiento'  : fechaVencimiento,
    'latitud'           : latitud,
    'longitud'          : longitud,
    'idCobrador'        : idCobrador,
  };

  factory Cobranzas.fromJson(Map<String, dynamic> json) => Cobranzas(
    idUsuario: json['idUsuario'] ?? "",
    idCobranza: json['idCobranza'] ?? "",
    tipoCobranza: json['tipoCobranza'] ?? "",
    categoria: json['categoria'] ?? "",
    nombre: json['nombre'] ?? "",
    cantidad: json['cantidad'] ?? 0.0,
    descripcion: json['descripcion'] ?? "",
    telefono: json['telefono'] ?? "",
    direccion: json['direccion'] ?? "",
    correo: json['correo'] ?? "",
    fechaRegistro: json['fechaRegistro'] ?? "",
    fechaVencimiento: json['fechaVencimiento'] ?? "",
    latitud: json['latitud'] ?? "",
    longitud: json['longitud'] ?? "",
    idCobrador: json['idCobrador'] ?? "",
  );
}