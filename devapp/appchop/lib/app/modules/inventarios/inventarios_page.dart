import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/options_appbar.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/columns/sin_elementos_column.dart';
import '../../widgets/containers/basic_bottom_sheet_container.dart';
import '../../widgets/containers/card_scrollable_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/customscrollviews/inventario_customscrollview.dart';
import '../../widgets/defaults/small_header.dart';
import '../../widgets/inkwells/inventario_totales_inkwell.dart';
import '../../widgets/textforms/standard_textform.dart';
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
          onPressed: () {
            showMaterialModalBottomSheet(
              context: context,
              expand: true,
              enableDrag: false,
              backgroundColor: Colors.transparent,
              builder: (context) => StatefulBuilder(builder: (context, setState) {
                return BasicBottomSheetContainer(
                  context: context,
                  cerrar: true,
                  child: Column(
                    children: [
                      const TituloContainer(
                        texto: "(*) Los campos son obligatorios",
                        ltrbp: [10, 0, 0, 0],
                        size: 16,
                      ),
                      Expanded(
                        child: CardScrollableContainer(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0,),
                          children: [
                            StandardTextform(
                              controller: _.codigoArticulo,
                              focusNode: _.codigoArticuloFocus,
                              text: "Código artículo *",
                              icon: MaterialIcons.qr_code,
                              keyboardType: TextInputType.text,
                              ltrbp: const [0, 10, 0, 10],
                              maxLength: 15,
                            ),
                            StandardTextform(
                              controller: _.descripcion,
                              focusNode: _.descripcionFocus,
                              text: "Descripción *",
                              icon: MaterialIcons.inventory,
                              keyboardType: TextInputType.text,
                              ltrbp: const [0, 10, 0, 10],
                              maxLength: 40,
                            ),
                            StandardTextform(
                              controller: _.precioCompra,
                              focusNode: _.precioCompraFocus,
                              text: "Precio compra *",
                              icon: MaterialIcons.money,
                              keyboardType: TextInputType.number,
                              ltrbp: const [0, 10, 0, 10],
                            ),
                            StandardTextform(
                              controller: _.precioVenta,
                              focusNode: _.precioVentaFocus,
                              text: "Precio venta *",
                              icon: MaterialIcons.attach_money,
                              keyboardType: TextInputType.number,
                              ltrbp: const [0, 10, 0, 10],
                            ),
                            StandardTextform(
                              controller: _.existencia,
                              focusNode: _.existenciaFocus,
                              text: "Existencias *",
                              icon: MaterialIcons.format_list_numbered,
                              keyboardType: TextInputType.number,
                              ltrbp: const [0, 10, 0, 10],
                            ),
                            StandardTextform(
                              controller: _.maximo,
                              focusNode: _.maximoFocus,
                              text: "Máximo *",
                              icon: MaterialIcons.add_circle,
                              keyboardType: TextInputType.number,
                              ltrbp: const [0, 10, 0, 10],
                            ),
                            StandardTextform(
                              controller: _.minimo,
                              focusNode: _.minimoFocus,
                              text: "Mínimo *",
                              icon: MaterialIcons.remove_circle,
                              keyboardType: TextInputType.number,
                              ltrbp: const [0, 10, 0, 10],
                            ),
                          ],
                        ),
                      ),
                      SolidButton(
                        texto: "${(_.elementosImportados ? "Agregar" : "Guardar")} artículo",
                        icono: MaterialIcons.save,
                        fondoColor: ColorList.sys[2],
                        textoColor: ColorList.sys[0],
                        ltrbm: const [0, 0, 0, 0,],
                        onPressed: () {
                          if(!_.validarForm()) {
                            return;
                          }
                          if(_.elementosImportados) {
                            _.agregarElementoInventario();
                          } else {
                            _.guardarElementoInventario();
                          }
                        },
                        onLongPress: () {},
                      ),
                    ],
                  ),
                );
              }),
            );
          },
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