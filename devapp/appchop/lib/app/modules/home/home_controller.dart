import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../data/models/local_storage/categorias.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../routes/app_routes.dart';
import '../../utils/get_injection.dart';
import '../../widgets/inkwells/menu_opcion_inkwell.dart';
import '../cobranza_main/cobranza_main_controller.dart';
import '../login/login_binding.dart';
import '../login/login_page.dart';

class HomeController extends GetInjection {
  ZoomDrawerController drawerController = ZoomDrawerController();
  List<Widget> listaMenu = [];

  String nombre = "";
  String idUsuario = "";
  
  @override
  Future<void> onInit() async {
    await _init();
    super.onInit();
  }

  Future<void> _init() async {
    Get.put<CobranzaMainController>(CobranzaMainController());
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    nombre = "${localStorage.nombres} ${localStorage.apellidos}";
    idUsuario = localStorage.idUsuario!;
    listaMenu = [
      MenuOpcionInkwell(
        texto: "Nueva Cobranza",
        icono: MaterialIcons.description,
        onTap: () => _abrirOpcion(1),
      ),
      MenuOpcionInkwell(
        texto: "Agregar categoría",
        icono: MaterialIcons.list_alt,
        onTap: () => _abrirOpcion(2),
      ),
      MenuOpcionInkwell(
        texto: "Configuración",
        icono: MaterialIcons.settings,
        onTap: () => _abrirOpcion(3),
      ),
    ];
    var categoriaStorage = List<Categorias>.from(
      storage.get([Categorias()]).map((json) => Categorias.fromJson(json))
    );
    if(categoriaStorage.isEmpty) {
      categoriaStorage.add(Categorias(
        idUsuario: localStorage.idUsuario,
        idCategoria: tool.guid(),
        valueCategoria: "SIN_CATEGORIA",
        labelCategoria: "Sin categoria",
      ));
      await storage.update(categoriaStorage);
    }
    update();
    return;
  }

  void abrirMenu() {
    drawerController.toggle!.call();
  }

  void _abrirOpcion(int menu) {
    drawerController.close!.call();
    var pagina = "";
    switch(menu) {
      case 1:
        pagina = AppRoutes.altaCobranza;
      break;
      case 2:
        pagina = "";
      break;
      case 3:
        pagina = "";
      break;
      default:
        return;
    }
    if(pagina == "") {
      return;
    }
    Get.toNamed(pagina);
  }

  Future<void> cerrarSesion() async {
    try {
      tool.isBusy();
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      localStorage.login = false;
      storage.update(localStorage);
      await Future.delayed(1.5.seconds);
      tool.isBusy(false);
      drawerController.close!.call();
      Get.offAll(
        const LoginPage(),
        binding: LoginBinding(),
        transition: Transition.cupertino,
        duration: 1.seconds,
      );
    } finally { }
  }
}