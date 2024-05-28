import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../data/models/local_storage/cargos_abonos.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/modals/gestion_csv_modal.dart';

class ReporteCargoAbonoController extends GetInjection {
  ScrollController scrollController = ScrollController();

  TextEditingController fechaInicio = TextEditingController();
  FocusNode fechaInicioFocus = FocusNode();
  TextEditingController fechaFin = TextEditingController();
  FocusNode fechaFinFocus = FocusNode();

  List<CargosAbonos> listaCargosAbonos = [];

  List<String> labelsTipo = ["Abonos", "Cargos"];
  List<String> valuesTipo = [
    Literals.movimientoAbono,
    Literals.movimientoCargo,
  ];
  String tipoSelected = "";

  final bool esAdmin = GetInjection.administrador;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    tipoSelected = valuesTipo[0];
    fechaInicio.text = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
    fechaFin.text = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
    mostrarCargosAbonos();
  }

  void cerrar() {
    Get.back();
  }

  void mostrarCargosAbonos() {
    try {
      var cargosAbonos = List<CargosAbonos>.from(
        storage.get([CargosAbonos()]).map((json) => CargosAbonos.fromJson(json))
      );
      cargosAbonos = cargosAbonos.where((ca) => 
        tool.str2date(ca.fechaRegistro!).isAfter(tool.str2date(fechaInicio.text).add(-1.days))
        && tool.str2date(ca.fechaRegistro!).isBefore(tool.str2date(fechaFin.text).add(1.days))
        && ca.tipo == tipoSelected
      ).toList();
      listaCargosAbonos = cargosAbonos;
    } finally {
      update();
    }
  }

  Future<void> exportar() async {
    try {
      if(listaCargosAbonos.isEmpty) {
        tool.toast("No hay datos para exportar");
        return;
      }
      var contenido = tool.crearCsv(
        listaCargosAbonos,
        ["tabla", "idUsuario"]
      );
      var archivoCsv = await tool.crearArchivo(contenido, Literals.reporteInventariosCsv);
      await Future.delayed(0.7.seconds);
      tool.modal(
        widgets: [GestionCsvModal(
          abrirAccion: () async => await OpenFile.open(archivoCsv),
          exportarAccion: () async => await tool.compartir(archivoCsv!, Literals.reporteCargosAbonosCsv),
        ),]
      );
    } catch(e) {
      tool.msg("Ocurrió un error al intentar exportar información de cargos y abonos", 3);
    } finally { }
  }

  void dateSelected() {
    update();
    mostrarCargosAbonos();
  }

  void tipoSeleccion(String tipo) {
    tipoSelected = tipo;
    update();
    mostrarCargosAbonos();
  }
}