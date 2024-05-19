import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../data/models/local_storage/cargos_abonos.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/configuracion.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/reports/estado_cuenta_report.dart';
import '../../widgets/reports/recibo_abono_report.dart';
import '../cobranza_main/cobranza_main_controller.dart';

class AltaCargoAbonoController extends GetInjection {
  ScrollController scrollController = ScrollController();
  TextEditingController cantidad = TextEditingController();
  FocusNode cantidadFocus = FocusNode();
  TextEditingController referencia = TextEditingController();
  FocusNode referenciaFocus = FocusNode();

  Cobranzas? cobranzaEditar = Cobranzas();
  String etiqueta = "Nombre: ";
  bool pendiente = false;
  double saldoPendiente = 0;
  double saldoCargos = 0;
  double saldoAbonos = 0;

  List<CargosAbonos> listaCargosAbonos = [];
  List<String> cargosAbonosPdfHeader = [
    "FECHA", "CARGO", "ABONO", "DESCRIPCION",
  ];
  List<List<dynamic>> cargosAbonosTabla = [];

  Configuracion configuracion = Configuracion();

  final bool esAdmin = GetInjection.administrador;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    var arguments = Get.arguments;
    cobranzaEditar = arguments['cobranza'] as Cobranzas;
    if(cobranzaEditar == null) {
      Get.back();
      tool.msg("Ocurrió un problema al cargar datos de Cargo y abono", 3);
    }
    configuracion = Configuracion.fromJson(storage.get(Configuracion()));
    pendiente = cobranzaEditar!.estatus == Literals.statusCobranzaPendiente 
      && (!esAdmin && cobranzaEditar!.bloqueado == Literals.bloqueoSi || cobranzaEditar!.bloqueado == Literals.bloqueoNo);
    if(cobranzaEditar!.tipoCobranza! == Literals.tipoCobranzaMeDeben) {
      etiqueta = "Me debe: ";
    } else if(cobranzaEditar!.tipoCobranza! == Literals.tipoCobranzaDebo) {
      etiqueta = "Le debo a: ";
    }
    saldoPendiente = cobranzaEditar!.saldo!;
    _cargarListaCargosAbonos();
  }

  Future<void> marcarCobranzaPagada() async {
    var mensaje = "¿Desea registrar el pago total (~MONTOTOTAL~)?";
    var montoBonificacion = 0.0;
    if(!tool.str2date(cobranzaEditar!.fechaVencimiento!).isBefore(DateTime.now().add(-1.days))) {
      montoBonificacion = (saldoPendiente * (configuracion.porcentajeBonificacion! / 100));
      var saldoBonificacion = saldoPendiente - montoBonificacion;
      mensaje = mensaje.replaceAll("~MONTOTOTAL~", MoneyFormatter(amount: saldoBonificacion).output.symbolOnLeft);
      var bonificacion = tool.isInteger(configuracion.porcentajeBonificacion!) 
        ? configuracion.porcentajeBonificacion!.toInt().toString() 
        : configuracion.porcentajeBonificacion!.toString();
      mensaje += "\nSe bonificará $bonificacion% (${MoneyFormatter(amount: montoBonificacion).output.symbolOnLeft})";
    } else {
      mensaje = mensaje.replaceAll("~MONTOTOTAL~", MoneyFormatter(amount: saldoPendiente).output.symbolOnLeft);
    }
    var pagar = await tool.ask("Pagar totalmente", mensaje);
    if(!pagar) {
      return;
    }
    if(montoBonificacion > 0) {
      cantidad.text = montoBonificacion.toString();
      referencia.text = "Bonificacion pronto pago";
      var nuevoSaldo = saldoPendiente - montoBonificacion;
      await _crearRegistroCargoAbono(Literals.movimientoAbono, nuevoSaldo);
    }
    await _crearRegistroCargoAbono(Literals.movimientoAbono, 0, pagar: true);
  }

  Future<void> crearCargo() async {
    var nuevoSaldo = saldoPendiente + tool.str2double(cantidad.text);
    await _crearRegistroCargoAbono(Literals.movimientoCargo, nuevoSaldo);
  }

  Future<void> crearAbono() async {
    if(tool.str2double(cantidad.text) > saldoPendiente) {
      tool.msg("El abono no puede ser MAYOR al saldo pendiente (${MoneyFormatter(amount: saldoPendiente).output.symbolOnLeft})", 2);
      return;
    }
    var nuevoSaldo = saldoPendiente - tool.str2double(cantidad.text);
    await _crearRegistroCargoAbono(Literals.movimientoAbono, nuevoSaldo);
  }

  Future<void> _crearRegistroCargoAbono(String tipo, double nuevoSaldo, {bool pagar = false}) async {
    try {
      if(!_validarForm(pagar)) {
        return;
      }
      tool.isBusy();
      await Future.delayed(1.seconds);
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var listaCobranzas = List<Cobranzas>.from(
        storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
      );
      for (var i = 0; i < listaCobranzas.length; i++) {
        if(listaCobranzas[i].idCobranza == cobranzaEditar!.idCobranza) {
          listaCobranzas[i].saldo = nuevoSaldo;
          if(pagar) {
            listaCobranzas[i].estatus = Literals.statusCobranzaPagada;
          }
          if(tipo == Literals.movimientoCargo) {
            listaCobranzas[i].ultimoCargo = pagar ? saldoPendiente : tool.str2double(cantidad.text);
            listaCobranzas[i].fechaUltimoCargo = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
            listaCobranzas[i].usuarioUltimoCargo = esAdmin ? Literals.perfilAdministrador : localStorage.email;
          } else if(tipo == Literals.movimientoAbono) {
            listaCobranzas[i].ultimoAbono = pagar ? saldoPendiente : tool.str2double(cantidad.text);
            listaCobranzas[i].fechaUltimoAbono = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
            listaCobranzas[i].usuarioUltimoAbono = esAdmin ? Literals.perfilAdministrador : localStorage.email;
          }
        }
      }
      var cargosAbonos = List<CargosAbonos>.from(
        storage.get([CargosAbonos()]).map((json) => CargosAbonos.fromJson(json))
      );
      cargosAbonos.add(CargosAbonos(
        idUsuario: localStorage.idUsuario,
        idCobranza: cobranzaEditar!.idCobranza,
        idMovimiento: tool.guid(),
        tipo: tipo,
        monto: pagar ? saldoPendiente : tool.str2double(cantidad.text),
        referencia: pagar ? "Pago total" : referencia.text,
        usuarioRegistro: esAdmin ? Literals.perfilAdministrador : localStorage.email,
        fechaRegistro: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
      ));
      cobranzaEditar!.saldo = nuevoSaldo;
      saldoPendiente = nuevoSaldo;
      await storage.update(cargosAbonos);
      await storage.update(listaCobranzas);
      await Future.delayed(1.seconds);
      await Get.find<CobranzaMainController>().cargarListaCobranza();
      tool.isBusy(false);
      if(pagar) {
        Get.back();
      } else {
        _limpiaForm();
        _cargarListaCargosAbonos();
      }
      if(!tool.str2date(cobranzaEditar!.fechaVencimiento!).isBefore(DateTime.now().add(-1.days)) && !pagar) {
        return;
      }
      tool.msg("Registro generado correctamente ($tipo)", 1);
    } catch(e) {
      tool.msg("Ocurrió un error al agregar registro $tipo", 3);
    } finally {
      update();
    }
  }

  Future<void> revertirCargoAbono(CargosAbonos cargosAbonos) async {
    var borrar = await tool.ask("Atención!", "¿Está seguro de querer ELIMINAR definitivamente el ${cargosAbonos.tipo!.toLowerCase()} (${MoneyFormatter(amount: cargosAbonos.monto!).output.symbolOnLeft})?");
    if(!borrar) {
      return;
    }
    try {
      tool.isBusy();
      await Future.delayed(1.seconds);
      var nuevoSaldo = cargosAbonos.tipo! == Literals.movimientoAbono 
        ? saldoPendiente + cargosAbonos.monto!
        : saldoPendiente - cargosAbonos.monto!;
      var listaCobranzas = List<Cobranzas>.from(
        storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
      );
      for (var i = 0; i < listaCobranzas.length; i++) {
        if(listaCobranzas[i].idCobranza == cobranzaEditar!.idCobranza) {
          listaCobranzas[i].saldo = nuevoSaldo;
        }
      }
      var listaCargosAbonos = List<CargosAbonos>.from(
        storage.get([CargosAbonos()]).map((json) => CargosAbonos.fromJson(json))
      );
      listaCargosAbonos.removeWhere((c) => c.idMovimiento == cargosAbonos.idMovimiento);
      cobranzaEditar!.saldo = nuevoSaldo;
      saldoPendiente = nuevoSaldo;
      await storage.update(listaCargosAbonos);
      await storage.update(listaCobranzas);
      await Future.delayed(1.seconds);
      await Get.find<CobranzaMainController>().cargarListaCobranza();
      tool.isBusy(false);
      _limpiaForm();
      _cargarListaCargosAbonos();
    } catch(e) {
      tool.msg("Ocurrió un error al eliminar el ${cargosAbonos.tipo!.toLowerCase()}", 3);
    } finally {
      update();
    }
  }

  void mostrarDetalleCargoAbono(CargosAbonos cargosAbonos) {
    
  }

  Future<void> crearAbonoReportePdf(CargosAbonos cargosAbonos) async {
    var estadoCuenta = ReciboAbonoReport(
      fecha: cargosAbonos.fechaRegistro!,
      monto: MoneyFormatter(amount: cargosAbonos.monto!).output.symbolOnLeft,
    );
    var pdf = await tool.crearPdf(estadoCuenta, Literals.reporteEstadoCuentaPdf);
    await tool.compartir(pdf!, Literals.reporteEstadoCuentaPdf);
  }

  Future<void> crearEstadoCuentaPdf() async {
    cargosAbonosTabla = [];
    cargosAbonosTabla.add(cargosAbonosPdfHeader);
    for(var cargoAbono in listaCargosAbonos) {
      var monto = MoneyFormatter(amount: cargoAbono.monto!).output.symbolOnLeft;
      List<String> filaCargoAbono = [
        cargoAbono.fechaRegistro!,
        cargoAbono.tipo! == Literals.movimientoCargo ? monto : "\$ 0.00",
        cargoAbono.tipo! == Literals.movimientoAbono ? monto : "\$ 0.00",
        cargoAbono.referencia!,
      ];
      cargosAbonosTabla.add(filaCargoAbono);
    }
    var estadoCuenta = EstadoCuentaReport(
      tablaCargosAbonos: cargosAbonosTabla,
      nombre: cobranzaEditar!.nombre!,
      saldoTotal: saldoPendiente,
      saldoAbonos: saldoAbonos,
      saldoCargos: saldoCargos,
    );
    var pdf = await tool.crearPdf(estadoCuenta, Literals.reporteEstadoCuentaPdf);
    await tool.compartir(pdf!, Literals.reporteEstadoCuentaPdf);
  }

  void _cargarListaCargosAbonos() {
    var cargosAbonos = List<CargosAbonos>.from(
      storage.get([CargosAbonos()]).map((json) => CargosAbonos.fromJson(json))
    );
    listaCargosAbonos = cargosAbonos.where((c) => c.idCobranza == cobranzaEditar!.idCobranza!).toList();
    listaCargosAbonos.insert(0, CargosAbonos(
      monto: cobranzaEditar!.cantidad,
      tipo: Literals.movimientoCargo,
      fechaRegistro: cobranzaEditar!.fechaRegistro,
      referencia: cobranzaEditar!.descripcion,
    ));
    saldoCargos = 0;
    saldoAbonos = 0;
    for(var cargoAbono in listaCargosAbonos) {
      if(cargoAbono.tipo == Literals.movimientoCargo) {
        saldoCargos = saldoCargos + cargoAbono.monto!;
      } else if(cargoAbono.tipo == Literals.movimientoAbono) {
        saldoAbonos = saldoAbonos + cargoAbono.monto!;
      }
    }
  }

  void abrirCalculadora() {
    tool.calculadora();
  }

  void cerrar() {
    Get.back();
  }

  bool _validarForm(bool pagar) {
    if(pagar) {
      return true;
    }
    var correcto = false;
    var mensaje = "";
    if(tool.isNullOrEmpty(cantidad)) {
      mensaje = "Escriba la cantidad";
    } else if(tool.str2double(cantidad.text) == 0) {
      mensaje = "La cantidad es incorrecta";
    } else {
      cantidadFocus.unfocus();
      referenciaFocus.unfocus();
      correcto = true;
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }

  void _limpiaForm() {
    cantidad.text = "";
    referencia.text = "";
  }
}