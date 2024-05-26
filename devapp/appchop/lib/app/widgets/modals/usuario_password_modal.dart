import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';
import '../buttons/circular_buttons.dart';
import '../containers/titulo_container.dart';

class UsuarioPasswordModal extends StatelessWidget {
  final void Function() cambiarMostrar;
  final void Function() cambiarEnviar;
  final String usuario;
  const UsuarioPasswordModal({
    super.key,
    required this.cambiarMostrar,
    required this.cambiarEnviar,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TituloContainer(
          texto: "Usuario: $usuario",
          size: 14,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Ver contraseña',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(ColorList.sys[0]),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CircularButton(
                    icono: MaterialIcons.visibility,
                    color: ColorList.sys[1],
                    colorIcono: ColorList.sys[0],
                    onPressed: cambiarMostrar,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Enviar contraseña',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(ColorList.sys[0]),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CircularButton(
                    icono: MaterialIcons.notifications_active,
                    color: ColorList.sys[2],
                    colorIcono: ColorList.sys[0],
                    onPressed: cambiarEnviar,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}