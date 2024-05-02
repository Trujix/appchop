class Notificacion {
  String? titulo;
  String? cuerpo;
  List<String> ids;
  dynamic data;

  Notificacion({
    this.titulo = "",
    this.cuerpo = "",
    this.ids = const [],
    this.data = const {},
  });

  Map toJson() => {
    'titulo'    : titulo,
    'cuerpo'    : cuerpo,
    'ids'       : ids,
    'data'      : data,
  };
}