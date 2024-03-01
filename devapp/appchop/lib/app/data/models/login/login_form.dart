class LoginForm {
  String? usuario;
  String? password;
  String? firebase;

  LoginForm({
    this.usuario = "",
    this.password = "",
    this.firebase = "",
  });

  Map toJson() => {
    'usuario'   : usuario,
    'password'  : password,
    'firebase'  : firebase,
  };
}