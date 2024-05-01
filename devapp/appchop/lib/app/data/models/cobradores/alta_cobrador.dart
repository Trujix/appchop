class AltaCobrador {
  String? idUsuario;
  String? usuario;
  String? password;
  String? nombres;
  String? apellidos;

  AltaCobrador({
    this.idUsuario = "",
    this.usuario = "",
    this.password = "",
    this.nombres = "",
    this.apellidos = "",
  });

  Map toJson() => {
    'idUsuario'   : idUsuario,
    'usuario'     : usuario,
    'password'    : password,
    'nombres'     : nombres,
    'apellidos'   : apellidos,
  };
}