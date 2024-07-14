import 'package:get/get.dart';

import '../../../services/storage_service.dart';
import '../../../services/tool_service.dart';
import '../../../utils/literals.dart';

class Cobranzas {
  String? tabla = "cobranzas";
  String? idUsuario;
  String? idCobranza;
  String? tipoCobranza;
  String? zona;
  String? nombre;
  double? cantidad;
  String? descripcion;
  String? telefono;
  String? direccion;
  String? correo;
  String? fechaRegistro;
  String? fechaVencimiento;
  double? saldo;
  String? latitud;
  String? longitud;
  double? ultimoCargo;
  String? fechaUltimoCargo;
  String? usuarioUltimoCargo;
  double? ultimoAbono;
  String? fechaUltimoAbono;
  String? usuarioUltimoAbono;
  String? estatus;
  String? bloqueado;
  String? idCobrador;
  String? estatusManual;

  Cobranzas({
    this.idUsuario = "",
    this.idCobranza = "",
    this.tipoCobranza = "",
    this.zona = "",
    this.nombre = "",
    this.cantidad = 0.0,
    this.descripcion = "",
    this.telefono = "",
    this.direccion = "",
    this.correo = "",
    this.fechaRegistro = "",
    this.fechaVencimiento = "",
    this.saldo = 0.0,
    this.latitud = "",
    this.longitud = "",
    this.ultimoCargo = 0.0,
    this.fechaUltimoCargo = "",
    this.usuarioUltimoCargo = "",
    this.ultimoAbono = 0.0,
    this.fechaUltimoAbono = "",
    this.usuarioUltimoAbono = "",
    this.estatus = Literals.statusCobranzaPendiente,
    this.bloqueado = Literals.bloqueoNo,
    this.idCobrador = "",
    this.estatusManual = Literals.estatusManualPendiente,
  });

  static Future<void> init() async {
    try {
      var storage = Get.find<StorageService>();
      var verify = storage.verify(Cobranzas());
      if(!verify) {
        var _ = await storage.put([Cobranzas()]);
      }
      return;
    } finally { }
  }

  Map toJson() => {
    'tabla'             : tabla,
    'idUsuario'         : idUsuario,
    'idCobranza'        : idCobranza,
    'tipoCobranza'      : tipoCobranza,
    'zona'              : zona,
    'nombre'            : nombre,
    'cantidad'          : cantidad,
    'descripcion'       : descripcion,
    'telefono'          : telefono,
    'direccion'         : direccion,
    'correo'            : correo,
    'fechaRegistro'     : fechaRegistro,
    'fechaVencimiento'  : fechaVencimiento,
    'saldo'             : saldo,
    'latitud'           : latitud,
    'longitud'          : longitud,
    'ultimoCargo'       : ultimoCargo,
    'fechaUltimoCargo'  : fechaUltimoCargo,
    'usuarioUltimoCargo': usuarioUltimoCargo,
    'ultimoAbono'       : ultimoAbono,
    'fechaUltimoAbono'  : fechaUltimoAbono,
    'usuarioUltimoAbono': usuarioUltimoAbono,
    'estatus'           : estatus,
    'bloqueado'         : bloqueado,
    'idCobrador'        : idCobrador,
    'estatusManual'     : estatusManual,
  };

  factory Cobranzas.fromJson(Map<String, dynamic> json) => Cobranzas(
    idUsuario: json['idUsuario'] ?? "",
    idCobranza: json['idCobranza'] ?? "",
    tipoCobranza: json['tipoCobranza'] ?? "",
    zona: json['zona'] ?? "",
    nombre: json['nombre'] ?? "",
    cantidad: Get.find<ToolService>().str2double(json['cantidad'].toString()),
    descripcion: json['descripcion'] ?? "",
    telefono: json['telefono'] ?? "",
    direccion: json['direccion'] ?? "",
    correo: json['correo'] ?? "",
    fechaRegistro: json['fechaRegistro'] ?? "",
    fechaVencimiento: json['fechaVencimiento'] ?? "",
    saldo: Get.find<ToolService>().str2double(json['saldo'].toString()),
    latitud: json['latitud'] ?? "",
    longitud: json['longitud'] ?? "",
    ultimoCargo: Get.find<ToolService>().str2double(json['ultimoCargo'].toString()),
    fechaUltimoCargo: json['fechaUltimoCargo'] ?? "",
    usuarioUltimoCargo: json['usuarioUltimoCargo'] ?? "",
    ultimoAbono: Get.find<ToolService>().str2double(json['ultimoAbono'].toString()),
    fechaUltimoAbono: json['fechaUltimoAbono'] ?? "",
    usuarioUltimoAbono: json['usuarioUltimoAbono'] ?? "",
    estatus: json['estatus'] ?? "",
    bloqueado: json['bloqueado'] ?? "",
    idCobrador: json['idCobrador'] ?? "",
    estatusManual: json['estatusManual'] ?? "",
  );
}