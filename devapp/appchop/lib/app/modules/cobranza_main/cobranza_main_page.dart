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
            child: Icon(
              Icons.menu,
              color: Color(ColorList.sys[0]),
            ),
          ),
        ),
        body: Builder(
          builder: (context) {
            if(_.mostrarResultados) {
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: _.lll,
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: Image.asset('assets/home/background.png'),
                  ),
                ],
              );
            }
          },
        ),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: NavigationBar(
                height: 60,
                elevation: 0,
                selectedIndex: _.opcionDeudaSeleccion,
                indicatorColor: Color(ColorList.sys[1]),
                backgroundColor: Color(ColorList.sys[3]),
                onDestinationSelected: _.opcionDeudaSeleccionar,
                destinations: <Widget>[
                  NavigationDestination(
                    icon: Icon(
                      MaterialIcons.attach_money,
                      color: Color(ColorList.sys[0]),
                    ),
                    label: 'Me deben',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      MaterialIcons.money_off,
                      color: Color(ColorList.sys[0]),
                    ),
                    label: 'Debo',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      MaterialIcons.hourglass_empty,
                      color: Color(ColorList.sys[0]),
                    ),
                    label: 'Vencidas',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 50,),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      ),
    );
  }
}