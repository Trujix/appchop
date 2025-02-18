import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../data/models/local_storage/cargos_abonos.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/configuracion.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/menu_popup_opciones.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/reports/estado_cuenta_report.dart';
import '../../widgets/reports/recibo_abono_report.dart';
import '../../widgets/texts/combo_texts.dart';
import '../cobranza_main/cobranza_main_controller.dart';

class AltaCargoAbonoController extends GetInjection {
  ScrollController scrollController = ScrollController();
  TextEditingController cantidad = TextEditingController();
  FocusNode cantidadFocus = FocusNode();
  TextEditingController referencia = TextEditingController();
  FocusNode referenciaFocus = FocusNode();

  String opcionSelected = "";
  List<MenuPopupOpciones> opcionesConsulta = [];
  List<String> opcionesBase = [
    "Exportar~B",
    "Ajustar saldo~B",
    "Filtro Manual~B",
  ];
  List<IconData?> opcionesIcono = [
    MaterialIcons.share,
    MaterialIcons.attach_money,
    MaterialIcons.filter_list,
  ];

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
  List<BottomSheetAction> _listaEstatusManual = [];
  String _estatusManualSelected = "";

  final bool esAdmin = GetInjection.administrador;

  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    var arguments = Get.arguments;
    cobranzaEditar = arguments['cobranza'] as Cobranzas;
    _estatusManualSelected = cobranzaEditar!.estatusManual!;
    if(cobranzaEditar == null) {
      Get.back();
      tool.msg("Ocurrió un problema al cargar datos de Cargo y abono", 3);
    }
    _cargarOpcionesPopup();
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
    await tool.wait(1);
    await _ajustarMoratorios();
  }

  Future<void> marcarCobranzaPagada() async {
    var mensaje = "¿Desea registrar el pago total (~MONTOTOTAL~)?";
    var montoBonificacion = 0.0;
    if(!tool.str2date(cobranzaEditar!.fechaVencimiento!).isBefore(DateTime.now().add(-1.days))) {
      montoBonificacion = tool.str2double((saldoPendiente * (configuracion.porcentajeBonificacion! / 100)).toStringAsFixed(2));
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
      referencia.text = Literals.cargoAbonoMsgBonificacion;
      var nuevoSaldo = saldoPendiente - montoBonificacion;
      await _crearRegistroCargoAbono(Literals.movimientoAbono, nuevoSaldo, manual: false);
    }
    await _crearRegistroCargoAbono(Literals.movimientoAbono, 0, pagar: true);
  }

  Future<void> crearCargo() async {
    var monto = tool.str2double(cantidad.text).toStringAsFixed(2);
    var nuevoSaldo = saldoPendiente + tool.str2double(monto);
    await _crearRegistroCargoAbono(Literals.movimientoCargo, nuevoSaldo);
  }

  Future<void> crearAbono() async {
    if(tool.str2double(cantidad.text) > saldoPendiente) {
      tool.msg("El abono no puede ser MAYOR al saldo pendiente (${MoneyFormatter(amount: saldoPendiente).output.symbolOnLeft})", 2);
      return;
    }
    var monto = tool.str2double(cantidad.text).toStringAsFixed(2);
    var nuevoSaldo = saldoPendiente - tool.str2double(monto);
    await _crearRegistroCargoAbono(Literals.movimientoAbono, nuevoSaldo);
  }

  Future<void> _crearRegistroCargoAbono(String tipo, double nuevoSaldo, {bool pagar = false, bool manual = true}) async {
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
          var ultimoMonto = tool.str2double(cantidad.text).toStringAsFixed(2);
          if(tipo == Literals.movimientoCargo) {
            listaCobranzas[i].ultimoCargo = pagar ? saldoPendiente : tool.str2double(ultimoMonto);
            listaCobranzas[i].fechaUltimoCargo = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
            listaCobranzas[i].usuarioUltimoCargo = esAdmin ? Literals.perfilAdministrador : localStorage.email;
          } else if(tipo == Literals.movimientoAbono) {
            listaCobranzas[i].ultimoAbono = pagar ? saldoPendiente : tool.str2double(ultimoMonto);
            listaCobranzas[i].fechaUltimoAbono = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
            listaCobranzas[i].usuarioUltimoAbono = esAdmin ? Literals.perfilAdministrador : localStorage.email;
          }
        }
      }
      var cargosAbonos = List<CargosAbonos>.from(
        storage.get([CargosAbonos()]).map((json) => CargosAbonos.fromJson(json))
      );
      var genera = manual ? Literals.cargoAbonoManual : Literals.cargoAbonoAuto;
      var monto = tool.str2double(cantidad.text).toStringAsFixed(2);
      cargosAbonos.add(CargosAbonos(
        idUsuario: localStorage.idUsuario,
        idCobranza: cobranzaEditar!.idCobranza,
        idMovimiento: tool.guid(),
        tipo: tipo,
        monto: pagar ? saldoPendiente : tool.str2double(monto),
        referencia: pagar ? "Pago total" : referencia.text,
        usuarioRegistro: esAdmin ? Literals.perfilAdministrador : localStorage.email,
        fechaRegistro: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
        genera: genera,
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
    var borrar = await tool.ask(
      "Atención! (Requiere internet)",
      "¿Está seguro de querer ELIMINAR definitivamente el ${cargosAbonos.tipo!.toLowerCase()} (${MoneyFormatter(amount: cargosAbonos.monto!).output.symbolOnLeft})?"
    );
    if(!borrar) {
      return;
    }
    try {
      var online = await tool.isOnline();
      if(!online) {
        tool.msg(Literals.msgOffline, 2);
      }
      tool.isBusy();
      await Future.delayed(1.seconds);
      var eliminarCargoAbono = await appBackupRepository.eliminarCargoAbonoAsync(
        cargosAbonos.idUsuario!,
        cargosAbonos.idCobranza!,
        cargosAbonos.idMovimiento!);
      if(!eliminarCargoAbono!) {
        throw Exception();
      }
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
      saldoCargos = nuevoSaldo;
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
    try {
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
        fechaVencimiento: cobranzaEditar!.fechaVencimiento!,
        porcentajeInteres: configuracion.porcentajeMoratorio!,
      );
      var pdf = await tool.crearPdf(estadoCuenta, Literals.reporteEstadoCuentaPdf);
      await tool.compartir(pdf!, Literals.reporteEstadoCuentaPdf);
    } catch(e) {
      tool.msg("Error: $e", 3);
    }
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
      genera: Literals.cargoAbonoAuto,
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

  Future<void> operacionPopUp(String? id) async {
    switch(id) {
      case "0":
        await crearEstadoCuentaPdf();
        break;
      case "1":
        await ajustarSaldo();
        break;
      case "2":
        filtrarCobranzaEspecial();
        break;
      default:
        return;
    }
  }

  Future<void> ajustarSaldo() async {
    try {
      var ajustar = await tool.ask("Ajustar saldo", "Se volverá a calcular el saldo ¿Desea continuar?");
      if(!ajustar) {
        return;
      }
      tool.isBusy();
      await tool.wait(1);
      var ajusteSaldo = await _ajustarSaldoExec();
      if(!ajusteSaldo) {
        throw Exception();
      }
      tool.msg("Se ajustó el saldo correctamente", 1);
    } catch(_) {
      tool.msg("Ocurrió un error al intentar recalcular el saldo", 3);
    } finally {
      update();
    }
  }

  Future<bool> _ajustarSaldoExec() async {
    try {
      var cargosAbonos = List<CargosAbonos>.from(
        storage.get([CargosAbonos()]).map((json) => CargosAbonos.fromJson(json))
      );
      var notaCargosAbonos = cargosAbonos.where((c) => c.idCobranza == cobranzaEditar!.idCobranza!).toList();
      var cargos = cobranzaEditar!.cantidad!;
      var abonos = 0.0;
      var nuevoSaldo = 0.0;
      for (var i = 0; i < notaCargosAbonos.length; i++) {
        if(notaCargosAbonos[i].tipo == Literals.movimientoCargo) {
          cargos += notaCargosAbonos[i].monto!;
        } else if(notaCargosAbonos[i].tipo == Literals.movimientoAbono) {
          abonos += notaCargosAbonos[i].monto!;
        }
      }
      nuevoSaldo = cargos - abonos;
      var listaCobranzas = List<Cobranzas>.from(
        storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
      );
      for (var i = 0; i < listaCobranzas.length; i++) {
        if(listaCobranzas[i].idCobranza == cobranzaEditar!.idCobranza) {
          listaCobranzas[i].saldo = nuevoSaldo;
          break;
        }
      }
      await storage.update(listaCobranzas);
      cobranzaEditar!.saldo = nuevoSaldo;
      saldoPendiente = nuevoSaldo;
      return true;
    } catch(_) {
      return false;
    }
  }

  void filtrarCobranzaEspecial() {
    _listaEstatusManual  = [];
    var listaEstatus = Literals.estatusManualListadoFull.split("&");
    for(var estatus in listaEstatus) {
      if(cobranzaEditar!.estatusManual == estatus) {
        continue;
      }
      _listaEstatusManual.add(
        BottomSheetAction(
          title: ComboText(
            texto: tool.capitalize(estatus),
            fontWeight: FontWeight.normal,
          ),
          onPressed: (context) async {
            var estatusAnterior = _estatusManualSelected;
            _estatusManualSelected = estatus;
            update();
            Navigator.of(context).pop();
            await _ejecutarEstatusManual(estatusAnterior);
          },
        )
      ); 
    }
    var context = Get.context!;
    showAdaptiveActionSheet(
      context: context,
      title: RichText(
        text: TextSpan(
          text: 'Estatus actual: ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: cobranzaEditar!.estatusManual,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      ),
      androidBorderRadius: 30,
      actions: _listaEstatusManual,
    );
  }

  Future<void> _ejecutarEstatusManual(String estatusAnterior) async {
    try {
      var cambiarEstatus = await tool.ask("Cambiar estatus", "¿Desea asignar el estatus $_estatusManualSelected a la nota?");
      if(cambiarEstatus) {
        tool.isBusy();
        var cobranzaStorage = List<Cobranzas>.from(
          storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
        );
        for (var i = 0; i < cobranzaStorage.length; i++) {
          if(cobranzaStorage[i].idCobranza == cobranzaEditar!.idCobranza) {
            cobranzaStorage[i].estatusManual = _estatusManualSelected;
          }
        }
        await storage.update(cobranzaStorage);
        await tool.wait(1);
        tool.isBusy(false);
      }
      cobranzaEditar!.estatusManual = _estatusManualSelected;
      _estatusManualSelected = estatusAnterior;
      await Get.find<CobranzaMainController>().cargarListaCobranza();
    } catch(_) {
      tool.msg("Ocurrió un problema al intentar cambiar estatus de la nota", 3);
    } finally {
      update();
    }
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

  Future<void> _ajustarMoratorios() async {
    try {
      if(!pendiente) {
        return;
      }
      var hoy = DateTime.now();
      var vencida = tool.str2date(cobranzaEditar!.fechaVencimiento!).isBefore(hoy.add(-1.days));
      if(!vencida) {
        return;
      }
      tool.isBusy();
      var ajusteSaldo = await _ajustarSaldoExec();
      if(!ajusteSaldo) {
        tool.msg("Ocurrió un error al intentar recalcular el saldo", 3);
        return;
      }
      update();
      await tool.wait(2);
      var listaCobranzas = List<Cobranzas>.from(
        storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
      );
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var fechaVencimiento = tool.str2date(cobranzaEditar!.fechaVencimiento!);
      var saldoCobranza = cobranzaEditar!.saldo!;
      var saldoNuevo = cobranzaEditar!.saldo!;
      var finaliza = true;
      List<CargosAbonos> intereses = [];
      while(finaliza) {
        fechaVencimiento = fechaVencimiento.add(7.days);
        finaliza = fechaVencimiento.isBefore(hoy.add(-1.days));
        if(finaliza) {
          var idMovimiento = tool.guid();
          var monto = tool.str2double((saldoCobranza * (configuracion.porcentajeMoratorio! / 100)).toStringAsFixed(2));
          saldoCobranza = saldoCobranza + monto;
          intereses.add(CargosAbonos(
            idUsuario: localStorage.idUsuario,
            idCobranza: cobranzaEditar!.idCobranza!,
            idMovimiento: idMovimiento,
            tipo: Literals.movimientoCargo,
            monto: monto,
            referencia: Literals.cargoAbonoMsgIntereses,
            usuarioRegistro: esAdmin ? Literals.perfilAdministrador : localStorage.email,
            fechaRegistro: DateFormat("dd-MM-yyyy").format(fechaVencimiento).toString(),
            genera: Literals.cargoAbonoAuto,
          ));
        }
      }
      if(intereses.isEmpty) {
        tool.isBusy(false);
        return;
      }
      var agrega = false;
      var cargosAbonosTemp = List<CargosAbonos>.from(
        storage.get([CargosAbonos()]).map((json) => CargosAbonos.fromJson(json))
      );
      for(var interes in intereses) {
        var verificar = listaCargosAbonos.where((ca) =>
          ca.idCobranza == interes.idCobranza
          && ca.fechaRegistro == interes.fechaRegistro
          && ca.genera == Literals.cargoAbonoAuto
          && ca.tipo == Literals.movimientoCargo
        ).firstOrNull;
        if(verificar != null) {
          continue;
        }
        agrega = true;
        saldoNuevo = saldoNuevo + interes.monto!;
        listaCargosAbonos.add(interes);
        cargosAbonosTemp.add(interes);
      }
      if(agrega) {
        saldoCargos = saldoCobranza;
        cobranzaEditar!.saldo = saldoNuevo;
        saldoPendiente = saldoNuevo;
        for (var i = 0; i < listaCobranzas.length; i++) {
          if(listaCobranzas[i].idCobranza == cobranzaEditar!.idCobranza) {
            listaCobranzas[i].saldo = saldoNuevo;
          }
        }
        await storage.update(listaCobranzas);
        await storage.update(cargosAbonosTemp);
        await Get.find<CobranzaMainController>().cargarListaCobranza();
        tool.toast("Se agregaron cargos de intereses");
        _cargarListaCargosAbonos();
      }
      await tool.wait(1);
      tool.isBusy(false);
    } catch(_) {
      tool.msg("Ocurrió un error al calcular intereses moratorios", 3);
    } finally {
      update();
    }
  }

  void _cargarOpcionesPopup() {
    try {
      opcionesConsulta = [];
      for (var i = 0; i < opcionesBase.length; i++) {
        var opciones = opcionesBase[i].split("~");
        if((opciones[0] == "Ajustar saldo" || opciones[0] == "Filtro Manual") && (cobranzaEditar!.bloqueado == Literals.bloqueoSi && esAdmin)) {
          continue;
        }
        opcionesConsulta.add(MenuPopupOpciones(
          id: i.toString(),
          value: opciones[0],
          tipo: opciones[1],
          icono: opcionesIcono[i],
        ));
      }
      update();
    } finally { }
  }

  void _limpiaForm() {
    cantidad.text = "";
    referencia.text = "";
  }
}