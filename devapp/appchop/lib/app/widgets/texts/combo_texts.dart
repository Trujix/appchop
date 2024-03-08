import 'package:flutter/widgets.dart';

class ComboText extends StatelessWidget {
  final String texto;
  final double fontSize;
  const ComboText({
    super.key,
    this.texto = "",
    this.fontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: fontSize,
      ),
    );
  }
}