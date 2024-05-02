import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';

class ActivoInactivoSlidable extends StatelessWidget {
  final Widget child;
  final void Function() cambiar;
  final bool enabled;
  final bool activo;
  const ActivoInactivoSlidable({
    super.key,
    required this.child,
    required this.cambiar,
    this.enabled = true,
    required this.activo,
  });
  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enabled,
      endActionPane: ActionPane(
        extentRatio: 0.30,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            spacing: 1,
            flex: 1,
            onPressed: (_) {
              cambiar();
            },
            backgroundColor: Color(ColorList.theme[activo ? 3 : 1]),
            foregroundColor: Colors.white,
            icon: activo ? MaterialIcons.block : MaterialIcons.restore,
            label: activo ? "Inactivar" : "Activar",
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}