import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../data/models/local_storage/notas.dart';
import '../../utils/color_list.dart';
import '../containers/card_container.dart';

class NotasListadoColumn extends StatelessWidget {
  final List<Notas> listaNotas;
  final String usuario;
  final void Function(Notas) onTap;
  const NotasListadoColumn({
    super.key,
    this.listaNotas = const [],
    required this.usuario,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: listaNotas.map((nota) {
        return InkWell(
          onTap: () => onTap(nota),
          child: CardContainer(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            fondo: ColorList.ui[3],
            children: [
              Row(
                children: [
                  Visibility(
                    visible:
                        nota.usuarioCrea != usuario && nota.usuarioVisto == "",
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
  }
}