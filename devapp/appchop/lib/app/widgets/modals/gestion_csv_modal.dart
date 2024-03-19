import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';
import '../buttons/circular_buttons.dart';

class GestionCsvModal extends StatelessWidget {
  final void Function() abrirAccion;
  final void Function() exportarAccion;
  const GestionCsvModal({
    super.key,
    required this.abrirAccion,
    required this.exportarAccion,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                'Abrir Archivo',
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
                icono: MaterialIcons.launch,
                color: ColorList.sys[1],
                colorIcono: ColorList.sys[0],
                onPressed: abrirAccion,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Compartir',
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
                icono: MaterialIcons.share,
                color: ColorList.sys[2],
                colorIcono: ColorList.sys[0],
                onPressed: exportarAccion,
              ),
            ],
          ),
        ),
      ],
    );
  }
}