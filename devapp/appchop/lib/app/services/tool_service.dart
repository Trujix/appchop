import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pdfwidget;
import 'package:pdf/pdf.dart' as pdflib;

import '../data/models/local_storage/zonas.dart';
import '../data/models/local_storage/cobranzas.dart';
import '../utils/color_list.dart';
import '../utils/literals.dart';
import '../widgets/dialogs/alerta_dialog.dart';
import '../widgets/dialogs/loading_dialog.dart';
import '../widgets/dialogs/modal_dialog.dart';
import '../widgets/dialogs/pregunta_dialog.dart';
import '../widgets/simplecalculators/default_simplecalculator.dart';

class ToolService extends GetxController {
  bool _loadingOpen = false;
  final Connectivity _conneccion = Connectivity();

  void isBusy([bool open = true]) {
    try {
      var thisContext = Get.context;
      if(!open && _loadingOpen) {
        try {
          Navigator.pop(thisContext!);
        } finally { }
      }
      _loadingOpen = open;
      if(open) {
        showDialog(
          context: thisContext!,
          builder: (BuildContext context) {
            context = context;
            return const LoadingDialog();
          },
        );
      }
    } finally { }
  }

  Future<bool> isOnline() async {
    try {
      var coneccion = await _conneccion.checkConnectivity();
      var wifi = coneccion.contains(ConnectivityResult.wifi);
      var datosMobiles = coneccion.contains(ConnectivityResult.mobile);
      return wifi || datosMobiles;
    } catch(_) {
      return false;
    }
  }

  void msg(String mensaje, [int tipo = 0]) {
    try {
      var thisContext = Get.context;
      if(_loadingOpen) {
        isBusy(false);
      }
      List<IconData> iconos = [
        MaterialIcons.help,
        MaterialIcons.check_circle,
        MaterialIcons.warning,
        MaterialIcons.error,
      ];
      List<int> colores = [
        ColorList.theme[0],
        ColorList.theme[1],
        ColorList.theme[2],
        ColorList.theme[3],
      ];
      showDialog(
        context: thisContext!,
        builder: (BuildContext context) {
          context = context;
          return AlertaDialog(
            mensaje: mensaje,
            icono: iconos[tipo < 4 ? tipo : 0],
            color: colores[tipo < 4 ? tipo : 0],
          );
        },
      );
    } finally { }
  }

  void modal({
    List<Widget> widgets = const [],
    double height = 150
  }) {
    var modalContext = Get.context!;
    showDialog(
      context: modalContext,
      builder: (BuildContext context) {
        context = context;
        return ModalDialog(
          widgets: widgets,
          height: height,
        );
      },
    );
  }

  void modalClose() {
    var altaContext = Get.context!;
    Navigator.of(altaContext).pop(true);
  }

  void closeBottomSheet() {
    var altaContext = Get.context!;
    Navigator.of(altaContext, rootNavigator: true).pop(true);
  }

  Future<bool> ask(String mensaje, String pregunta, {String si = "Aceptar", String no = "Cancelar"}) async {
    try {
      var askDialog = Get.context!;
      bool respuesta = false;
      await showDialog(
        context: askDialog,
        builder: (BuildContext context) {
          context = context;
          return PreguntaDialog(
            mensaje: mensaje,
            pregunta: pregunta,
            siBoton: si,
            noBoton: no,
            respuesta: (resp) {
              respuesta = resp;
              Navigator.of(context).pop();
            },
          );
        }
      );
      return respuesta;
    } catch(e) {
      return false;
    }
  }

  void toast([String msg = ""]) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Color(ColorList.ui[0]),
      fontSize: 16.0,
      webShowClose: true,
    );
  }

  void toastClose() {
    try {
      Fluttertoast.cancel();
    } finally { }
  }

  void calculadora() {
    var calculadoraContext = Get.context!;
    showModalBottomSheet(
      context: calculadoraContext,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: const DefaultSimplecalculator(),
        );
      }
    );
  }

  bool isNullOrEmpty(TextEditingController? input) {
    return input?.text == "" || input == null;
  }

  bool isEmail(String cadena) {
    var esEmail = RegExp(Literals.regexEmail).hasMatch(cadena);
    return esEmail;
  }

  bool isInteger(num value) {
    return (value % 1) == 0;
  }

  bool soloSaltos(String texto) {
    var caracteres = texto.split("");
    var prohibidos = ["\n", " "];
    var letras = 0;
    for (var caracter in caracteres) {
      if(!prohibidos.contains(caracter)) {
        letras++;
      }
    }
    return letras == 0;
  }

  String cadenaAleatoria(int length, [String tipo = 'LNX']) {
    var randomGenerator = Random();
    var caracteresRandom = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    if(tipo == 'LNM') {
      caracteresRandom = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    } else if(tipo == 'LNm') {
      caracteresRandom = 'abcdefghijklmnopqrstuvwxyz1234567890';
    } else if(tipo == 'Lm') {
      caracteresRandom = 'abcdefghijklmnopqrstuvwxyz';
    } else if(tipo == 'LM') {
      caracteresRandom = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    } else if(tipo == 'N') {
      caracteresRandom = '1234567890';
    }
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => caracteresRandom.codeUnitAt(
          randomGenerator.nextInt(caracteresRandom.length)
        )
      )
    );
  }

  String guid() {
    const uuid = Uuid();
    var newGuid = uuid.v4();
    return newGuid;
  }

  bool isObject(dynamic data) {
    return isJson(data) || isArray(data) || isJsonArray(data);
  }

  bool isJson(dynamic elemento) {
    try {
      var jsonCadena = jsonEncode(elemento);
      return jsonCadena[jsonCadena.length - 1] == "}";
    } catch(e) {
      return false;
    }
  }

  bool isArray(dynamic elemento) {
    try {
      var jsonCadena = jsonEncode(elemento);
      return jsonCadena[jsonCadena.length -1] == "]";
    } catch(e) {
      return false;
    }
  }

  bool isJsonArray(dynamic data) {
    try {
      var cadAux = jsonEncode(data);
      var cadJson = cadAux[cadAux.length - 2] + cadAux[cadAux.length - 1];
      return cadJson == "}]";
    } catch(e) {
      return false;
    }
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  bool str2bool(String cadena) {
    return cadena.toLowerCase() == 'true';
  }

  double str2double(String cadena) {
    return double.tryParse(cadena) ?? 0.0;
  }

  int str2int(String cadena) {
    return int.tryParse(cadena) ?? 0;
  }

  DateTime str2date(String cadena) {
    var dateArr = cadena.split("-");
    return DateTime.utc(
      int.parse(dateArr[2]),
      int.parse(dateArr[1]),
      int.parse(dateArr[0])
    );
  }

  Future<void> wait([int segundos = 2]) async {
    await Future.delayed(Duration(seconds: segundos));
    return;
  }

  Future<String?> crearPdf(pdfwidget.Widget child, String nombreArchivo) async {
    var documento = pdfwidget.Document();
    documento.addPage(
      pdfwidget.MultiPage(
        pageTheme: const pdfwidget.PageTheme(
          pageFormat: pdflib.PdfPageFormat.letter,
          orientation: pdfwidget.PageOrientation.portrait,
        ),
        build: (context) => [pdfwidget.Padding(
          padding: const pdfwidget.EdgeInsets.only(right: 20),
          child: child,
        )],
      ),
    );
    var pdfArchivo = await documento.save();
    var directorio = await getApplicationDocumentsDirectory();
    var rutaArchivo = "${directorio.path}/$nombreArchivo";
    var pdf = File(rutaArchivo);
    await pdf.writeAsBytes(pdfArchivo, flush: true);
    return rutaArchivo;
  }

  String cobranzaCsv(
    List<Cobranzas> cobranzas,
    List<Zonas> zonas,
    List<String> omisiones
  ) {
    var listaElementos = jsonDecode(jsonEncode(cobranzas)) as List<dynamic>;
    var titulo = "";
    var addTitulo = true;
    var cuerpo = "";
    for (var cobranza in listaElementos) {
      var cobranzaMap = jsonDecode(jsonEncode(cobranza)) as Map<String, dynamic>;
      var cuerpoTemp = "";
      cobranzaMap.forEach((key, value) {
        if(!omisiones.contains(key)) {
          if(addTitulo) {
            if(titulo != "") {
              titulo += ",";
            }
            titulo += key.toUpperCase();
          }
          if(cuerpoTemp != "") {
            cuerpoTemp += ",";
          }
          var valor = "";
          if(key == "zona") {
            var zona = zonas.where((c) => c.valueZona == value).firstOrNull;
            valor = zona != null ? zona.labelZona! : value.toString();
          } else {
            valor = value.toString();
          }
          cuerpoTemp += valor;
        }
      });
      if(addTitulo) {
        titulo += "\n";
      }
      cuerpo += "$cuerpoTemp\n";
      addTitulo = false;
    }
    return "$titulo$cuerpo";
  }

  String crearCsv(
    dynamic data,
    List<String> omisiones
  ) {
    var listaElementos = jsonDecode(jsonEncode(data)) as List<dynamic>;
    var titulo = "";
    var addTitulo = true;
    var cuerpo = "";
    for (var elemento in listaElementos) {
      var mapa = jsonDecode(jsonEncode(elemento)) as Map<String, dynamic>;
      var cuerpoTemp = "";
      mapa.forEach((key, value) {
        if(!omisiones.contains(key)) {
          if(addTitulo) {
            if(titulo != "") {
              titulo += ",";
            }
            titulo += key.toUpperCase();
          }
          if(cuerpoTemp != "") {
            cuerpoTemp += ",";
          }
          cuerpoTemp = "$cuerpoTemp${value.toString().trim().replaceAll("\n", "")}";
        }
      });
      if(addTitulo) {
        titulo += "\n";
      }
      cuerpo += "$cuerpoTemp\n";
      addTitulo = false;
    }
    return "$titulo$cuerpo";
  }

  Future<String?> downloadPdf(String fileUri) async {
    try {
      var descarga = await http.get(Uri.parse(fileUri));
      var archivoBytes = descarga.bodyBytes;
      var directorio = await getApplicationDocumentsDirectory();
      var rutaArchivo = "${directorio.path}/downloadpdf.pdf";
      var pdf = File(rutaArchivo);
      await pdf.writeAsBytes(archivoBytes, flush: true);
      return rutaArchivo;
    } catch(e) {
      return null;
    }
  }

  Future<String?> crearArchivo(String contenido, String nombre) async {
    try {
      var directorio = await getApplicationDocumentsDirectory();
      var rutaArchivo = "${directorio.path}/$nombre";
      var txt = File(rutaArchivo);
      await txt.writeAsString(contenido, flush: true);
      return rutaArchivo;
    } catch(e) {
      return null;
    }
  }

  Future<String> abrirCsv() async {
    var selectArchivo = await FilePicker.platform.pickFiles();
    if(selectArchivo == null) {
      return "";
    }
    var archivo = File(selectArchivo.files.single.path!);
    var contenido = archivo.readAsStringSync();
    return contenido;
  }

  Future<void> compartir(String archivo, String texto) async {
    // ignore: deprecated_member_use
    var _ = await Share.shareFiles([(archivo)], text: texto);
  }

  Future<void> whatsapp(String numero) async {
    await launchUrl(
      Uri.parse("https://wa.me/$numero?text="),
    );
  }

  Future<void> marcar(String numero) async {
    await launchUrl(
      Uri.parse("tel://$numero"),
    );
  }

  Future<void> googleMaps(String latitud, String longitud) async {
    var googleMapUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitud,$longitud");
    if(await canLaunchUrl(googleMapUri)) {
      await launchUrl(googleMapUri);
    } else {
      msg("No fue posible abrir los parametros de la ubicación", 2);
    }
  }
}