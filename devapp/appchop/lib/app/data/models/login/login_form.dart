class LoginForm {
  String? usuario;
  String? password;
  String? idUsuario;
  String? firebase;
  String? sesion;
  int? acepta;

  LoginForm({
    this.usuario = "",
    this.password = "",
    this.idUsuario = "",
    this.firebase = "",
    this.sesion = "",
    this.acepta = 0,
  });

  Map toJson() => {
    'usuario'   : usuario,
    'password'  : password,
    'idUsuario' : idUsuario,
    'firebase'  : firebase,
    'sesion'    : sesion,
    'acepta'    : acepta,
  };
}