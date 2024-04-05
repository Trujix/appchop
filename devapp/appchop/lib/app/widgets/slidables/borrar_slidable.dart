import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class BorrarSlidable extends StatelessWidget {
  final Widget child;
  final void Function() onBorrar;
  final bool enabled;
  const BorrarSlidable({
    super.key,
    required this.child,
    required this.onBorrar,
    this.enabled = true,
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
              onBorrar();
            },
            backgroundColor: const Color(0xFFE74C3C),
            foregroundColor: Colors.white,
            icon: MaterialIcons.delete_outline,
            label: 'Eliminar',
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