import 'package:flutter/material.dart';

import '../../utils/color_list.dart';

class MenuOpcionInkwell extends StatelessWidget {
  final String texto;
  final IconData icono;
  final bool visible;
  final void Function() onTap;

  const MenuOpcionInkwell({
    super.key,
    this.texto = "",
    this.icono = Icons.abc,
    required this.visible,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 13, 20, 13,),
          child: Row(
            children: <Widget>[
              Icon(
                icono,
                color: Color(ColorList.sys[1]),
                size: 24,
              ),
              const SizedBox(width: 20,),
              Text(
                texto,
                style: TextStyle(
                  color: Color(ColorList.sys[1]),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}