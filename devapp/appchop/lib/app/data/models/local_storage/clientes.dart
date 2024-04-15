import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class Clientes {
  String? tabla = "clientes";
  String? idUsuario;
  String? idCliente;
  String? nombre;
  String? telefono;
  String? fechaCreacion;
  bool? activo;

  Clientes({
    this.idUsuario = "",
    this.idCliente = "",
    this.nombre = "",
    this.telefono = "",
    this.fechaCreacion = "",
    this.activo = true,
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Clientes());
      if(!verify) {
        var _ = await storage.put([Clientes()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'         : tabla,
    'idUsuario'     : idUsuario,
    'idCliente'     : idCliente,
    'nombre'        : nombre,
    'telefono'      : telefono,
    'fechaCreacion' : fechaCreacion,
    'activo'        : activo,
  };

  factory Clientes.fromJson(Map<String, dynamic> json) => Clientes(
    idUsuario: json['idUsuario'] ?? "",
    idCliente: json['idCliente'] ?? "",
    nombre: json['nombre'] ?? "",
    telefono: json['telefono'] ?? "",
    fechaCreacion: json['fechaCreacion'] ?? "",
    activo: json['activo'] ?? false,
  );
}