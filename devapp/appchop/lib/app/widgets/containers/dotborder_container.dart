import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DotborderContainer extends StatelessWidget {
  final List<Widget> children;
  final int fondo;
  final double padding;
  final List<double> ltrbm;
  final List<double> bordeEstilo;
  final double bordeGrosor;
  final int bordeColor;
  const DotborderContainer({
    super.key,
    this.children = const [],
    this.fondo = 0xFFEAECEE,
    this.padding = 10,
    this.ltrbm = const [10, 10, 10, 10],
    this.bordeEstilo = const <double>[10, 6],
    this.bordeGrosor = 1,
    this.bordeColor = 0xFF474949,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        ltrbm[0],
        ltrbm[1],
        ltrbm[2],
        ltrbm[3],
      ),
      padding: EdgeInsets.all(padding),
      child: DottedBorder(
        dashPattern: bordeEstilo,
        strokeWidth: bordeGrosor,
        color: Color(bordeColor),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Color(fondo),
            border: Border.all(
              color: Color(fondo),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}