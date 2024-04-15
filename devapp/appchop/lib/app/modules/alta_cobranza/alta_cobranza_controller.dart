import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/local_storage/zonas.dart';
import '../../data/models/local_storage/cobranzas.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/texts/combo_texts.dart';
import '../cobranza_main/cobranza_main_controller.dart';

class AltaCobranzaController extends GetInjection {
  String tipoCobranza = "";
  List<String> valuesTipoCobranza = [
    Literals.tipoCobranzaMeDeben,
    Literals.tipoCobranzaDebo,
  ];
  List<String> labelsTipoCobranza = ['Me deben', 'Debo',];

  List<BottomSheetAction> listaZona = [];
  String zonaSelected = "";
  bool nuevo = true;
  Cobranzas cobranzaEditar = Cobranzas();

  TextEditingController nombre = TextEditingController();
  FocusNode nombreFocus = FocusNode();
  TextEditingController cantidad = TextEditingController();
  FocusNode cantidadFocus = FocusNode();
  TextEditingController zona = TextEditingController();
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

  CustomInfoWindowController googleController = CustomInfoWindowController();
  LatLng initLocation = const LatLng(19.24245061908023, -103.7252647480106);
  Map<MarkerId, Marker> marcadorCliente = {};
  String idMarcadorCliente = "";
  bool utilizarUbicacionCliente = false;

  bool esAdmin = GetInjection.administrador;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    var arguments = Get.arguments;
    nuevo = arguments['nuevo'] ?? true;
    fechaRegistro.text = DateFormat("dd-MM-yyyy").format(DateTime.now()).toString();
    var zonas = List<Zonas>.from(
      storage.get([Zonas()]).map((json) => Zonas.fromJson(json))
    );
    listaZona = [BottomSheetAction(
      title: const ComboText(
        texto: Literals.defaultZonaSinTxt,
      ),
      onPressed: (context) {
        zona.text = Literals.defaultZonaSinTxt;
        zonaSelected = Literals.defaultZonaSin;
        update();
        Navigator.of(context).pop();
      },
    )];
    zona.text = Literals.defaultZonaSinTxt;
    zonaSelected = Literals.defaultZonaSin;
    for(var zonaItem in zonas) {
      if(!zonaItem.activo!) {
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
            Navigator.of(context).pop();
          },
        ),
      );
    }
    tipoCobranza = arguments['tipoCobranza'] as String;
    crearClienteMarcador(initLocation);
    if(!nuevo) {
      cobranzaEditar = arguments['cobranza'] as Cobranzas;
      _editarCobranzaFill(zonas);
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

  void abrirCalculadora() {
    tool.calculadora();
  }

  Future<void> guardarNuevaCobranza() async {
    try {
      if(!_validarForm()) {
        return;
      }
      tool.isBusy(true);
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var cobranzaStorage = List<Cobranzas>.from(
        storage.get([Cobranzas()]).map((json) => Cobranzas.fromJson(json))
      ); 
      var vencimiento = fechaVencimiento.text;
      var latLng = marcadorCliente[MarkerId(idMarcadorCliente)]!.position;
      var nuevaCobranza = Cobranzas(
        idUsuario: localStorage.idUsuario,
        tipoCobranza: tipoCobranza,
        zona: zonaSelected,
        nombre: nombre.text,
        cantidad: tool.str2double(cantidad.text),
        descripcion: descripcion.text,
        telefono: telefono.text,
        direccion: direccion.text,
        correo: email.text,
        fechaRegistro: fechaRegistro.text,
        latitud: utilizarUbicacionCliente ? latLng.latitude.toString() : "",
        longitud: utilizarUbicacionCliente ? latLng.longitude.toString() : "",
        fechaVencimiento: vencimiento == "" ? Literals.sinVencimiento : vencimiento,
        saldo: tool.str2double(cantidad.text),
        ultimoCargo: tool.str2double(cantidad.text),
        fechaUltimoCargo: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
        usuarioUltimoCargo: esAdmin ? Literals.perfilAdministrador : localStorage.email,
      );
      if(nuevo) {
        nuevaCobranza.saldo = tool.str2double(cantidad.text);
        nuevaCobranza.idCobranza = tool.guid();
        cobranzaStorage.add(nuevaCobranza);
      } else {
        nuevaCobranza.saldo = cobranzaEditar.saldo;
        var index = cobranzaStorage.indexWhere((c) => c.idCobranza == cobranzaEditar.idCobranza!);
        nuevaCobranza.idCobranza = cobranzaEditar.idCobranza!;
        cobranzaStorage[index] = nuevaCobranza;
      }
      await storage.update(cobranzaStorage);
      await Future.delayed(1.seconds);
      tool.isBusy(false);
      await Get.find<CobranzaMainController>().cargarListaCobranza();
      Get.back();
      tool.msg("Registro ${(nuevo ? "creado" : "modificado")} correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un error al intentar crear nueva cobranza", 3);
    } finally {
      
    }
  }

  void cobranzaSelected(String tipo) {
    tipoCobranza = tipo;
  }

  Future<bool> abrirMapa() async {
    await Permission.locationWhenInUse.isDenied.then((denegado) {
      if(denegado) {
        Permission.locationWhenInUse.request();
        return false;
      }
    });
    return true;
  }

  void crearClienteMarcador(LatLng position) {
    marcadorCliente.clear();
    idMarcadorCliente = tool.guid();
    var marcador = Marker(
      markerId: MarkerId(idMarcadorCliente),
      position: position,
    );
    marcadorCliente[MarkerId(idMarcadorCliente)] = marcador;
    initLocation = position;
    update();
  }

  void seleccionarUbicacionCliente(bool value) {
    utilizarUbicacionCliente = value;
    update();
  }

  void dateSelected() {
    update();
  }

  void _editarCobranzaFill(List<Zonas> zonas) {
    var vencimiento = cobranzaEditar.fechaVencimiento!;
    tipoCobranza = cobranzaEditar.tipoCobranza!;
    nombre.text = cobranzaEditar.nombre!;
    cantidad.text = cobranzaEditar.cantidad!.toStringAsFixed(2);
    descripcion.text = cobranzaEditar.descripcion!;
    telefono.text = cobranzaEditar.telefono!;
    direccion.text = cobranzaEditar.direccion!;
    email.text = cobranzaEditar.correo!;
    fechaRegistro.text = cobranzaEditar.fechaRegistro!;
    fechaVencimiento.text = vencimiento == Literals.sinVencimiento ? "" : vencimiento;
    tipoCobranza = cobranzaEditar.tipoCobranza!;
    zonaSelected = cobranzaEditar.zona!;
    var zonaEdicion = zonas.where((c) => c.valueZona == cobranzaEditar.zona).firstOrNull;
    if(zonaEdicion != null) {
      zona.text = zonaEdicion.labelZona!;
      zonaSelected = zonaEdicion.valueZona!;
    }
    if(cobranzaEditar.latitud != "" && cobranzaEditar.longitud != "") {
      utilizarUbicacionCliente = true;
      var editarPosicion = LatLng(
        tool.str2double(cobranzaEditar.latitud!),
        tool.str2double(cobranzaEditar.longitud!),
      );
      crearClienteMarcador(editarPosicion);
    }
    update();
  }

  bool _validarForm() {
    var correcto = false;
    var mensaje = "";
    if(tool.isNullOrEmpty(nombre)) {
      mensaje = "Escriba el nombre";
    } else if(tool.isNullOrEmpty(cantidad)) {
      mensaje = "Escriba la cantidad";
    } else if(tool.str2double(cantidad.text) == 0) {
      mensaje = "Cantidad incorrecta";
    } else {
      correcto = true;
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }
}