import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/color_list.dart';
import '../containers/card_container.dart';
import '../containers/titulo_container.dart';

class NotificacionUsuarioPasswordModal extends StatelessWidget {
  final String password;
  const NotificacionUsuarioPasswordModal({
    super.key,
    this.password = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const TituloContainer(
          texto: "El Administrador le ha enviado su nueva contraseña:",
          ltrbp: [25, 2, 25, 10,],
          size: 15,
        ),
        CardContainer(
          fondo: ColorList.sys[2],
          margin: const EdgeInsets.fromLTRB(25, 10, 25, 0),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  password,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(ColorList.sys[0]),
                  ),
                  maxLines: 1,
                  minFontSize: 22,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}