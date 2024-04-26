import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/columns/sin_elementos_column.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/defaults/small_header.dart';
import '../../widgets/textforms/standard_textform.dart';
import 'alta_zona_controller.dart';

class AltaZonaPage extends StatelessWidget with WidgetsBindingObserver {
  const AltaZonaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AltaZonaController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(ColorList.sys[3]),
        appBar: BackAppbar(
          cerrar: _.cerrar,
          fondo: ColorList.sys[3],
          iconoColor: ColorList.sys[0],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TituloContainer(
              texto: "Agregar zona",
              ltrbp: [20, 0, 0, 0],
              size: 20,
            ),
            CardContainer(
              fondo: 0xFFFDFEFE,
              children: [
                StandardTextform(
                  controller: _.zona,
                  focusNode: _.zonaNode,
                  icon: MaterialIcons.list_alt,
                  text: 'Nombre zona',
                ),
              ],
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if(_.listaZona.isNotEmpty) {
                    return CardContainer(
                      fondo: 0xFFFDFEFE,
                      children: <Widget>[
                        Expanded(
                          child: NestedScrollView(
                            headerSliverBuilder: (context, isScrolled) {
                              return [const SmallHeader(height: 15,)];
                            },
                            body: CustomScrollView(
                              controller: _.scrollController,
                              slivers: _.listaZona.map((zona) {
                                return SliverToBoxAdapter(
                                  child: CardContainer(
                                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5,),
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: AutoSizeText(
                                              zona.labelZona!,
                                              style: TextStyle(
                                                color: Color(ColorList.sys[0],),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(0),
                                            child: Transform.scale(
                                              scale: 0.7,
                                              child: Switch(
                                                thumbColor: MaterialStateProperty.all(Color(ColorList.sys[0])),
                                                activeTrackColor: Color(ColorList.sys[1]),
                                                inactiveTrackColor: Color(ColorList.sys[2]),
                                                value: zona.activo!,
                                                onChanged: (status) {
                                                  _.cambiarZonaEstatus(status, zona.idZona!);
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SinElementosColumn(
                      texto: "Su lista de zonas está vacía",
                      imagenAsset: "zonas/background.png",
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _.guardarZona,
          shape: const CircleBorder(),
          backgroundColor: Color(ColorList.sys[2]),
          child: Icon(
            MaterialIcons.save,
            color: Color(ColorList.sys[0]).toMaterialColor(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      ),
    );
  }
}