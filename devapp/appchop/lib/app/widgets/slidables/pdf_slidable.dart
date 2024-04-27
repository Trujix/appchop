import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class PdfSlidable extends StatelessWidget {
  final Widget child;
  final void Function() onPdf;
  final bool enabled;
  const PdfSlidable({
    super.key,
    required this.child,
    required this.onPdf,
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
              onPdf();
            },
            backgroundColor: const Color(0xFF95A5A6),
            foregroundColor: Colors.white,
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