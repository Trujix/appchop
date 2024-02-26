import 'dart:convert';

class LocalStorage {
  static const int _localStorageVersion = 1;

  String? tabla = "local_storage";
  int? version = _localStorageVersion;
  bool? init = false;
  bool? login;
  String? idUsuario;
  String? nombres;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? password;
  String? email;
  bool? activo;
  String? idFirebase;

  LocalStorage({
    this.version = _localStorageVersion,
    this.init,
    this.login = false,
    this.idUsuario = "",
    this.nombres = "",
    this.apellidoPaterno = "",
    this.apellidoMaterno = "",
    this.password = "",
    this.email = "",
    this.activo = true,
    this.idFirebase = "",
  });

  Map toJson() => {
    'tabla'             : tabla,
    'version'           : version,
    'init'              : init,
    'login'             : login,
    'idUsuario'         : idUsuario,
    'nombres'           : nombres,
    'apellidoPaterno'   : apellidoPaterno,
    'apellidoMaterno'   : apellidoMaterno,
    'password'          : password,
    'email'             : email,
    'activo'            : activo,
    'idFirebase'        : idFirebase,
  };
  
  Map<String, dynamic> toMap() {
    return {
      'tabla'             : tabla,
      'version'           : version,
      'init'              : init,
      'login'             : login,
      'idUsuario'         : idUsuario,
      'nombres'           : nombres,
      'apellidoPaterno'   : apellidoPaterno,
      'apellidoMaterno'   : apellidoMaterno,
      'password'          : password,
      'email'             : email,
      'activo'            : activo,
      'idFirebase'        : idFirebase,
    };
  }

  LocalStorage.fromString(String jsonString) {
    var json = jsonDecode(jsonString);
    login = json['login'] ?? false;
    idUsuario = json['idUsuario'] ?? "";
    nombres = json['nombres'] ?? "";
    apellidoPaterno = json['apellidoPaterno'] ?? "";
    apellidoMaterno = json['apellidoMaterno'] ?? "";
    password = json['password'] ?? "";
    email = json['email'] ?? "";
    activo = json['activo'] ?? true;
    idFirebase = json['idFirebase'] ?? "";
  }

  LocalStorage.fromMap(Map<String, dynamic> json) {
    login = json['login'] ?? false;
    idUsuario = json['idUsuario'] ?? "";
    nombres = json['nombres'] ?? "";
    apellidoPaterno = json['apellidoPaterno'] ?? "";
    apellidoMaterno = json['apellidoMaterno'] ?? "";
    password = json['password'] ?? "";
    email = json['email'] ?? "";
    activo = json['activo'] ?? true;
    idFirebase = json['idFirebase'] ?? "";
  }

  factory LocalStorage.fromJson(Map<String, dynamic> json) => LocalStorage(
    version: json['version'] ?? _localStorageVersion,
    init: json['init'] ?? false,
    login: json['login'] ?? false,
    idUsuario: json['idUsuario'] ?? "",
    nombres: json['nombres'] ?? "",
    apellidoPaterno: json['apellidoPaterno'] ?? "",
    apellidoMaterno: json['apellidoMaterno'] ?? "",
    password: json['password'] ?? "",
    email: json['email'] ?? "",
    activo: json['activo'] ?? true,
    idFirebase: json['idFirebase'] ?? "",
  );
}