import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/search_appbar.dart';
import '../../widgets/centers/sin_busqueda_center.dart';
import '../../widgets/customscrollviews/busqueda_customscrollview.dart';
import '../../widgets/defaults/small_header.dart';
import 'busqueda_controller.dart';

class BusquedaPage extends StatelessWidget {
  const BusquedaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BusquedaController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.ui[1]),
        appBar: SearchAppbar(
          controller: _.busquedaController,
          onTap: _.cerrar,
          fondo: ColorList.ui[1],
          onTapClear: _.limpiarBusqueda,
          onChanged: _.buscar,
        ),
        body: Builder(
          builder: (context) {
            if(_.elementosBusqueda.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, isScrolled) {
                        return [const SmallHeader(height: 15,)];
                      },
                      body: BusquedaCustomscrollview(
                        scrollController: _.scrollController,
                        elementos: _.elementosBusqueda,
                        onLongPress: _.seleccionarElemento,
                        onTap: _.mensajeTap,
                      ),
                    ),
                  ),
                ],
              );
            } else{
              return SinBusquedaCenter(
                texto: _.sinResultados,
              );
            }
          },
        ),
      ),
    );
  }
}