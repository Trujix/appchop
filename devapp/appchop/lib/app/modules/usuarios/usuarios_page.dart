import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/columns/sin_elementos_column.dart';
import '../../widgets/combo/selection_combo.dart';
import '../../widgets/containers/basic_bottom_sheet_container.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/customscrollviews/usuarios_customscrollviews.dart';
import '../../widgets/inkwells/icono_boton_inkwell.dart';
import '../../widgets/textforms/standard_textform.dart';
import 'usuarios_controller.dart';

class UsuariosPage extends StatelessWidget {
  const UsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsuariosController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.sys[3]),
        appBar: BackAppbar(
          cerrar: _.cerrar,
          fondo: ColorList.sys[3],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TituloContainer(
              texto: "Gestión de usuarios",
              ltrbp: [20, 0, 0, 10],
              size: 18,
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if(_.listaUsuarios.isNotEmpty) {
                    return UsuariosCustomscrollview(
                      zonasController: _.zona,
                      scrollController: _.scrollController,
                      usuarios: _.listaUsuarios,
                      zonas: _.zonasLista,
                      zonasUsuarios: _.listaZonasUsuarios,
                      zonasLista: _.listaZonas,
                      onTap: () {},
                      onLongPress: (d) {},
                      actualizarPassword: _.actualizarPassword,
                      modificarZona: _.modificarZona,
                      verificarZonas: _.clearForm,
                      cambiarEstatus: _.cambiarEstatus,
                    );
                  } else {
                    return const SinElementosColumn(
                      texto: "Su lista de usuarios está vacía",
                      imagenAsset: "clientes/search.png",
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(!_.clearForm()) {
              return;
            }
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TituloContainer(
                        texto: "(*) Los campos son obligatorios",
                        ltrbp: [10, 0, 0, 0],
                        size: 16,
                      ),
                      Expanded(
                        child: CardContainer(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0,),
                          children: [
                            StandardTextform(
                              controller: _.usuario,
                              focusNode: _.usuarioFocus,
                              text: "Usuario *",
                              icon: MaterialIcons.person,
                              keyboardType: TextInputType.text,
                              upper: true,
                              ltrbp: const [0, 10, 0, 10],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: StandardTextform(
                                    controller: _.password,
                                    focusNode: _.passwordFocus,
                                    text: "Contraseña *",
                                    icon: MaterialIcons.person,
                                    keyboardType: TextInputType.text,
                                    ltrbp: const [0, 10, 0, 10],
                                  ),
                                ),
                                IconoBotonInkwell(
                                  onTap: _.crearPasswordRandom,
                                  icon: MaterialIcons.settings,
                                  ltrbp: const [10, 10, 0, 10],
                                ),
                              ],
                            ),
                            StandardTextform(
                              controller: _.nombres,
                              focusNode: _.nombresFocus,
                              text: "Nombre *",
                              icon: MaterialIcons.person,
                              keyboardType: TextInputType.text,
                              ltrbp: const [0, 10, 0, 10],
                            ),
                            StandardTextform(
                              controller: _.apellidos,
                              focusNode: _.apellidosFocus,
                              text: "Apellido *",
                              icon: MaterialIcons.person,
                              keyboardType: TextInputType.text,
                              ltrbp: const [0, 10, 0, 10],
                            ),
                            const TituloContainer(
                              texto: "Zona *",
                              ltrbp: [10, 0, 0, 0],
                              size: 15,
                            ),
                            SelectionCombo(
                              titulo: "- Elige zona -",
                              controller: _.zona,
                              values: _.listaZonas,
                              icono: MaterialIcons.list_alt,
                              ltrb: const [0, 0, 0, 10,],
                              height: 70,
                              textAlignVertical: TextAlignVertical.bottom,
                            ),
                          ],
                        ),
                      ),
                      SolidButton(
                        texto: "Guardar usuario",
                        icono: MaterialIcons.save,
                        fondoColor: ColorList.sys[2],
                        textoColor: ColorList.sys[0],
                        ltrbm: const [0, 0, 0, 0,],
                        onPressed: _.guardarNuevoUsuario,
                        onLongPress: () {},
                      ),
                    ],
                  ),
                );
              },),
            );
          },
          shape: const CircleBorder(),
          backgroundColor: Color(ColorList.sys[2]),
          child: Icon(
            MaterialIcons.person_add,
            color: Color(ColorList.sys[0]).toMaterialColor(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      ),
    );
  }
}
