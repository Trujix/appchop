class AltaCobrador {
  String? idUsuario;
  String? usuario;
  String? password;
  String? nombres;
  String? apellidos;
  String? estatus;

  AltaCobrador({
    this.idUsuario = "",
    this.usuario = "",
    this.password = "",
    this.nombres = "",
    this.apellidos = "",
    this.estatus = "ACTIVO",
  });

  Map toJson() => {
    'idUsuario'   : idUsuario,
    'usuario'     : usuario,
    'password'    : password,
    'nombres'     : nombres,
    'apellidos'   : apellidos,
    'estatus'     : estatus,
  };
}