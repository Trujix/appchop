import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';

class SelectionCombo extends StatelessWidget {
  final String texts;
  final List<BottomSheetAction> values;
  final String titulo;
  final TextEditingController? controller;
  final List<double> ltrb;
  final IconData icono;
  final TextInputType keyboard;
  final int maxLength;
  final bool mayuscula;
  final bool enabled;
  final double height;
  final TextAlignVertical textAlignVertical;
  const SelectionCombo({
    super.key,
    this.texts = '',
    this.values = const [],
    this.titulo = 'Elige una opción',
    this.controller,
    this.ltrb = const [10, 10, 10, 10],
    this.icono = MaterialIcons.check,
    this.keyboard = TextInputType.text,
    this.maxLength = 9999999,
    this.mayuscula = true,
    this.enabled = true,
    this.height = 80,
    this.textAlignVertical = TextAlignVertical.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(
        left: ltrb[0],
        top: ltrb[1],
        right: ltrb[2],
        bottom: ltrb[3],
      ),
      child: TextFormField(
        onTap: () => showAdaptiveActionSheet(
          context: context,
          title: Text(titulo),
          androidBorderRadius: 30,
          actions: values,
        ),
        readOnly: true,
        controller: controller,
        textAlignVertical: textAlignVertical,
        keyboardType: keyboard,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: '',
          labelText: texts,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            icono,
            color: Color(ColorList.sys[0]),
          ),
          hintText: texts,
        ),
        textCapitalization:
            mayuscula ? TextCapitalization.characters : TextCapitalization.none,
        enabled: enabled,
      ),
    );
  }
}