import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/configuracion/imagen_logo.dart';
import '../../data/models/local_storage/local_storage.dart';
import '../../data/models/local_storage/zonas.dart';
import '../../routes/app_routes.dart';
import '../../utils/color_list.dart';
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

  final ImagePicker selectorImagen = ImagePicker();
  XFile? imagenArchivo;

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

  void abrirMenu() async {
    drawerController.toggle!.call();
    await _limpiarCacheImagen();
  }

  void _abrirOpcion(MenuOpcion opcion) {
    drawerController.close!.call();
    var pagina = "";
    dynamic arguments = {};
    switch(opcion) {
      case MenuOpcion.nuevaCobranza:
          if(!esAdmin) {
          var zonaStorage = List<Zonas>.from(
            storage.get([Zonas()]).map((json) => Zonas.fromJson(json))
          );
          if(zonaStorage.isEmpty) {
            tool.msg("No tiene zonas registradas. Obtenga un respaldo desde el menú Configuración, o consulte con su administrador");
            return;
          }
        }
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

  Future<void> actualizarImagen() async {
    try {
      if(!esAdmin) {
        return;
      }
      imagenArchivo = await selectorImagen.pickImage(source: ImageSource.gallery);
      if(imagenArchivo == null) {
        Get.back();
        return;
      }
      var context = Get.context;
      var cropImagen = await ImageCropper().cropImage(
        sourcePath: imagenArchivo!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Configurar imagen',
              toolbarColor: Color(ColorList.sys[0]),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              hideBottomControls: true,
              lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Configurar imagen',
          ),
          WebUiSettings(
            // ignore: use_build_context_synchronously
            context: context!,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort: const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          ),
        ],
      );
      if(cropImagen == null) {
        return;
      }
      var imagenBytes = await cropImagen.readAsBytes();
      var imagenBase64 = base64Encode(imagenBytes);
      var validaGuardar = await tool.ask("Guardar imagen", "¿Desea continuar?");
      if(!validaGuardar) {
        return;
      }
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var imagenLogo = ImagenLogo(
        idUsuario: localStorage.idUsuario,
        imagenBase64: imagenBase64,
      );
      tool.isBusy();
      var guardarImagen = await configuracionRepository.guardarImagenLogoAsync(imagenLogo);
      if(guardarImagen == null || !guardarImagen) {
        throw Exception();
      }
      await tool.wait(1);
      tool.msg("Imagen almacenada correctamente", 1);
      await _limpiarCacheImagen();
    } catch(e) {
      tool.msg("Ocurrió un error al intentar actualizar imagen", 3);
    } finally {
      update();
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

  Future<void> _limpiarCacheImagen() async {
    try {
      var localStorage = LocalStorage.fromJson(storage.get(LocalStorage()));
      var _ = await CachedNetworkImage.evictFromCache("${Literals.uri}media/usuarios/${localStorage.idUsuario}.jpg");
    } finally {
      update();
    }
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