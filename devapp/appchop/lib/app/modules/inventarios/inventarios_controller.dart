import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../../data/models/local_storage/inventarios.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/menu_popup_opciones.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/columns/inventario_form_column.dart';
import '../../widgets/containers/basic_bottom_sheet_container.dart';
import '../../widgets/modals/gestion_csv_modal.dart';

class InventariosController extends GetInjection {
  ScrollController scrollController = ScrollController();
  ScrollController formScrollController = ScrollController();
  TextEditingController busqueda = TextEditingController();
  TextEditingController codigoArticulo = TextEditingController();
  FocusNode codigoArticuloFocus = FocusNode();
  TextEditingController descripcion = TextEditingController();
  FocusNode descripcionFocus = FocusNode();
  TextEditingController precioCompra = TextEditingController();
  FocusNode precioCompraFocus = FocusNode();
  TextEditingController precioVenta = TextEditingController();
  FocusNode precioVentaFocus = FocusNode();
  TextEditingController existencia = TextEditingController();
  FocusNode existenciaFocus = FocusNode();
  TextEditingController maximo = TextEditingController();
  FocusNode maximoFocus = FocusNode();
  TextEditingController minimo = TextEditingController();
  FocusNode minimoFocus = FocusNode();

  List<Inventarios> inventariosLista = [];
  List<Inventarios> _inventariosListaImportados = [];
  String opcionSelected = "";
  List<String> opcionesBase = [
    "Descripcion~R",
    "Codigo~R",
    "Precio Venta~R",
    "Existencias~R",
    "Importar~B",
    "Exportar~B"
  ];
  List<MenuPopupOpciones> opcionesConsulta = [];
  List<IconData?> opcionesIcono = [
    null, null, null, null,
    MaterialIcons.file_upload,
    MaterialIcons.file_download,
  ];
  int totalElementosInventario = 0;
  bool elementosImportados = false;
  bool editandoElemento = false;

  int opcionInventarioSeleccion = 0;
  
  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    await cargarListaInventario();
    _cargarOpcionesPopup();
  }

  Future<void> opcionInventarioSeleccionar(int opcion) async {
    if(elementosImportados) {
      return;
    }
    opcionInventarioSeleccion = opcion;
    update();
    await cargarListaInventario();
  }

  Future<void> cargarListaInventario() async {
    try {
      var inventarioStorage = List<Inventarios>.from(
        storage.get([Inventarios()]).map((json) => Inventarios.fromJson(json))
      );
      if(opcionInventarioSeleccion == 1) {
        inventarioStorage = inventarioStorage.where((i) => i.existencia! <= i.minimo!).toList();
      }
      inventariosLista = inventarioStorage;
    } finally {
      update();
    }
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

  Future<void> operacionPopUp(String id) async {
    switch(id) {
      case "4":
        await importarInventario();
        break;
      case "5":
        await exportarInventario();
        break;
      default:
        return;
    }
  }

  Future<void> limpiarBusquedaTexto() async {
    busqueda.clear();
    await cargarListaInventario();
  }

  void nuevoArticuloInventario() {
    editandoElemento = false;
    _limpiarForm(null);
    _abrirForm();
  }

  Future<void> importarInventario() async {
    try {
      elementosImportados = false;
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var csvArhivo = await tool.abrirCsv();
      if(csvArhivo == "") {
        return;
      }
      busqueda.clear();
      opcionInventarioSeleccion = 0;
      var csvInventario = csvArhivo.split("\n");
      inventariosLista = [];
      var primer = true;
      for(var inventario in csvInventario) {
        if(primer) {
          primer = false;
          continue;
        }
        var elementos = inventario.split(",");
        if(elementos.length == 1) {
          continue;
        }
        var verificar = inventariosLista.where((i) => i.codigoArticulo == elementos[0]).firstOrNull;
        if(verificar != null) {
          continue;
        }
        var idArticulo = tool.guid();
        inventariosLista.add(
          Inventarios(
            idUsuario: localStorage.idUsuario,
            idArticulo: idArticulo,
            codigoArticulo: elementos[0],
            descripcion: elementos[1],
            precioCompra: tool.str2double(elementos[2]),
            precioVenta: tool.str2double(elementos[3]),
            existencia: tool.str2double(elementos[4]),
            maximo: tool.str2double(elementos[5]),
            minimo: tool.str2double(elementos[6]),
            fechaCambio: elementos[7],
          ),
        );
        _inventariosListaImportados = inventariosLista;
      }
      if(inventariosLista.isEmpty) {
        tool.msg("No se encontraron elementos en la importación");
        return;
      }
      elementosImportados = true;
    } catch(e) {
      inventariosLista = [];
      tool.msg("No fue posible importar el documento (revise el formato que sea el correcto)", 3);
    } finally {
      update();
    }
  }

  Future<void> exportarInventario() async {
    try {
      if(elementosImportados) {
        tool.msg("Esta información no puede ser exportada");
        return;
      }
      if(inventariosLista.isEmpty) {
        tool.msg("No tiene información de inventario para exportar");
        return;
      }
      var contenido = tool.inventarioCsv(
        inventariosLista,
        ["tabla", "idUsuario", "idArticulo",]
      );
      var archivoCsv = await tool.crearArchivo(contenido, Literals.reporteInventariosCsv);
      await Future.delayed(0.7.seconds);
      tool.modal(
        widgets: [GestionCsvModal(
          abrirAccion: () async => await OpenFile.open(archivoCsv),
          exportarAccion: () async => await tool.compartir(archivoCsv!, Literals.reporteCobranzaCsv),
        ),]
      );
    } catch(e) {
      tool.msg("Ocurrió un error al intentar exportar información de inventario", 3);
    } finally { }
  }

  Future<void> guardarElementoInventario() async {
    try {
      tool.isBusy();
      var articulo = nuevoElementoFromForm();
      if(editandoElemento) {
        for (var i = 0; i < inventariosLista.length; i++) {
          if(inventariosLista[i].codigoArticulo == articulo.codigoArticulo) {
            inventariosLista[i] = articulo;
            break;
          }
        }
      } else {
        inventariosLista.add(articulo);
      }
      await storage.update(inventariosLista);
      await cargarListaInventario();
      await Future.delayed(1.seconds);
      tool.closeBottomSheet();
      tool.msg("Artículo agregado al inventario correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar guardar nuevo artículo", 3);
    } finally {
      update();
    }
  }

  Future<void> agregarElementoInventario() async {
    try {
      var articulo = nuevoElementoFromForm();
      if(editandoElemento) {
        for (var i = 0; i < inventariosLista.length; i++) {
          if(inventariosLista[i].codigoArticulo == articulo.codigoArticulo) {
            inventariosLista[i] = articulo;
            break;
          }
        }
      } else {
        inventariosLista.add(articulo);
      }
      tool.closeBottomSheet();
    } catch(e) {
      tool.msg("Ocurrió un error al intentar agregar artículo al inventario", 3);
    } finally {
      update();
    }
  }

  Future<void> editarElementoInventario(Inventarios inventario) async {
    try {
      editandoElemento = true;
      _limpiarForm(inventario);
      _abrirForm();
    } catch(e) {
      tool.msg("Ocurrió un error al intentar editar artículo del inventario", 3);
    } finally { }
  }

  Future<void> borrarElementoInventario(Inventarios inventario) async {
    try {
      var validar = await tool.ask("Eliminar elemento", "Codigo: ${inventario.codigoArticulo}\n¿Desea continuar?");
      if(!validar) {
        return;
      }
      inventariosLista.removeWhere((i) => i.codigoArticulo == inventario.codigoArticulo);
      if(!elementosImportados) {
        if(inventariosLista.isNotEmpty) {
          await storage.update(inventariosLista);
        } else {
          var _ = await storage.put([Inventarios()]);
        }
      } else {
        if(inventariosLista.isEmpty) {
          elementosImportados = false;
          await cargarListaInventario();
        }
      }
    } catch(e) {
      tool.msg("Ocurrió un error al intentar remover elemento de inventario", 3);
    } finally {
      update();
    }
  }

  Future<void> agregarImportacion() async {
    try {
      await _validarBusquedaEscrita();
      var validar = await tool.ask(
        "Agregar ${_inventariosListaImportados.length} elemento${(_inventariosListaImportados.length > 1 ?  "s" : "")}",
        "Los elementos repetidos serán omitidos\n¿Desea continuar?"
      );
      if(!validar) {
        return;
      }
      tool.isBusy(true);
      elementosImportados = false;
      var inventarioStorage = List<Inventarios>.from(
        storage.get([Inventarios()]).map((json) => Inventarios.fromJson(json))
      );
      for(var inventarioNuevo in inventariosLista) {
        var verificar = inventarioStorage.where((i) => i.codigoArticulo == inventarioNuevo.codigoArticulo).firstOrNull;
        if(verificar != null) {
          continue;
        }
        inventarioStorage.add(inventarioNuevo);
      }
      await storage.update(inventarioStorage);
      await Future.delayed(1.seconds);
      await cargarListaInventario();
      tool.msg("Artículo agregado al inventario correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar reemplazar elemento de inventario", 3);
    } finally {
      update();
    }
  }

  Future<void> reemplazarImportacion() async {
    try {
      await _validarBusquedaEscrita();
      var validar = await tool.ask("Reemplazar Inventario", "TODOS los elementos del actual inventario se sustituirán\n¿Desea continuar?");
      if(!validar) {
        return;
      }
      tool.isBusy();
      elementosImportados = false;
      await storage.update(inventariosLista);
      await Future.delayed(1.seconds);
      tool.isBusy(false);
      tool.msg("Inventario actualizado correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar reemplazar elemento de inventario", 3);
    } finally {
      update();
    }
  }

  Future<void> cancelarImportar() async {
    try {
      await _validarBusquedaEscrita();
      var cancelar = await tool.ask("Cancelar Importación", "¿Desea continuar?");
      if(!cancelar) {
        return;
      }
      elementosImportados = false;
      await cargarListaInventario();
    } catch(e) {
      return;
    }
  }

  void cerrar() {
    Get.back();
  }

  Inventarios nuevoElementoFromForm() {
    var idArticulo = tool.guid();
    return Inventarios(
      idArticulo: idArticulo,
      codigoArticulo: codigoArticulo.text,
      descripcion: descripcion.text,
      precioCompra: tool.str2double(precioCompra.text),
      precioVenta: tool.str2double(precioVenta.text),
      existencia: tool.str2double(existencia.text),
      maximo: tool.str2double(maximo.text),
      minimo: tool.str2double(minimo.text),
      fechaCambio: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
    );
  }

  bool validarForm() {
    var correcto = false;
    var mensaje = "";
    var verificarArticulo = inventariosLista.where((i) => i.codigoArticulo == codigoArticulo.text).firstOrNull;
    if(tool.isNullOrEmpty(codigoArticulo)) {
      mensaje = "Escriba el código artículo";
    } else if(verificarArticulo != null && !editandoElemento) {
      mensaje = "Ya existe un artículo con ese código";
    } else if(tool.isNullOrEmpty(descripcion)) {
      mensaje = "Escriba la descripción";
    } else if(tool.isNullOrEmpty(precioCompra)) {
      mensaje = "Escriba el precio de compra";
    } else if(tool.isNullOrEmpty(precioVenta)) {
      mensaje = "Escriba el precio de venta";
    } else if(tool.isNullOrEmpty(existencia)) {
      mensaje = "Escriba las existencias";
    } else if(tool.isNullOrEmpty(maximo)) {
      mensaje = "Escriba el máximo";
    } else if(tool.isNullOrEmpty(minimo)) {
      mensaje = "Escriba el mínimo";
    } else {
      correcto = true;
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }

  void _cargarOpcionesPopup() {
    try {
      opcionesConsulta = [];
      for (var i = 0; i < opcionesBase.length; i++) {
        var opciones = opcionesBase[i].split("~");
        if(opcionSelected == "" && opciones[1] == "R") {
          opcionSelected = i.toString();
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

  void _limpiarForm(Inventarios? inventario) {
    if(editandoElemento) {
      codigoArticulo.text = inventario!.codigoArticulo!;
      descripcion.text = inventario.descripcion!;
      precioCompra.text = inventario.precioCompra!.toString();
      precioVenta.text = inventario.precioVenta!.toString();
      existencia.text = inventario.existencia!.toString();
      maximo.text = inventario.maximo!.toString();
      minimo.text = inventario.minimo!.toString();
    } else {
      codigoArticulo.clear();
      descripcion.clear();
      precioCompra.clear();
      precioVenta.clear();
      existencia.clear();
      maximo.clear();
      minimo.clear();
    }
  }

  void _abrirForm() {
    var context = Get.context!;
    showMaterialModalBottomSheet(
      context: context,
      expand: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return BasicBottomSheetContainer(
          context: context,
          cerrar: true,
          child: InventarioFormColumn(
            codigoArticulo: codigoArticulo,
            codigoArticuloFocus: codigoArticuloFocus,
            descripcion: descripcion,
            descripcionFocus: descripcionFocus,
            precioCompra: precioCompra,
            precioCompraFocus: precioCompraFocus,
            precioVenta: precioVenta,
            precioVentaFocus: precioVentaFocus,
            existencia: existencia,
            existenciaFocus: existenciaFocus,
            maximo: maximo,
            maximoFocus: maximoFocus,
            minimo: minimo,
            minimoFocus: minimoFocus,
            elementosImportados: elementosImportados,
            editandoElemento: editandoElemento,
            validarForm: validarForm,
            agregarElementoInventario: agregarElementoInventario,
            guardarElementoInventario: guardarElementoInventario,
          ),
        );
      }),
    );
  }

  Future<void> _validarBusquedaEscrita() async {
    if(busqueda.text == "") {
      return;
    }
    busqueda.clear();
    inventariosLista = _inventariosListaImportados;
  }
}