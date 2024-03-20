import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../data/models/cobranza_popup_opciones.dart';
import '../../data/models/local_storage/categorias.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../routes/app_routes.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/modals/gestion_csv_modal.dart';
import '../../widgets/texts/combo_texts.dart';
import '../pdf_viewer/pdf_viewer_binding.dart';
import '../pdf_viewer/pdf_viewer_page.dart';

class CobranzaMainController extends GetInjection {
  ScrollController scrollController = ScrollController();
  TextEditingController categoria = TextEditingController();
  TextEditingController busqueda = TextEditingController();
  List<CobranzaPopupOpciones> opcionesConsulta = [];
  String opcionSelected = "";
  String saldoTotal = "\$ 0.00";
  List<String> opcionesBase = [
    "Nombre~R",
    "Fecha~R",
    "Saldo~R",
    "Vencimiento~R",
    "Notas Pagadas~B",
    "Exportar~B"
  ];
  List<String> tiposCobranza = [
    Literals.tipoCobranzaMeDeben,
    Literals.tipoCobranzaDebo,
    Literals.tipoCobranzaVencida,
  ];
  List<IconData?> opcionesIcono = [
    null, null, null, null,
    MaterialIcons.attach_money,
    MaterialIcons.get_app,
  ];
  bool mostrarResultados = false;
  int opcionDeudaSeleccion = 0;

  List<BottomSheetAction> listaCategoria = [];
  String categoriaSelected = "";
  List<String> categoriasOff = [];

  List<Cobranzas> listaCobranzas = [];
  List<Cobranzas> _listaCobranzaBusqueda = [];
  List<Cobranzas> _listaCobranzaCsv = [];

  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
    return;
  }

  @override
  Future<void> onReady() async {
    await _ready();
    super.onReady();
    return;
  }

  Future<void> _init() async {
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    await configurarCategorias(localStorage);
    _cargarOpcionesPopup();
    await cargarListaCobranza();
    return;
  }

  Future<void> _ready() async {
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    if(localStorage.acepta == 0) {
      var archivo = await tool.downloadPdf(
        "${Literals.uri}${Literals.terminosCondicionesFile}"
      );
      Get.to(
        const PdfViewerPage(),
        binding: PdfViewerBinding(),
        arguments: {
          "salir": false,
          "archivo": archivo,
          "descripcion": "Términos y condiciones",
          "tipo": "TYC",
        },
        transition: Transition.downToUp,
      );
    }
  }

  void altaCobranza() {
    Get.toNamed(
      AppRoutes.altaCobranza,
      arguments: {
        "tipoCobranza": opcionDeudaSeleccion > 1
          ? Literals.tipoCobranzaMeDeben
          : tiposCobranza[opcionDeudaSeleccion],
      },
    );
  }

  Future<void> opcionDeudaSeleccionar(int opcion) async {
    opcionDeudaSeleccion = opcion;
    update();
    await cargarListaCobranza();
  }

  Future<void> opcionPopupConsulta(String? id) async {
    var clicks = [];
    for (var i = 0; i < opcionesBase.length; i++) {
      if(opcionesBase[i].indexOf("~B") > 0) {
        clicks.add(i.toString());
      }
    }
    if(clicks.contains(id)) {
      return await operacionPopUp(id!);
    }
    opcionSelected = id!;
    update();
  }

  void busquedaCobranzas(String? valor) async {
    await cargarListaCobranza();
    var busqueda = _listaCobranzaBusqueda.where((c) {
      var query = "";
      switch(opcionSelected) {
        case "0":
          query = c.nombre!.toLowerCase();
          break;
        case "1":
          query = c.fechaRegistro!.toLowerCase();
          break;
        case "2":
          query = c.cantidad!.toString().toLowerCase();
          break;
        case "3":
          query = c.fechaVencimiento!.toLowerCase();
          break;
      }
      return query.contains(valor!.toLowerCase());
    }).toList();
    listaCobranzas = busqueda;
    _listaCobranzaCsv = busqueda;
    _calcularSaldo();
    update();
  }

  Future<void> operacionPopUp(String id) async {
    switch(id) {
      case "4":
        break;
      case "5":
        await _exportarConsultaCsv();
        break;
      default:
        return;
    }
  }

  Future<void> cargarListaCobranza() async {
    try {
      var cobranzaStorage = List<Cobranzas>.from(
        storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
      );
      if(opcionDeudaSeleccion > 1) {
        cobranzaStorage = cobranzaStorage.where(
          (c) => c.fechaVencimiento != Literals.sinVencimiento 
            && tool.str2date(c.fechaVencimiento!).isBefore(DateTime.now())
        ).toList();
      } else {
        cobranzaStorage = cobranzaStorage.where(
          (c) => c.tipoCobranza == tiposCobranza[opcionDeudaSeleccion]
        ).toList();
      }
      if(categoriaSelected != Literals.defaultCategoriaTodo) {
        cobranzaStorage = cobranzaStorage.where(
          (c) => c.categoria == categoriaSelected
        ).toList();
      } else {
        cobranzaStorage = cobranzaStorage.where(
          (c) => !categoriasOff.contains(c.categoria)
        ).toList();
      }
      listaCobranzas = cobranzaStorage;
      _listaCobranzaBusqueda = cobranzaStorage;
      _listaCobranzaCsv = cobranzaStorage;
      mostrarResultados = cobranzaStorage.isNotEmpty;
      _calcularSaldo();
    } catch(e) {
      tool.msg("Ocurrió un error al cargar la lista de cobranza", 3);
    } finally {
      update();
    }
  }

  void _calcularSaldo() {
    var saldo = 0.0;
    for(var cobranza in listaCobranzas) {
      saldo +=  cobranza.saldo!;
    }
    saldoTotal = "\$ ${saldo.toStringAsFixed(2)}";
  }

  Future<void> configurarCategorias(LocalStorage localStorage) async {
    try {
      var categoriaStorage = List<Categorias>.from(
        storage.get([Categorias()]).map((json) => Categorias.fromJson(json))
      );
      categoria.text = Literals.defaultCategoriaTodoTxt;
      categoriaSelected = Literals.defaultCategoriaTodo;
      categoriasOff = [];
      listaCategoria = [
        BottomSheetAction(
          title: const ComboText(
            texto: Literals.defaultCategoriaTodoTxt,
          ),
          onPressed: (context) {
            categoria.text = Literals.defaultCategoriaTodoTxt;
            categoriaSelected = Literals.defaultCategoriaTodo;
            update();
            cargarListaCobranza();
            Navigator.of(context).pop();
          },
        ),
        BottomSheetAction(
          title: const ComboText(
            texto: Literals.defaultCategoriaSinTxt,
          ),
          onPressed: (context) {
            categoria.text = Literals.defaultCategoriaSinTxt;
            categoriaSelected = Literals.defaultCategoriaSin;
            update();
            cargarListaCobranza();
            Navigator.of(context).pop();
          },
        ),
      ];
      for(var categoriaItem in categoriaStorage) {
        if(!categoriaItem.activo!) {
          categoriasOff.add(categoriaItem.valueCategoria!);
          continue;
        }
        listaCategoria.add(
          BottomSheetAction(
            title: ComboText(
              texto: categoriaItem.labelCategoria!,
            ),
            onPressed: (context) {
              categoria.text = categoriaItem.labelCategoria!;
              categoriaSelected = categoriaItem.valueCategoria!;
              update();
              cargarListaCobranza();
              Navigator.of(context).pop();
            },
          ),
        );
      }
      return;
    } finally {
      update();
    }
  }

  void mensajeCobranzaElemento() {
    tool.toast("Deje presionado para editar");
  }

  void editarCobranzaElemento(Cobranzas cobranza) {
    Get.toNamed(
      AppRoutes.altaCobranza,
      arguments: {
        "nuevo": false,
        "tipoCobranza": Literals.tipoCobranzaMeDeben,
        "cobranza" : cobranza,
      },
    );
  }

  Future<void> _exportarConsultaCsv() async {
    try {
      if(_listaCobranzaCsv.isEmpty) {
        tool.msg("No hay datos que exportar", 0);
        return;
      }
      var categoriaStorage = List<Categorias>.from(
        storage.get([Categorias()]).map((json) => Categorias.fromJson(json))
      );
      var contenido = tool.cobranzaCsv(
        listaCobranzas,
        categoriaStorage,
        ["tabla", "idUsuario", "idCobranza", "idCobrador", "latitud", "longitud", "estatus",]
      );
      var archivoCsv = await tool.crearArchivo(contenido, Literals.reporteCobranzaCsv);
      await Future.delayed(0.7.seconds);
      tool.modal(
        widgets: [GestionCsvModal(
          abrirAccion: () async => await OpenFile.open(archivoCsv),
          exportarAccion: () {}/*async => await tool.compartir(archivoCsv!, Literals.reporteCobranzaCsv)*/,
        ),]
      );
    } catch(e) {
      tool.msg("Ocurrió un problema al intentar exportar la información", 3);
    }
  }

  void _cargarOpcionesPopup() {
    try {
      for (var i = 0; i < opcionesBase.length; i++) {
        var opciones = opcionesBase[i].split("~");
        if(opcionSelected == "" && opciones[1] == "R") {
          opcionSelected = i.toString();
        }
        opcionesConsulta.add(CobranzaPopupOpciones(
          id: i.toString(),
          value: opciones[0],
          tipo: opciones[1],
          icono: opcionesIcono[i],
        ));
      }
      update();
    } finally { }
  }
}