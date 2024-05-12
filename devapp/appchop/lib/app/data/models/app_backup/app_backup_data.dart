import 'dart:convert';

import '../local_storage/usuarios.dart';
import '../local_storage/zonas.dart';
import '../local_storage/zonas_usuarios.dart';

class AppBackupData {
  List<Usuarios>? usuarios;
  List<Zonas>? zonas;
  List<ZonasUsuarios>? zonasUsuarios;

  AppBackupData({
    this.usuarios = const [],
    this.zonas = const [],
    this.zonasUsuarios = const [],
  });

  Map toJson() => {
    'usuarios'          : usuarios,
    'zonas'             : zonas,
    'zonasUsuarios'     : zonasUsuarios,
  };

  AppBackupData.fromApi(Map<String, dynamic> json) {
    Iterable iterableUsuarios = jsonDecode(jsonEncode(json['usuarios']));
    Iterable iterableZonas = jsonDecode(jsonEncode(json['zonas']));
    Iterable iterableZonasUsuarios = jsonDecode(jsonEncode(json['zonasUsuarios']));
    usuarios = List<Usuarios>.from(
      iterableUsuarios.map((json) => Usuarios.fromJson(json))
    );
    zonas = List<Zonas>.from(
      iterableZonas.map((json) => Zonas.fromJson(json))
    );
    zonasUsuarios = List<ZonasUsuarios>.from(
      iterableZonasUsuarios.map((json) => ZonasUsuarios.fromJson(json))
    );
  }
}