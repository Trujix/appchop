class Literals {
  static const String notificacionTopic = "appchop_notif";

  static const String storageName = "appchopStorage";
  static const String storageBoxName = "appchop";

  //static const String uri = "http://192.168.1.85:81/appchop/devweb/";
  static const String uri = "https://appchop.com/";
  static const String contentType = "ContentType";
  static const String applicationJson = "application/json";
  static const String autorization = "Authorization";
  static const String terminosCondicionesFile =
      "media/documentos/terminos_y_condiciones_de_uso_appchop.pdf";

  static const String perfilAdministrador = "ADMINISTRADOR";
  static const String perfilCobrador = "COBRADOR";
  static const String statusActivo = "ACTIVO";
  static const String statusInactivo = "INACTIVO";
  static const String statusPassTemporal = "PASSTEMPORAL";
  static const String statusIdDispositivo = "NONE";
  static const String bloqueoSi = "SI";
  static const String bloqueoNo = "NO";

  static const String newPasswordNoUsuario = "NO-USUARIO";
  static const String newPasswordEnviado = "PASSWORD-ENVIADO";
  static const String newPasswordError = "ERROR";

  static const String defaultZonaTodo = "TODO";
  static const String defaultZonaTodoTxt = "Mostrar todo";
  static const String defaultZonaTodoV2Txt = "Todas las zonas";
  static const String defaultZonaSin = "SIN_ZONA";
  static const String defaultZonaSinTxt = "Sin zona";

  static const String tipoCobranzaMeDeben = "ME_DEBEN";
  static const String tipoCobranzaDebo = "DEBO";
  static const String tipoCobranzaVencida = "VENCIDAS";
  static const String statusCobranzaPagada = "PAGADA";
  static const String statusCobranzaPendiente = "PENDIENTE";
  static const String markerIdClienteCobranza = "COBRANZA_MARKER_CLIENTE";
  static const String movimientoCargo = "CARGO";
  static const String movimientoAbono = "ABONO";
  static const String cargoAbonoAuto = "AUTO";
  static const String cargoAbonoManual = "MANUAL";

  static const String reportesClientes = "CLIENTES";
  static const String reportesUsuarios = "USUARIOS";
  static const String reportesBaseInventarios = "BASE-INVENTARIOS";

  static const String validacionErrorEstatus = "ERROR-ESTATUS";
  static const String validacionErrorZona = "ERROR-ZONA";

  static const String estatusManualTodos = "TODOS";
  static const String estatusManualPendiente = "PENDIENTE";
  static const String estatusManualListado = "VISITA&ABONO";
  static const String estatusManualListadoFull = "VISITA&ABONO&PENDIENTE";

  static const String cargoAbonoMsgBonificacion = "Bonificacion pronto pago";
  static const String cargoAbonoMsgIntereses = "Cargo de intereses";

  static const String backUpClean = "NABACKUP";

  static const String busquedaClientes = "BUSCAR-CLIENTES";

  static const String usuarioAccionReiniciar = "REINICIAR";

  static const String notificacionUsuarioPassword = "USUARIO-PASSWORD";

  static const String sinVencimiento = "31-12-2999";

  static const String noneStorage = "NONE";

  static const String apiTrue = "true";

  static const String reporteCobranzaCsv = "reporte_cobranza.csv";
  static const String reporteInventariosCsv = "listado_inventario.csv";
  static const String reporteClientesCsv = "listado_clientes.csv";
  static const String reporteUsuariosCsv = "listado_usuarios.csv";
  static const String reporteBaseInventariosCsv = "listado_base_inventario.csv";
  static const String reporteCargosAbonosCsv = "cargos_abonos.pdf";
  static const String reporteEstadoCuentaPdf = "estado_cuenta.pdf";

  static const String msgOffline =
      "Es necesario estar conectado a internet para esta acción";

  static const String regexEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
}