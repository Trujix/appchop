import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/local_storage/clientes.dart';
import '../../utils/get_injection.dart';

class AppBackupClientesController extends GetInjection {
  ScrollController scrollController = ScrollController();
  List<Clientes> clientesNuevos = [];
  bool clientesNuevosActivos = true;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() {
    var arguments = Get.arguments;
    if(arguments == null) {
      Get.back();
      tool.msg("Ocurrió un error al cargar formulario", 3);
      return;
    }
    clientesNuevos = arguments['clientesNuevos'] as List<Clientes>;
  }

  Future<void> guardarNuevosClientes() async {
    try {
      var verificar = await tool.ask("Guardar clientes seleccionados", "¿Desea continuar?");
      if(!verificar) {
        return;
      }
      tool.isBusy();
      var listaClientes = List<Clientes>.from(
        storage.get([Clientes()]).map((json) => Clientes.fromJson(json))
      );
      for(var nuevo in clientesNuevos) {
        if(!nuevo.activo!) {
          continue;
        }
        listaClientes.add(nuevo);
      }
      await storage.update(listaClientes);
      await tool.wait(1);
      tool.isBusy(false);
      Get.back();
      tool.msg("Clientes almacenados correctamente", 1);
    } catch(_) {
      tool.msg("Ocurrió un error al intentar guardar clientes", 3);
    } finally {
      update();
    }
  }

  void clienteStatus(bool estatus, String idCliente) {
    for(var cliente in clientesNuevos) {
      if(cliente.idCliente == idCliente) {
        cliente.activo = estatus;
      }
    }
    var activos = clientesNuevos.where((c) => c.activo!).toList();
    clientesNuevosActivos = activos.isNotEmpty;
    update();
  }

  Future<void> cancelar() async {
    try {
      var verificar = await tool.ask("Salir sin guardar", "¿Desea continuar?");
      if(!verificar) {
        return;
      }
      Get.back();
    } catch(_) {
      Get.back();
    }
  }
}