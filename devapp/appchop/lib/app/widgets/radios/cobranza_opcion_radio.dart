import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CobranzaOpcionRadio extends StatelessWidget {
  final int value;
  final int radioValue;
  final String titulo;
  final int maxLines;
  final double minFontSize;
  final int textoColor;
  final int radioColor;
  final void Function(int?) onChanged;
  const CobranzaOpcionRadio({
    super.key,
    this.value = 0,
    this.radioValue = 0,
    this.titulo = '',
    this.maxLines = 1,
    this.minFontSize = 9,
    required this.onChanged,
    this.textoColor = 0xFF566573,
    this.radioColor = 0xFF1F618D,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Radio(
          activeColor: Color(radioColor),
          value: value,
          groupValue: radioValue,
          onChanged: onChanged,
        ),
        Expanded(
          child: AutoSizeText(
            titulo,
            maxLines: maxLines,
            minFontSize: minFontSize,
            style: TextStyle(
              color: Color(textoColor),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}