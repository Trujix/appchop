import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../utils/get_injection.dart';

class HomeController extends GetInjection {
  ZoomDrawerController drawerController = ZoomDrawerController();
  
  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  void _init() {

  }

  void abrirMenu() {
    drawerController.toggle!.call();
  }

  String texto = "Hola";
}