import 'package:flutter/widgets.dart';

class ComboText extends StatelessWidget {
  final String texto;
  final double fontSize;
  final FontWeight fontWeight;
  const ComboText({
    super.key,
    this.texto = "",
    this.fontSize = 15,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}