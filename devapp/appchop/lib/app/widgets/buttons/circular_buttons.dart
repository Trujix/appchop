import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final double size;
  final int color;
  final IconData icono;
  final int colorIcono;
  final double iconoSize;
  final double iconoPadding;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final void Function() onPressed;
  final double elevation;
  const CircularButton({
    super.key,
    this.size = 35,
    this.color = 0xFFF0F3F4,
    this.icono = Icons.menu,
    this.colorIcono = 0xFFC0392B,
    this.iconoSize = 14,
    this.iconoPadding = 5,
    this.padding = const EdgeInsets.all(0,),
    this.margin = const EdgeInsets.fromLTRB(5, 0, 5, 0,),
    required this.onPressed,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(elevation),
          shape: WidgetStateProperty.all(
            const CircleBorder(),
          ),
          padding: WidgetStateProperty.all(
            EdgeInsets.all(iconoPadding),
          ),
          backgroundColor: WidgetStateProperty.all(
            Color(color),
          ),
        ),
        child: Icon(
          icono,
          size: iconoSize,
          color: Color(colorIcono),
        ),
      ),
    );
  }
}