import 'package:flutter/material.dart';

class SolidButton extends StatelessWidget {
  final String texto;
  final double textoSize;
  final void Function() onPressed;
  final void Function() onLongPress;
  final IconData? icono;
  final int fondoColor;
  final int textoColor;
  final List<double> ltrbp;
  final List<double> ltrbm;
  final double height;
  const SolidButton({
    super.key,
    this.texto = '',
    this.textoSize = 16,
    required this.onPressed,
    required this.onLongPress,
    this.icono,
    this.fondoColor = 0xFFD6DBDF,
    this.textoColor = 0xFF34495E,
    this.ltrbp = const [10, 10, 10, 10,],
    this.ltrbm = const [0, 0, 0, 0,],
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        ltrbm[0],
        ltrbm[1],
        ltrbm[2],
        ltrbm[3],
      ),
      padding: EdgeInsets.fromLTRB(
        ltrbp[0],
        ltrbp[1],
        ltrbp[2],
        ltrbp[3],
      ),
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Color(fondoColor)),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Color(fondoColor)),
            ),
          ),
        ),
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Builder(
              builder: (context) {
                if(icono != null) {
                  return Icon(
                    icono,
                    size: 16,
                    color: Color(textoColor),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
            ),
            Visibility(
              visible: icono != null && texto != "",
              child: const SizedBox(width: 15,),
            ),
            Text(
              texto,
              style: TextStyle(
                fontSize: textoSize,
                fontWeight: FontWeight.bold,
                color: Color(textoColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}