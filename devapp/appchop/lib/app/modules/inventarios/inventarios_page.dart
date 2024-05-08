import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/options_appbar.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/columns/sin_elementos_column.dart';
import '../../widgets/customscrollviews/inventario_customscrollview.dart';
import '../../widgets/defaults/small_header.dart';
import '../../widgets/inkwells/inventario_totales_inkwell.dart';
import 'inventarios_controller.dart';

class InventariosPage extends StatelessWidget {
  const InventariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventariosController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(ColorList.ui[1]),
        appBar: OptionsAppbar(
          controller: _.busqueda,
          onTap: _.cerrar,
          onTapClear: _.limpiarBusquedaTexto,
          onTapPopup: _.opcionPopupConsulta,
          onChanged: (e) {},
          opcionPopup: _.opcionSelected,
          opciones: _.opcionesConsulta,
          fondo: ColorList.ui[1],
        ),
        body: Column(
          children: [
            Visibility(
              visible: _.elementosImportados,
              child: Container(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Expanded(
                      child: SolidButton(
                        height: 50,
                        icono: MaterialIcons.add_circle,
                        fondoColor: ColorList.sys[1],
                        onPressed: _.agregarImportacion,
                        onLongPress: () {},
                      ),
                    ),
                    Expanded(
                      child: SolidButton(
                        height: 50,
                        icono: MaterialIcons.published_with_changes,
                        textoColor: ColorList.ui[1],
                        fondoColor: ColorList.sys[0],
                        onPressed: _.reemplazarImportacion,
                        onLongPress: () {},
                      ),
                    ),
                    Expanded(
                      child: SolidButton(
                        height: 50,
                        icono: MaterialIcons.cancel,
                        fondoColor: ColorList.sys[2],
                        onPressed: _.cancelarImportar,
                        onLongPress: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Builder(
              builder: (context) {
                if(_.inventariosLista.isNotEmpty) {
                  return Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, isScrolled) {
                        return [const SmallHeader(height: 15,)];
                      },
                      body: InventarioCustomscrollview(
                        scrollController: _.scrollController,
                        listaInventarios: _.inventariosLista,
                        onEditar: _.editarElementoInventario,
                        onBorrar: _.borrarElementoInventario,
                      ),
                    ),
                  );
                } else {
                  return const Expanded(
                    child: SinElementosColumn(
                      texto: "Su lista de inventario está vacía",
                      imagenAsset: "inventarios/background.png",
                    ),
                  );
                }
              },
            ),
            InventarioTotalesInkwell(
              onTap: () {},
              totalInventarios: "Total registros: ${_.totalElementosInventario}",
              opcionInventarioSeleccion: _.opcionInventarioSeleccion,
            ),
          ],
        ),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: NavigationBar(
                height: 60,
                elevation: 0,
                selectedIndex: _.opcionInventarioSeleccion,
                indicatorColor: Color(ColorList.sys[
                  _.opcionInventarioSeleccion == 0
                   ? 1 : 2
                ]),
                backgroundColor: Color(ColorList.ui[1]),
                onDestinationSelected: _.opcionInventarioSeleccionar,
                destinations: <Widget>[
                  NavigationDestination(
                    icon: Icon(
                      MaterialCommunityIcons.archive_check,
                      color: Color(ColorList.sys[0]),
                    ),
                    label: 'Mostrar todo',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      MaterialCommunityIcons.archive_cancel,
                      color: Color(ColorList.sys[0]),
                    ),
                    label: 'Por acabar',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 50,),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _.nuevoArticuloInventario,
          shape: const CircleBorder(),
          backgroundColor: Color(ColorList.sys[2]),
          child: Icon(
            MaterialIcons.add_shopping_cart,
            color: Color(ColorList.sys[0]).toMaterialColor(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      ),
    );
  }
}