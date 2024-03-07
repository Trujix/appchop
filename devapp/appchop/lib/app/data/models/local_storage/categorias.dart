import 'dart:convert';

import 'package:get/get.dart';

import '../../../services/storage_service.dart';
import '../../../services/tool_service.dart';
import 'local_storage.dart';

class Categorias {
  final StorageService _storage = Get.find<StorageService>();
  final ToolService _tool = Get.find<ToolService>();
  
  String? tabla = "categorias";
  String? idUsuario;
  String? idCategoria;
  String? valueCategoria;
  String? labelCategoria;
  String? fechaCreacion;
  bool? creado;

  Categorias({
    this.idUsuario = "",
    this.idCategoria = "",
    this.valueCategoria = "",
    this.labelCategoria = "",
    this.fechaCreacion = "",
    this.creado = true,
  });

  static void init() {
    try {
      var localStorage = LocalStorage.fromJson(Categorias()._storage.get(LocalStorage()));
      var categoriaStorage = List<Categorias>.from(
        Categorias()._storage.get([Categorias()]).map((json) => Categorias.fromJson(json))
      );
      print(jsonEncode(categoriaStorage));
      if(!categoriaStorage[0].creado!) {
        var categoriaDefault = Categorias(
          
        );
        Categorias()._storage.put([]);
      }
    } catch(e) {
      return;
    }
  }

  Map toJson() => {
    'tabla'           : tabla,
    'idUsuario'       : idUsuario,
    'idCategoria'     : idCategoria,
    'valueCategoria'  : valueCategoria,
    'labelCategoria'  : labelCategoria,
    'fechaCreacion'   : fechaCreacion,
    'creado'          : creado,
  };

  factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
    idUsuario: json['nombres'] ?? "",
    idCategoria: json['apellidos'] ?? "",
    valueCategoria: json['password'] ?? "",
    labelCategoria: json['email'] ?? "",
    fechaCreacion: json['token'] ?? "",
    creado: json['creado'] ?? false,
  );
}