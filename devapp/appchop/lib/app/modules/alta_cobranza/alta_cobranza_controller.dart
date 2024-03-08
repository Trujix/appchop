import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/local_storage/categorias.dart';
import '../../utils/get_injection.dart';
import '../../widgets/texts/combo_texts.dart';

class AltaCobranzaController extends GetInjection {
  String tipoCobranza = "";
  List<String> valuesTipoCobranza = ["ME_DEBEN", "DEBO",];
  List<String> labelsTipoCobranza = ['Me deben', 'Debo',];

  List<BottomSheetAction> listaCategoria = [];

  TextEditingController nombre = TextEditingController();
  FocusNode nombreFocus = FocusNode();
  TextEditingController cantidad = TextEditingController();
  FocusNode cantidadFocus = FocusNode();
  TextEditingController categoria = TextEditingController();
  TextEditingController fechaRegistro = TextEditingController();

  TextEditingController descripcion = TextEditingController();
  FocusNode descripcionFocus = FocusNode();
  TextEditingController telefono = TextEditingController();
  FocusNode telefonoFocus = FocusNode();
  TextEditingController direccion = TextEditingController();
  FocusNode direccionFocus = FocusNode();
  TextEditingController email = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode fechaRegistroFocus = FocusNode();
  TextEditingController fechaVencimiento = TextEditingController();
  FocusNode fechaVencimientoFocus = FocusNode();

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    fechaRegistro.text = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
    var categorias = List<Categorias>.from(
      storage.get([Categorias()]).map((json) => Categorias.fromJson(json))
    );
    listaCategoria = [];
    for(var categoriaItem in categorias) {
      if(categoria.text == "") {
        categoria.text = categoriaItem.labelCategoria!;
      }
      listaCategoria.add(
        BottomSheetAction(
          title: ComboText(
            texto: categoriaItem.labelCategoria!,
          ),
          onPressed: (context) {
            categoria.text = categoriaItem.labelCategoria!;
            update();
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  void cerrar() {
    Get.back();
  }

  Future<void> abrirContactos() async {
    await Permission.contacts.isDenied.then((denegado) async {
      if (denegado) {
        Permission.contacts.request();
      } else {
        try {
          var contact = await FlutterContactPicker.pickFullContact();
          nombre.text = contact.name!.firstName!;
          telefono.text = contact.phones[0].number!.replaceAll(" ", "");
        } catch(e) {
          tool.msg("No fue posible cargar los datos del contacto seleccionado", 2);
        }
      }
    });
  }

  Future<void> guardarNuevaCobranza() async {

  }

  void cobranzaSelected(String tipo) {
    tipoCobranza = tipo;
  }

  void dateSelected() {
    update();
  }
}