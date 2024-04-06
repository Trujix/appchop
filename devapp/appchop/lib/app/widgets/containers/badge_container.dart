import 'package:flutter/widgets.dart';

class BadgeContainer extends StatelessWidget {
  final String texto;
  final int textoColor;
  final int fondoColor;
  const BadgeContainer({
    super.key,
    this.texto = "",
    this.textoColor = 0xFFFDFEFE,
    this.fondoColor = 0xFFB2BABB,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
      margin: const EdgeInsets.fromLTRB(5, 2, 5, 2,),
      decoration: BoxDecoration(
        color: Color(fondoColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: Color(textoColor),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}