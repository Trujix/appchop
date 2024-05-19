import 'dart:convert';

import '../../../utils/literals.dart';

class LocalStorage {
  static const int _localStorageVersion = 1;

  String? tabla = "local_storage";
  int? version = _localStorageVersion;
  bool? login;
  String? idUsuario;
  String? nombres;
  String? apellidos;
  String? password;
  String? email;
  String? perfil;
  String? token;
  bool? activo;
  String? idFirebase;
  String? idDispositivo;
  int? acepta;
  bool? creado = false;
  bool? backupInicial = false;
  String? idBackup;
  String? fechaBackup;

  LocalStorage({
    this.version = _localStorageVersion,
    this.login = false,
    this.idUsuario = "",
    this.nombres = "",
    this.apellidos = "",
    this.password = "",
    this.email = "",
    this.perfil = "",
    this.token = "-",
    this.activo = true,
    this.idFirebase = "",
    this.idDispositivo = "",
    this.acepta = 0,
    this.creado = false,
    this.backupInicial = false,
    this.idBackup = Literals.backUpClean,
    this.fechaBackup = "",
  });

  Map toJson() => {
    'tabla'             : tabla,
    'version'           : version,
    'login'             : login,
    'idUsuario'         : idUsuario,
    'nombres'           : nombres,
    'apellidos'         : apellidos,
    'password'          : password,
    'email'             : email,
    'perfil'            : perfil,
    'token'             : token,
    'activo'            : activo,
    'idFirebase'        : idFirebase,
    'idDispositivo'     : idDispositivo,
    'acepta'            : acepta,
    'creado'            : creado,
    'backupInicial'     : backupInicial,
    'idBackup'          : idBackup,
    'fechaBackup'       : fechaBackup,
  };
  
  Map<String, dynamic> toMap() {
    return {
      'tabla'             : tabla,
      'version'           : version,
      'login'             : login,
      'idUsuario'         : idUsuario,
      'nombres'           : nombres,
      'apellidos'         : apellidos,
      'password'          : password,
      'email'             : email,
      'perfil'            : perfil,
      'token'             : token,
      'activo'            : activo,
      'idFirebase'        : idFirebase,
      'idDispositivo'     : idDispositivo,
      'acepta'            : acepta,
      'creado'            : creado,
      'backupInicial'     : backupInicial,
      'idBackup'          : idBackup,
      'fechaBackup'       : fechaBackup,
    };
  }

  LocalStorage.fromString(String jsonString) {
    var json = jsonDecode(jsonString);
    login = json['login'] ?? false;
    idUsuario = json['idUsuario'] ?? "";
    nombres = json['nombres'] ?? "";
    apellidos = json['apellidos'] ?? "";
    password = json['password'] ?? "";
    email = json['email'] ?? "";
    perfil = json['perfil'] ?? "";
    token = json['token'] ?? "";
    activo = json['activo'] ?? true;
    idFirebase = json['idFirebase'] ?? "";
    idDispositivo = json['idDispositivo'] ?? "";
    acepta = json['acepta'] ?? 0;
    creado = json['creado'] ?? true;
    backupInicial = json['backupInicial'] ?? true;
    idBackup = json['idBackup'] ?? "";
    fechaBackup = json['fechaBackup'] ?? "";
  }

  LocalStorage.fromMap(Map<String, dynamic> json) {
    login = json['login'] ?? false;
    idUsuario = json['idUsuario'] ?? "";
    nombres = json['nombres'] ?? "";
    apellidos = json['apellidos'] ?? "";
    password = json['password'] ?? "";
    email = json['email'] ?? "";
    perfil = json['perfil'] ?? "";
    token = json['token'] ?? "";
    activo = json['activo'] ?? true;
    idFirebase = json['idFirebase'] ?? "";
    idDispositivo = json['idDispositivo'] ?? "";
    acepta = json['acepta'] ?? 0;
    creado = json['creado'] ?? true;
    backupInicial = json['backupInicial'] ?? true;
    idBackup = json['idBackup'] ?? "";
    fechaBackup = json['fechaBackup'] ?? "";
  }

  factory LocalStorage.fromJson(Map<String, dynamic> json) => LocalStorage(
    version: json['version'] ?? _localStorageVersion,
    login: json['login'] ?? false,
    idUsuario: json['idUsuario'] ?? "",
    nombres: json['nombres'] ?? "",
    apellidos: json['apellidos'] ?? "",
    password: json['password'] ?? "",
    email: json['email'] ?? "",
    perfil: json['perfil'] ?? "",
    token: json['token'] ?? "",
    activo: json['activo'] ?? true,
    idFirebase: json['idFirebase'] ?? "",
    idDispositivo: json['idDispositivo'] ?? "",
    acepta: json['acepta'] ?? 0,
    creado: json['creado'] ?? true,
    backupInicial: json['backupInicial'] ?? true,
    idBackup: json['idBackup'] ?? "",
    fechaBackup: json['fechaBackup'] ?? "",
  );
}