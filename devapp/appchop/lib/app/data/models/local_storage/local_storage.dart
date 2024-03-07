import 'dart:convert';

class LocalStorage {
  static const int _localStorageVersion = 4;

  String? tabla = "local_storage";
  int? version = _localStorageVersion;
  bool? login;
  String? idUsuario;
  String? nombres;
  String? apellidos;
  String? password;
  String? email;
  String? token;
  bool? activo;
  String? idFirebase;
  String? idDispositivo;
  bool? creado;

  LocalStorage({
    this.version = _localStorageVersion,
    this.login = false,
    this.idUsuario = "",
    this.nombres = "",
    this.apellidos = "",
    this.password = "",
    this.email = "",
    this.token = "-",
    this.activo = true,
    this.idFirebase = "",
    this.idDispositivo = "",
    this.creado = true,
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
    'token'             : token,
    'activo'            : activo,
    'idFirebase'        : idFirebase,
    'idDispositivo'     : idDispositivo,
    'creado'            : creado,
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
      'token'             : token,
      'activo'            : activo,
      'idFirebase'        : idFirebase,
      'idDispositivo'     : idDispositivo,
      'creado'            : creado,
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
    token = json['token'] ?? "";
    activo = json['activo'] ?? true;
    idFirebase = json['idFirebase'] ?? "";
    idDispositivo = json['idDispositivo'] ?? "";
    creado = json['creado'] ?? true;
  }

  LocalStorage.fromMap(Map<String, dynamic> json) {
    login = json['login'] ?? false;
    idUsuario = json['idUsuario'] ?? "";
    nombres = json['nombres'] ?? "";
    apellidos = json['apellidos'] ?? "";
    password = json['password'] ?? "";
    email = json['email'] ?? "";
    token = json['token'] ?? "";
    activo = json['activo'] ?? true;
    idFirebase = json['idFirebase'] ?? "";
    idDispositivo = json['idDispositivo'] ?? "";
    creado = json['creado'] ?? true;
  }

  factory LocalStorage.fromJson(Map<String, dynamic> json) => LocalStorage(
    version: json['version'] ?? _localStorageVersion,
    login: json['login'] ?? false,
    idUsuario: json['idUsuario'] ?? "",
    nombres: json['nombres'] ?? "",
    apellidos: json['apellidos'] ?? "",
    password: json['password'] ?? "",
    email: json['email'] ?? "",
    token: json['token'] ?? "",
    activo: json['activo'] ?? true,
    idFirebase: json['idFirebase'] ?? "",
    idDispositivo: json['idDispositivo'] ?? "",
    creado: json['creado'] ?? true,
  );
}