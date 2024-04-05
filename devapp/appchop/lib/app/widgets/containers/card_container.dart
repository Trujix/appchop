import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final List<Widget> children;
  final int fondo;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final CrossAxisAlignment columnAlign;
  final double width;
  final double radius;
  const CardContainer({
    super.key,
    this.children = const [],
    this.fondo = 0xFFEAECEE,
    this.padding = const EdgeInsets.all(10,),
    this.margin = const EdgeInsets.fromLTRB(10, 10, 10, 10),
    this.columnAlign = CrossAxisAlignment.start,
    this.width = double.infinity,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      width: width,
      decoration: BoxDecoration(
        color: Color(fondo),
        border: Border.all(
          color: Color(fondo),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
      ),
      child: Column(
        crossAxisAlignment: columnAlign,
        children: children,
      ),
    );
  }
}