import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';
import '../buttons/solid_button.dart';
import '../containers/card_scrollable_container.dart';
import '../containers/titulo_container.dart';
import '../textforms/password_textform.dart';

class PasswordColumn extends StatelessWidget {
  final TextEditingController? antiguaPassword;
  final FocusNode? antiguaPasswordFocus;
  final TextEditingController? nuevaPassword;
  final FocusNode? nuevaPasswordFocus;
  final TextEditingController? repetirPassword;
  final FocusNode? repetirPasswordFocus;
  final bool esNueva;
  final void Function() guardarPassword;
  const PasswordColumn({
    super.key,
    this.antiguaPassword,
    this.antiguaPasswordFocus,
    this.nuevaPassword,
    this.nuevaPasswordFocus,
    this.repetirPassword,
    this.repetirPasswordFocus,
    this.esNueva = false,
    required this.guardarPassword,
  });

  @override
  Widget build(BuildContext context) {
    bool ocultarAntiguaPassword = true;
    bool ocultarNuevaPassword = true;
    bool ocultarRepetirPassword = true;
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TituloContainer(
            texto: "${(esNueva ? "Modificar contraseña" : "Crear nueva contraseña")}\n(*) Los campos son obligatorios",
            ltrbp: const [10, 0, 0, 0],
            size: 16,
          ),
          Expanded(
            child: CardScrollableContainer(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0,),
              children: [
                Visibility(
                  visible: esNueva,
                  child: PasswordTextform(
                    controller: antiguaPassword,
                    focusNode: antiguaPasswordFocus,
                    obscureText: ocultarAntiguaPassword,
                    obscureTextFunc: () {
                      setState(() {
                        ocultarAntiguaPassword = !ocultarAntiguaPassword;
                      });
                    },
                    text: "Antigua contraseña *",
                    icon: MaterialIcons.lock,
                    ltrbp: const [0, 10, 0, 10],
                  ),
                ),
                PasswordTextform(
                  controller: nuevaPassword,
                  focusNode: nuevaPasswordFocus,
                  obscureText: ocultarNuevaPassword,
                  obscureTextFunc: () {
                    setState(() {
                      ocultarNuevaPassword = !ocultarNuevaPassword;
                    });
                  },
                  text: "Nueva contraseña *",
                  icon: MaterialIcons.lock,
                  ltrbp: const [0, 10, 0, 10],
                ),
                PasswordTextform(
                  controller: repetirPassword,
                  focusNode: repetirPasswordFocus,
                  obscureText: ocultarRepetirPassword,
                  obscureTextFunc: () {
                    setState(() {
                      ocultarRepetirPassword = !ocultarRepetirPassword;
                    });
                  },
                  text: "Repetir contraseña *",
                  icon: MaterialIcons.lock,
                  ltrbp: const [0, 10, 0, 10],
                ),
              ],
            ),
          ),
          SolidButton(
            texto: esNueva ? "Actualizar contraseña" : "Guardar contraseña",
            icono: MaterialIcons.save,
            fondoColor: ColorList.sys[2],
            textoColor: ColorList.sys[0],
            ltrbm: const [0, 0, 0, 0,],
            onPressed: guardarPassword,
            onLongPress: () {},
          ),
        ],
      );
    });
  }
}