import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/get_injection.dart';

class AltaCobranzaController extends GetInjection { 
  TextEditingController nombre = TextEditingController();
  FocusNode nombreFocus = FocusNode();
  TextEditingController telefono = TextEditingController();
  FocusNode telefonoFocus = FocusNode();
  TextEditingController categoria = TextEditingController();
  TextEditingController fechaRegistro = TextEditingController();
  FocusNode fechaRegistroFocus = FocusNode();
  TextEditingController fechaVencimiento = TextEditingController();
  FocusNode fechaVencimientoFocus = FocusNode();

  List<BottomSheetAction> listaCategoria = [];

  String tipoCobranza = "";
  List<String> valuesTipoCobranza = ["ME_DEBEN", "DEBO",];
  List<String> labelsTipoCobranza = ['Me deben', 'Debo',];

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    fechaRegistro.text = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
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