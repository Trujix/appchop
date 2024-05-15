class AppBackupInfo {
  String? idUsuario;
  String? idBackup;
  String? usuario;
  String? fechaCreacion;

  AppBackupInfo({
    this.idUsuario = "",
    this.idBackup = "",
    this.usuario = "",
    this.fechaCreacion = "",
  });

  Map toJson() => {
    'idUsuario'       : idUsuario,
    'idBackup'        : idBackup,
    'usuario'         : usuario,
    'fechaCreacion'   : fechaCreacion,
  };

  AppBackupInfo.fromApi(Map<String, dynamic> json) {
    idUsuario = json['idUsuario'].toString();
    idBackup = json['idBackup'].toString();
    usuario = json['usuario'].toString();
    fechaCreacion = json['fechaCreacion'].toString();
  }
}