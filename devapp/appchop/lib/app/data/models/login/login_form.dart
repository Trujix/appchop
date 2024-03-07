class LoginForm {
  String? usuario;
  String? password;
  String? firebase;
  String? sesion;

  LoginForm({
    this.usuario = "",
    this.password = "",
    this.firebase = "",
    this.sesion = "",
  });

  Map toJson() => {
    'usuario'   : usuario,
    'password'  : password,
    'firebase'  : firebase,
    'sesion'    : sesion,
  };
}