class ImagenLogo {
  String? idUsuario;
  String? imagenBase64;

  ImagenLogo({
    this.idUsuario = "",
    this.imagenBase64 = "",
  });

  Map toJson() => {
    'idUsuario'     : idUsuario,
    'imagenBase64'  : imagenBase64,
  };
}