import 'package:get/get.dart';

import '../../../services/tool_service.dart';

class LoginData {
  final ToolService _tool = Get.find<ToolService>();
  int? id;
  String? idSistema;
  String? usuario;
  String? status;
  int? idAutorization;
  String? nombres;
  String? apellidos;
  String? idFirebase;
  String? perfil;
  String? token;
  String? sesion;
  int? acepta;

  LoginData({
    this.id = 0,
    this.idSistema = "",
    this.usuario = "",
    this.status = "",
    this.idAutorization = 0,
    this.nombres = "",
    this.apellidos = "",
    this.idFirebase = "",
    this.perfil = "",
    this.token = "",
    this.sesion = "",
    this.acepta = 0,
  });

  Map toJson() => {
    'id'              : id,
    'idSistema'       : idSistema,
    'usuario'         : usuario,
    'status'          : status,
    'idAutorization'  :idAutorization,
    'nombres'         : nombres,
    'apellidos'       : apellidos,
    'idFirebase'      : idFirebase,
    'perfil'          : perfil,
    'token'           : token,
    'sesion'          : sesion,
    'acepta'          : acepta,
  };

  LoginData.fromApi(Map<String, dynamic> json) {
    id = _tool.str2int(json['id'].toString());
    idSistema = json['id_sistema'].toString();
    usuario = json['usuario'].toString();
    status = json['status'].toString();
    idAutorization = _tool.str2int(json['id_autorization'].toString());
    nombres = json['nombres'].toString();
    apellidos = json['apellidos'].toString();
    idFirebase = json['id_firebase'].toString();
    perfil = json['perfil'].toString();
    token = json['token'].toString();
    sesion = json['sesion'].toString();
    acepta = _tool.str2int(json['acepta'].toString());
  }
}