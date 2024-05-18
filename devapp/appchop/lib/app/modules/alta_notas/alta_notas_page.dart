import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../utils/literals.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/buttons/circular_buttons.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/containers/card_container.dart';
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
          children: <Widget>[
            const TituloContainer(
              texto: "Información de la nota",
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
              ],
            ),
            CardContainer(
              padding: const EdgeInsets.all(10,),
              fondo: ColorList.ui[3],
              children: <Widget>[
                MultilineTextform(
                  controller: _.nota,
                  focusNode: _.notaFocus,
                  text: "Nota",
                  icon: MaterialIcons.note_add,
                  lines: 5,
                  maxLength: 500,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 10,),
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
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 5,),
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
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 5,),
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
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5,),
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
            Visibility(
              visible: (!_.esAdmin && _.cobranza!.bloqueado == Literals.bloqueoSi || _.cobranza!.bloqueado == Literals.bloqueoNo) 
                && _.cobranza!.estatus == Literals.statusCobranzaPendiente,
              child: SolidButton(
                texto: "Guardar nota",
                icono: MaterialIcons.save,
                fondoColor: ColorList.sys[2],
                textoColor: ColorList.sys[0],
                ltrbm: const [0, 0, 0, 15,],
                onPressed: _.guardarNota,
                onLongPress: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}