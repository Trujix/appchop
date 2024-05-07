import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';

class BorrarPdfSlidable extends StatelessWidget {
  final Widget child;
  final void Function() onBorrar;
  final void Function() onPdf;
  final bool enabled;
  const BorrarPdfSlidable({
    super.key,
    required this.child,
    required this.onBorrar,
    required this.onPdf,
    this.enabled = true,
  });
  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enabled,
      endActionPane: ActionPane(
        extentRatio: 0.50,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 1,
            flex: 1,
            onPressed: (_) {
              onBorrar();
            },
            backgroundColor: Color(ColorList.theme[3]),
            foregroundColor: Color(ColorList.ui[0]),
            icon: MaterialIcons.delete_outline,
            label: 'Eliminar',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          SlidableAction(
            spacing: 1,
            flex: 1,
            onPressed: (_) {
              onPdf();
            },
            backgroundColor: Color(ColorList.theme[4]),
            foregroundColor: Color(ColorList.ui[0]),
            icon: MaterialIcons.picture_as_pdf,
            label: 'Exportar',
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              bottomLeft: Radius.circular(0),
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}