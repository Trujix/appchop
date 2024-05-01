import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class Usuarios {
  String? tabla = "usuarios";
  String? idUsuario;
  String? usuario;
  String? password;
  String? nombres;
  String? apellidos;
  bool? activo;

  Usuarios({
    this.idUsuario = "",
    this.usuario = "",
    this.password = "",
    this.nombres = "",
    this.apellidos = "",
    this.activo = true,
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Usuarios());
      if(!verify) {
        var _ = await storage.put([Usuarios()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'       : tabla,
    'idUsuario'   : idUsuario,
    'usuario'     : usuario,
    'password'    : password,
    'nombres'     : nombres,
    'apellidos'   : apellidos,
    'activo'      : activo,
  };

  factory Usuarios.fromJson(Map<String, dynamic> json) => Usuarios(
    idUsuario: json['idUsuario'] ?? "",
    usuario: json['usuario'] ?? "",
    password: json['password'] ?? "",
    nombres: json['nombres'] ?? "",
    apellidos: json['apellidos'] ?? "",
    activo: json['activo'] ?? false,
  );
}