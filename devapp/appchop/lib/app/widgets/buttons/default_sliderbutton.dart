import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:slider_button/slider_button.dart';

import '../../utils/color_list.dart';

class DefaultSliderbutton extends StatelessWidget {
  final String mensaje;
  final Future<bool?> Function() action;
  final List<double> ltrbp;
  const DefaultSliderbutton({
    super.key,
    this.mensaje = "Deslizar para aceptar",
    required this.action,
    this.ltrbp = const [10, 10, 10, 10],
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ltrbp[0],
        ltrbp[1],
        ltrbp[2],
        ltrbp[3],
      ),
      child: SliderButton(
        width: double.infinity,
        height: 60,
        alignLabel: Alignment.center,
        action: action,
        label: Text(
          mensaje,
          style: TextStyle(
            color: Color(ColorList.sys[0]),
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        icon: Icon(
          MaterialIcons.arrow_forward_ios,
          color: Color(ColorList.sys[0]),
        ),
        backgroundColor: const Color(0xFFF2F4F4),
        buttonColor: Color(ColorList.sys[1]),
        baseColor: Color(ColorList.sys[0]),
      ),
    );
  }
}