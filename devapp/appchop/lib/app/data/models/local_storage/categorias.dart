import 'package:get/get.dart';

import '../../../services/storage_service.dart';

class Categorias {
  String? tabla = "categorias";
  String? idUsuario;
  String? idCategoria;
  String? valueCategoria;
  String? labelCategoria;
  String? fechaCreacion;

  Categorias({
    this.idUsuario = "",
    this.idCategoria = "",
    this.valueCategoria = "",
    this.labelCategoria = "",
    this.fechaCreacion = "",
  });

  static void init() {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Categorias());
      if(!verify) {
        storage.put([Categorias()]);
      }
    } finally { }
  }

  Map toJson() => {
    'tabla'           : tabla,
    'idUsuario'       : idUsuario,
    'idCategoria'     : idCategoria,
    'valueCategoria'  : valueCategoria,
    'labelCategoria'  : labelCategoria,
    'fechaCreacion'   : fechaCreacion,
  };

  factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
    idUsuario: json['idUsuario'] ?? "",
    idCategoria: json['idCategoria'] ?? "",
    valueCategoria: json['valueCategoria'] ?? "",
    labelCategoria: json['labelCategoria'] ?? "",
    fechaCreacion: json['fechaCreacion'] ?? "",
  );
}