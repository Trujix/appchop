import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';

import '../../utils/color_list.dart';
import '../home/home_controller.dart';
import 'cobranza_main_controller.dart';

class CobranzaMainPage extends StatelessWidget with WidgetsBindingObserver {
  const CobranzaMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CobranzaMainController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.sys[3]),
        appBar: AppBar(
          backgroundColor: Color(ColorList.sys[3]),
          title: GestureDetector(
            onTap: Get.find<HomeController>().abrirMenu,
            child: const Icon(Icons.menu,),
          ),
        ),
        body: Column(
          children: [

          ],
        ),
        bottomNavigationBar: NavigationBar(
          height: 60,
          elevation: 0,
          selectedIndex: _.opcionDeudaSeleccion,
          indicatorColor: Color(ColorList.sys[1]),
          backgroundColor: Color(ColorList.sys[3]),
          onDestinationSelected: _.opcionDeudaSeleccionar,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(MaterialIcons.attach_money),
              label: 'Me deben',
            ),
            NavigationDestination(
              icon: Icon(MaterialIcons.money_off),
              label: 'Debo',
            ),
            NavigationDestination(
              icon: Icon(MaterialIcons.hourglass_empty),
              label: 'Vencidas',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _.altaCobranza,
          shape: const CircleBorder(),
          backgroundColor: Color(ColorList.sys[2]),
          child: Icon(
            MaterialIcons.post_add,
            color: Color(ColorList.sys[0]).toMaterialColor(),
          ),
        ),
      ),
    );
  }
}