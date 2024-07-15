import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../data/models/local_storage/cargos_abonos.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/zonas.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/modals/gestion_csv_modal.dart';
import '../../widgets/texts/combo_texts.dart';

class ReporteCargoAbonoController extends GetInjection {
  ScrollController scrollController = ScrollController();
  TextEditingController zona = TextEditingController();
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
  double totalConsulta = 0;

  List<BottomSheetAction> listaZona = [];
  String zonaSelected = "";
  List<String> zonasOff = [];

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
    configurarComboZonas();
    mostrarCargosAbonos();
  }

  void cerrar() {
    Get.back();
  }

  void mostrarCargosAbonos() {
    try {
      totalConsulta = 0;
      var cargosAbonos = List<CargosAbonos>.from(
        storage.get([CargosAbonos()]).map((json) => CargosAbonos.fromJson(json))
      );
      cargosAbonos = cargosAbonos.where((ca) => 
        tool.str2date(ca.fechaRegistro!).isAfter(tool.str2date(fechaInicio.text).add(-1.days))
        && tool.str2date(ca.fechaRegistro!).isBefore(tool.str2date(fechaFin.text).add(1.days))
        && ca.tipo == tipoSelected
      ).toList();
      if(zonaSelected != Literals.defaultZonaTodo) {
        List<String> cobranzasIds = [];
        var cobranzas = List<Cobranzas>.from(
          storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
        );
        var cobranzasZona = cobranzas.where((c) => c.zona == zonaSelected).toList();
        for(var cobranza in cobranzasZona) {
          cobranzasIds.add(cobranza.idCobranza!);
        }
        cargosAbonos = cargosAbonos.where((ca) => cobranzasIds.contains(ca.idCobranza)).toList();
      }
      listaCargosAbonos = cargosAbonos;
      for(var cargosAbonos in listaCargosAbonos) {
        totalConsulta += cargosAbonos.monto!;
      }
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

  void configurarComboZonas() {
    var zonaStorage = List<Zonas>.from(
        storage.get([Zonas()]).map((json) => Zonas.fromJson(json))
      );
      zona.text = esAdmin ? Literals.defaultZonaTodoV2Txt : (zonaStorage.isNotEmpty ? zonaStorage.first.labelZona! : "- Sin zonas -");
      zonaSelected = esAdmin ? Literals.defaultZonaTodo : (zonaStorage.isNotEmpty ? zonaStorage.first.valueZona! : "");
      zonasOff = [];
      listaZona = esAdmin ? [
        BottomSheetAction(
          title: const ComboText(
            texto: Literals.defaultZonaTodoV2Txt,
          ),
          onPressed: (context) {
            zona.text = Literals.defaultZonaTodoV2Txt;
            zonaSelected = Literals.defaultZonaTodo;
            update();
            mostrarCargosAbonos();
            Navigator.of(context).pop();
          },
        ),
      ] : [];
      for(var zonaItem in zonaStorage) {
        if(!zonaItem.activo!) {
          zonasOff.add(zonaItem.valueZona!);
          continue;
        }
        listaZona.add(
          BottomSheetAction(
            title: ComboText(
              texto: zonaItem.labelZona!,
            ),
            onPressed: (context) {
              zona.text = zonaItem.labelZona!;
              zonaSelected = zonaItem.valueZona!;
              update();
              mostrarCargosAbonos();
              Navigator.of(context).pop();
            },
          ),
        );
      }
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