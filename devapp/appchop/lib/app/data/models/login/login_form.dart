class LoginForm {
  String? usuario;
  String? password;
  String? idUsuario;
  String? firebase;
  String? sesion;

  LoginForm({
    this.usuario = "",
    this.password = "",
    this.idUsuario = "",
    this.firebase = "",
    this.sesion = "",
  });

  Map toJson() => {
    'usuario'   : usuario,
    'password'  : password,
    'idUsuario' : idUsuario,
    'firebase'  : firebase,
    'sesion'    : sesion,
  };
}