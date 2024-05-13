import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../data/models/local_storage/local_storage.dart';
import '../../routes/app_routes.dart';
import '../../utils/get_injection.dart';
import '../../utils/literals.dart';
import '../../widgets/inkwells/menu_opcion_inkwell.dart';
import '../cobranza_main/cobranza_main_controller.dart';
import '../login/login_binding.dart';
import '../login/login_page.dart';

class HomeController extends GetInjection {
  ZoomDrawerController drawerController = ZoomDrawerController();
  List<Widget> listaMenu = [];

  String nombre = "";
  String idUsuario = "";
  bool backup = false;
  bool acepta = false;

  bool esAdmin = GetInjection.administrador;
  
  @override
  void onInit() {
    _init();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    await _ready();
    super.onReady();
  }

  void _init() {
    Get.put<CobranzaMainController>(CobranzaMainController());
    var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
    backup = localStorage.backupInicial!;
    acepta = localStorage.acepta! > 0;
    nombre = "${localStorage.nombres} ${localStorage.apellidos}";
    idUsuario = localStorage.idUsuario!;
    listaMenu = [
      MenuOpcionInkwell(
        texto: "Nueva Cobranza",
        icono: MaterialIcons.description,
        visible: true,
        onTap: () => _abrirOpcion(MenuOpcion.nuevaCobranza),
      ),
      MenuOpcionInkwell(
        texto: "Agregar zona",
        icono: MaterialIcons.list_alt,
        visible: esAdmin,
        onTap: () => _abrirOpcion(MenuOpcion.agregarZona),
      ),
      MenuOpcionInkwell(
        texto: "Usuarios",
        icono: MaterialIcons.person_add,
        visible: esAdmin,
        onTap: () => _abrirOpcion(MenuOpcion.usuarios),
      ),
      MenuOpcionInkwell(
        texto: "Clientes",
        icono: MaterialIcons.contact_phone,
        visible: esAdmin,
        onTap: () => _abrirOpcion(MenuOpcion.clientes),
      ),
      MenuOpcionInkwell(
        texto: "Inventarios",
        icono: MaterialIcons.inventory,
        visible: esAdmin,
        onTap: () => _abrirOpcion(MenuOpcion.inventarios),
      ),
      MenuOpcionInkwell(
        texto: "Configuración",
        icono: MaterialIcons.settings,
        visible: true,
        onTap: () => _abrirOpcion(MenuOpcion.configuracion),
      ),
    ];
    update();
  }

  Future<void> _ready() async {
    try {
      if(backup || !acepta) {
        return;
      }
      await ejecutarAppBackup();
    } finally { }
  }

  Future<void> ejecutarAppBackup() async {
    await tool.wait(1);
    Get.toNamed(
      AppRoutes.appBackupResultado,
      arguments: {
        "tipo": 1
      },
    );
  }

  void abrirMenu() {
    drawerController.toggle!.call();
  }

  void _abrirOpcion(MenuOpcion opcion) {
    drawerController.close!.call();
    var pagina = "";
    dynamic arguments = {};
    switch(opcion) {
      case MenuOpcion.nuevaCobranza:
        pagina = AppRoutes.altaCobranza;
        arguments = {
          "tipoCobranza": Literals.tipoCobranzaMeDeben
        };
      break;
      case MenuOpcion.agregarZona:
        pagina = AppRoutes.altaZona;
      break;
      case MenuOpcion.usuarios:
        pagina = AppRoutes.usuarios;
      break;
      case MenuOpcion.clientes:
        pagina = AppRoutes.altaClientes;
      break;
      case MenuOpcion.inventarios:
        pagina = AppRoutes.inventarios;
      break;
      case MenuOpcion.configuracion:
        pagina = AppRoutes.configuracion;
      break;
      default:
        return;
    }
    if(pagina == "") {
      return;
    }
    Get.toNamed(
      pagina,
      arguments: arguments,
    );
  }

  void actualizarImagen() {
    if(!esAdmin) {
      return;
    }
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

enum MenuOpcion {
  nuevaCobranza,
  agregarZona,
  usuarios,
  clientes,
  inventarios,
  configuracion,
}