import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/main_appbar.dart';
import '../../widgets/combo/selection_combo.dart';
import '../../widgets/customscrollviews/cobranza_customscrollview.dart';
import '../../widgets/defaults/small_header.dart';
import '../../widgets/inkwells/saldo_cobranza_inwell.dart';
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
        appBar: MainAppbar(
          controller: _.busqueda,
          opciones: _.opcionesConsulta,
          onTap: Get.find<HomeController>().abrirMenu,
          onTapPopup: _.opcionPopupConsulta,
          opcionPopup: _.opcionSelected,
          onChanged: _.busquedaCobranzas,
        ),
        body: Column(
          children: [
            SelectionCombo(
              titulo: "- Elige categoría -",
              controller: _.categoria,
              values: _.listaCategoria,
              icono: MaterialIcons.list_alt,
              height: 35,
              ltrb: const [10, 0, 10, 0,],
              textAlignVertical: TextAlignVertical.bottom,
            ),
            Builder(
              builder: (context) {
                if(_.mostrarResultados) {
                  return Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, isScrolled) {
                        return [const SmallHeader(height: 15,)];
                      },
                      body: CobranzaCustomscrollview(
                        scrollController: _.scrollController,
                        listaCobranzas: _.listaCobranzas,
                        onTap: _.mensajeCobranzaElemento,
                        onLongPress: _.editarCobranzaElemento,
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Image.asset('assets/home/background.png'),
                  );
                }
              },
            ),
            SaldoCobranzaInkwell(
              saldoTotal: _.saldoTotal,
              opcionDeudaSeleccion: _.opcionDeudaSeleccion,
            ),
          ],
        ),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: NavigationBar(
                height: 60,
                elevation: 0,
                selectedIndex: _.opcionDeudaSeleccion,
                indicatorColor: Color(ColorList.sys[
                  _.opcionDeudaSeleccion == 0
                   ? 1 : 2
                ]),
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