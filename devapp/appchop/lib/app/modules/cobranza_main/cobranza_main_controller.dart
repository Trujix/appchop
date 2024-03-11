import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:appchop/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../data/models/cobranza_popup_opciones.dart';
import '../../data/models/local_storage/categorias.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/texts/combo_texts.dart';

class CobranzaMainController extends GetInjection {
  ScrollController scrollController = ScrollController();
  List<BottomSheetAction> listaCategoria = [];
  String categoriaSelected = "";
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

  List<Cobranzas> listaCobranzas = [];
  List<Cobranzas> _listaCobranzaBusqueda = [];

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  Future<void> _init() async {
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    await _configurarCategorias(localStorage);
    _cargarOpcionesPopup();
    await cargarListaCobranza();
    return;
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

  Future<void> _configurarCategorias(LocalStorage localStorage) async {
    try {
      var categoriaStorage = List<Categorias>.from(
        storage.get([Categorias()]).map((json) => Categorias.fromJson(json))
      );
      categoria.text = Literals.defaultCategoriaTodoTxt;
      categoriaSelected = Literals.defaultCategoriaTodo;
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
    } finally { }
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