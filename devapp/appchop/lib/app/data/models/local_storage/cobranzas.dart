import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class Cobranzas {
  String? tabla = "cobranzas";
  String? idUsuario;
  String? idCobranza;
  String? categoria;
  String? nombre;
  double? cantidad;
  String? descripcion;
  String? telefono;
  String? direccion;
  String? correo;
  String? fechaRegistro;
  String? fechaVencimiento;
  String? idCobrador;

  Cobranzas({
    this.idUsuario = "",
    this.idCobranza = "",
    this.categoria = "",
    this.nombre = "",
    this.cantidad = 0.0,
    this.descripcion = "",
    this.telefono = "",
    this.direccion = "",
    this.correo = "",
    this.fechaRegistro = "",
    this.fechaVencimiento = "",
    this.idCobrador = "",
  });

  static void init() {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Cobranzas());
      if(!verify) {
        storage.put([Cobranzas()]);
      }
    } finally { }
  }

  Map toJson() => {
    'tabla'             : tabla,
    'idUsuario'         : idUsuario,
    'idCobranza'        : idCobranza,
    'categoria'         : categoria,
    'nombre'            : nombre,
    'cantidad'          : cantidad,
    'descripcion'       : descripcion,
    'telefono'          : telefono,
    'direccion'         : direccion,
    'correo'            : correo,
    'fechaRegistro'     : fechaRegistro,
    'fechaVencimiento'  : fechaVencimiento,
    'idCobrador'        : idCobrador,
  };

  factory Cobranzas.fromJson(Map<String, dynamic> json) => Cobranzas(
    idUsuario: json['idUsuario'] ?? "",
    idCobranza: json['idCobranza'] ?? "",
    categoria: json['categoria'] ?? "",
    nombre: json['nombre'] ?? "",
    cantidad: json['cantidad'] ?? 0.0,
    descripcion: json['descripcion'] ?? "",
    telefono: json['telefono'] ?? "",
    direccion: json['direccion'] ?? "",
    correo: json['correo'] ?? "",
    fechaRegistro: json['fechaRegistro'] ?? "",
    fechaVencimiento: json['fechaVencimiento'] ?? "",
    idCobrador: json['idCobrador'] ?? "",
  );
}