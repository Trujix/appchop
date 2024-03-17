import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../data/models/cobranza_popup_opciones.dart';
import '../../data/models/local_storage/categorias.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../routes/app_routes.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/texts/combo_texts.dart';
import '../pdf_viewer/pdf_viewer_binding.dart';
import '../pdf_viewer/pdf_viewer_page.dart';

class CobranzaMainController extends GetInjection {
  ScrollController scrollController = ScrollController();
  TextEditingController categoria = TextEditingController();
  TextEditingController busqueda = TextEditingController();
  List<CobranzaPopupOpciones> opcionesConsulta = [];
  String opcionSelected = "";
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

  void opcionPopupConsulta(String? id) {
    opcionSelected = id!;
    update();
  }

  void busquedaCobranzas(String? valor) async {
    await cargarListaCobranza();
    var busqueda = _listaCobranzaBusqueda.where((c) {
      var query = "";
      if(opcionSelected == "0") {
        query = c.nombre!.toLowerCase();
      } else if(opcionSelected == "1") {
        query = c.fechaRegistro!.toLowerCase();
      } else if(opcionSelected == "2") {
        query = c.cantidad!.toString().toLowerCase();
      } else if(opcionSelected == "3") {
        query = c.fechaVencimiento!.toLowerCase();
      }
      return query.contains(valor!.toLowerCase());
    }).toList();
    listaCobranzas = busqueda;
    update();
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
      mostrarResultados = cobranzaStorage.isNotEmpty;
    } catch(e) {
      tool.msg("Ocurrió un error al cargar la lista de cobranza", 3);
    } finally {
      update();
    }
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