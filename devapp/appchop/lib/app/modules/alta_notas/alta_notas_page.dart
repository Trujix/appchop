import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/buttons/circular_buttons.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/containers/basic_bottom_sheet_container.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/card_scrollable_container.dart';
import '../../widgets/containers/sin_notas_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/textforms/multiline_textform.dart';
import '../../widgets/texts/etiqueta_text.dart';
import 'alta_notas_controller.dart';

class AltaNotasPage extends StatelessWidget with WidgetsBindingObserver {
  const AltaNotasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AltaNotasController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.ui[1]),
        appBar: BackAppbar(
          cerrar: _.cerrar,
          fondo: ColorList.ui[1],
        ),
        body: ListView(
          controller: _.scrollController,
          children: <Widget>[
            const TituloContainer(
              texto: "Información general",
              ltrbp: [20, 0, 0, 0],
              size: 20,
            ),
            CardContainer(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10,),
              fondo: ColorList.ui[3],
              children: [
                EtiquetaText(
                  texto1: "Nombre persona/contacto:\n",
                  texto2: _.cobranza!.nombre!,
                  icono: MaterialIcons.account_circle,
                ),
                EtiquetaText(
                  texto1: "Descripción:\n",
                  texto2: _.cobranza!.descripcion!,
                  icono: MaterialIcons.verified_user,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0,),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: EtiquetaText(
                          texto1: "Teléfono:\n",
                          texto2: _.cobranza!.telefono!,
                          icono: FontAwesome.hashtag,
                        ),
                      ),
                      Visibility(
                        visible: _.opcionesTelefonia,
                        child: CircularButton(
                          icono: FontAwesome.phone,
                          color: ColorList.sys[1],
                          colorIcono: ColorList.sys[0],
                          margin: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                          onPressed: _.marcarTelefono,
                        ),
                      ),
                      Visibility(
                        visible: _.opcionesTelefonia,
                        child: CircularButton(
                          icono: FontAwesome.whatsapp,
                          color: ColorList.sys[1],
                          colorIcono: ColorList.sys[0],
                          margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                          onPressed: _.abrirWhatsapp,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0,),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: EtiquetaText(
                          texto1: "Dirección:\n",
                          texto2: _.cobranza!.direccion!,
                          icono: MaterialIcons.house,
                        ),
                      ),
                      Visibility(
                        visible: _.abrirUbicacion,
                        child: CircularButton(
                          icono: MaterialIcons.location_pin,
                          color: ColorList.sys[1],
                          colorIcono: ColorList.sys[0],
                          onPressed: _.abrirGoogleMaps,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0,),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: EtiquetaText(
                          texto1: "Correo:\n",
                          texto2: _.cobranza!.correo!,
                          icono: MaterialIcons.email,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 10,),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: EtiquetaText(
                          texto1: "Fecha:\n",
                          texto2: _.cobranza!.fechaRegistro!,
                          icono: MaterialIcons.calendar_today,
                        ),
                      ),
                      Expanded(
                        child: EtiquetaText(
                          texto1: "Vence:\n",
                          texto2: _.fechaVencimiento,
                          icono: MaterialIcons.event_busy,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const TituloContainer(
              texto: "Listado de notas",
              ltrbp: [20, 0, 0, 0],
              size: 20,
            ),
            Builder(
              builder: (context) {
                if(_.listaNotas.isNotEmpty) {
                  return Column(
                    children: _.listaNotas.map((nota) {
                      return InkWell(
                        onTap: () {},
                        child: CardContainer(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          fondo: ColorList.ui[3],
                          children: [
                            Row(
                              children: [
                                Visibility(
                                  visible: nota.usuarioCrea != _.usuario && nota.usuarioVisto == "",
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      MaterialIcons.new_releases,
                                      color: Color(ColorList.theme[2]),
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    nota.nota!,
                                    maxLines: 4,
                                    minFontSize: 10,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(ColorList.sys[0]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return const SinNotasContainer();
                }
              },
            ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TituloContainer(
                        texto: "Crear nueva nota (max. 150 caracteres)",
                        ltrbp: [10, 0, 0, 0],
                        size: 16,
                      ),
                      Expanded(
                        child: CardScrollableContainer(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0,),
                          children: [
                            MultilineTextform(
                              controller: _.nota,
                              focusNode: _.notaFocus,
                              text: "Nota",
                              icon: MaterialIcons.note_add,
                              lines: 5,
                              maxLength: 150,
                            ),
                          ],
                        ),
                      ),
                      SolidButton(
                        texto: "Guardar nota",
                        icono: MaterialIcons.save,
                        fondoColor: ColorList.sys[2],
                        textoColor: ColorList.sys[0],
                        ltrbm: const [0, 0, 0, 0,],
                        onPressed: _.guardarNota,
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
            MaterialIcons.note_add,
            color: Color(ColorList.sys[0]).toMaterialColor(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      ),
    );
  }
}