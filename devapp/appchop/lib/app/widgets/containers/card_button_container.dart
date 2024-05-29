import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';
import '../texts/etiqueta_text.dart';
import 'card_container.dart';

class CardButtonContainer extends StatelessWidget {
  final String texto;
  final IconData? icono;
  final void Function() onTap;
  const CardButtonContainer({
    super.key,
    this.texto = "",
    this.icono,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CardContainer(
        padding: const EdgeInsets.fromLTRB(20, 8, 10, 8),
        margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        fondo: ColorList.ui[3],
        children: [
          Row(
            children: [
              Expanded(
                child: EtiquetaText(
                  texto1: texto,
                  icono: icono!,
                ),
              ),
              Icon(
                MaterialIcons.navigate_next,
                color: Color(ColorList.sys[0]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}