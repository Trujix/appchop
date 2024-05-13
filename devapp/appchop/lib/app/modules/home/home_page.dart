import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/containers/menu_footer_container.dart';
import '../../widgets/containers/menu_header_container.dart';
import '../../widgets/containers/menu_version_container.dart';
import '../../widgets/drawers/menu_drawer.dart';
import '../cobranza_main/cobranza_main_page.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget with WidgetsBindingObserver {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) => MenuDrawer(
        controller: _.drawerController,
        mainScreen: const CobranzaMainPage(),
        menuScreen: <Widget>[
          const SizedBox(height: 75,),
          MenuHeaderContainer(
            nombre: _.nombre,
            idUsduario: _.idUsuario,
            actualizarImagen: _.actualizarImagen,
          ),
          Expanded(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _.listaMenu.map((elem) {
                  return elem;
                }).toList(),
              ),
            ),
          ),
          MenuFooterContainer(
            widgets: <Widget>[
              SolidButton(
                texto: 'Cerrar sesión',
                icono: MaterialIcons.logout,
                fondoColor: ColorList.sys[2],
                textoColor: ColorList.sys[0],
                onPressed: _.cerrarSesion,
                onLongPress: () {},
              ),
              const MenuVersionContainer(),
            ],
          ),
        ],
      ),
    );
  }
}