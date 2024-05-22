import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/local_storage/clientes.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../utils/get_injection.dart';

class AltaClientesController extends GetInjection {
  ScrollController scrollController = ScrollController();
  TextEditingController nombre = TextEditingController();
  FocusNode nombreFocus = FocusNode();
  TextEditingController telefono = TextEditingController();
  FocusNode telefonoFocus = FocusNode();

  List<Clientes> listaClientes = [];
  int totalClientes = 0;

  @override
  void onInit() {
    _init();
    super.onInit();
  }
  
  void _init() {
    listaClientes = List<Clientes>.from(
      storage.get([Clientes()]).map((json) => Clientes.fromJson(json))
    );
    totalClientes = listaClientes.length;
  }

  Future<void> agregarClienteDirectorio() async {
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

  Future<void> guardarCliente() async {
    try {
      if(!_validarForm()) {
        return;
      }
      tool.isBusy();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var idUsuario = tool.guid();
      listaClientes.add(Clientes(
        idUsuario: localStorage.idUsuario,
        idCliente: idUsuario,
        nombre: nombre.text,
        telefono: telefono.text,
        fechaCreacion: DateFormat("dd-MM-yyyy").format(DateTime.now()).toString(),
      ));
      await storage.update(listaClientes);
      await Future.delayed(1.seconds);
      tool.isBusy(false);
      nombre.text = "";
      telefono.text = "";
      tool.msg("Cliente creado correctamente", 1);
    } catch(e) {
      tool.msg("Ocurrió un error al guardar cliente", 3);
    } finally {
      totalClientes = listaClientes.length;
      update();
    }
  }

  Future<void> cambiarClienteEstatus(bool estatus, String idCliente) async {
    try {
      var clientes = List<Clientes>.from(
        storage.get([Clientes()]).map((json) => Clientes.fromJson(json))
      );
      for(var cliente in clientes) {
        if(cliente.idCliente == idCliente) {
          cliente.activo = estatus;
        }
      }
      await storage.update(clientes);
      listaClientes = clientes;
    } finally {
      update();
    }
  }

  void cerrar() {
    Get.back();
  }

  bool _validarForm() {
    var correcto = false;
    var mensaje = "";
    var verificar = listaClientes.where((c) => c.telefono == telefono.text.trim()).firstOrNull;
    if(tool.isNullOrEmpty(nombre)) {
      mensaje = "Escriba el nombre";
    } else if(tool.isNullOrEmpty(telefono)) {
      mensaje = "Escriba el teléfono";
    } else if(telefono.text.length != 10) {
      mensaje = "Formato de teléfono NO válido";
    } else if(verificar != null) {
      mensaje = "Ya existe este cliente (${telefono.text.trim()})";
    } else {
      correcto = true;
      nombreFocus.unfocus();
      telefonoFocus.unfocus();
    }
    if(!correcto) {
      tool.toast(mensaje);
    }
    return correcto;
  }
}