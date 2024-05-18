import 'dart:convert';

import '../local_storage/borrados.dart';
import '../local_storage/cargos_abonos.dart';
import '../local_storage/clientes.dart';
import '../local_storage/cobranzas.dart';
import '../local_storage/inventarios.dart';
import '../local_storage/notas.dart';
import '../local_storage/usuarios.dart';
import '../local_storage/zonas.dart';
import '../local_storage/zonas_usuarios.dart';

class AppBackupData {
  String? usuarioEnvia;
  List<Cobranzas>? cobranzas;
  List<CargosAbonos>? cargosAbonos;
  List<Notas>? notas;
  List<Clientes>? clientes;
  List<Inventarios>? inventarios;
  List<Borrados>? borrados;
  List<Usuarios>? usuarios;
  List<Zonas>? zonas;
  List<ZonasUsuarios>? zonasUsuarios;

  AppBackupData({
    this.usuarioEnvia = "",
    this.cobranzas = const [],
    this.cargosAbonos = const [],
    this.notas = const [],
    this.clientes = const [],
    this.inventarios = const [],
    this.borrados = const [],
    this.usuarios = const [],
    this.zonas = const [],
    this.zonasUsuarios = const [],
  });

  Map toJson() => {
    'usuarioEnvia'      : usuarioEnvia,
    'cobranzas'         : cobranzas,
    'cargosAbonos'      : cargosAbonos,
    'notas'             : notas,
    'clientes'          : clientes,
    'inventarios'       : inventarios,
    'borrados'          : borrados,
    'usuarios'          : usuarios,
    'zonas'             : zonas,
    'zonasUsuarios'     : zonasUsuarios,
  };

  AppBackupData.fromApi(Map<String, dynamic> json) {
    usuarioEnvia = json['usuarioEnvia'] ?? "";
    Iterable iterableCobranzas = jsonDecode(jsonEncode(json['cobranzas'] ?? []));
    Iterable iterableCargosAbonos = jsonDecode(jsonEncode(json['cargosAbonos'] ?? []));
    Iterable iterableNotas = jsonDecode(jsonEncode(json['notas'] ?? []));
    Iterable iterableClientes = jsonDecode(jsonEncode(json['clientes'] ?? []));
    Iterable iterableInventarios = jsonDecode(jsonEncode(json['inventarios'] ?? []));
    Iterable iterableBorrados = jsonDecode(jsonEncode(json['borrados'] ?? []));
    Iterable iterableUsuarios = jsonDecode(jsonEncode(json['usuarios'] ?? []));
    Iterable iterableZonas = jsonDecode(jsonEncode(json['zonas'] ?? []));
    Iterable iterableZonasUsuarios = jsonDecode(jsonEncode(json['zonasUsuarios'] ?? []));
    cobranzas = List<Cobranzas>.from(
      iterableCobranzas.map((json) => Cobranzas.fromJson(json))
    );
    cargosAbonos = List<CargosAbonos>.from(
      iterableCargosAbonos.map((json) => CargosAbonos.fromJson(json))
    );
    notas = List<Notas>.from(
      iterableNotas.map((json) => Notas.fromJson(json))
    );
    clientes = List<Clientes>.from(
      iterableClientes.map((json) => Clientes.fromJson(json))
    );
    inventarios = List<Inventarios>.from(
      iterableInventarios.map((json) => Inventarios.fromJson(json))
    );
    borrados = List<Borrados>.from(
      iterableBorrados.map((json) => Borrados.fromJson(json))
    );
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