import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../data/models/local_storage/notas.dart';
import '../../utils/color_list.dart';
import '../containers/dotborder_container.dart';
import '../containers/titulo_container.dart';
import '../texts/etiqueta_text.dart';

class NotaDetalleColumn extends StatelessWidget {
  final Notas nota;
  const NotaDetalleColumn({
    super.key,
    required this.nota,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TituloContainer(
          texto: "Nota:",
          ltrbp: [10, 0, 0, 0],
          size: 16,
        ),
        DotborderContainer(
          padding: 15,
          ltrbm: const [0, 10, 0, 10],
          children: [
            Row(
              children: [
                AutoSizeText(
                  nota.nota!,
                  style: TextStyle(
                    color: Color(ColorList.sys[0]),
                  ),
                  maxLines: 6,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        EtiquetaText(
          texto1: "Usuario crea nota:\n",
          texto2: nota.usuarioCrea!,
          icono: MaterialIcons.person,
        ),
        EtiquetaText(
          texto1: "Fecha creación de la nota:\n",
          texto2: nota.fechaCrea!,
          icono: MaterialIcons.calendar_today,
        ),
      ],
    );
  }
}