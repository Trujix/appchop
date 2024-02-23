import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../utils/get_injection.dart';

class HomeController extends GetInjection {
  ZoomDrawerController drawerController = ZoomDrawerController();
  
  @override
  void onInit() async {
    firebaseService.init();
    super.onInit();
  }

  void abrirMenu() {
    drawerController.toggle!.call();
  }

  String texto = "Hola";

}