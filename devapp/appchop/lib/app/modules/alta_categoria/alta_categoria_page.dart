import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/defaults/small_header.dart';
import '../../widgets/textforms/button_textform.dart';
import 'alta_categoria_controller.dart';

class AltaCategoriaPage extends StatelessWidget with WidgetsBindingObserver {
  const AltaCategoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AltaCategoriaController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
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
              texto: "Agregar Categoria",
              ltrbp: [20, 0, 0, 5],
            ),
            CardContainer(
              fondo: 0xFFFDFEFE,
              children: [
                ButtonTextform(
                  controller: _.categoria,
                  focusNode: _.categoriaNode,
                  icon: MaterialIcons.list_alt,
                  icono: MaterialIcons.save,
                  text: 'Nombre categoria',
                  onTap: _.guardarCategoria,
                ),
              ],
            ),
            Expanded(
              child: CardContainer(
                fondo: 0xFFFDFEFE,
                children: <Widget>[
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, isScrolled) {
                        return [const SmallHeader(height: 15,)];
                      },
                      body: CustomScrollView(
                        controller: _.scrollController,
                        slivers: _.listaCategoria.map((categoria) {
                          return SliverToBoxAdapter(
                            child: CardContainer(
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5,),
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: AutoSizeText(
                                        categoria.labelCategoria!,
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
                                          value: categoria.activo!,
                                          onChanged: (status) {
                                            _.cambiarCategoriaEstatus(status, categoria.idCategoria!);
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}