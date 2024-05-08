import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/color_list.dart';

class EtiquetaJumpText extends StatelessWidget {
  final String texto1;
  final String texto2;
  final IconData icono;
  final List<double> ltrbp;
  const EtiquetaJumpText({
    super.key,
    this.texto1 = "",
    this.texto2 = "",
    this.icono = Icons.person,
    this.ltrbp = const [0, 2, 0, 2,],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icono,
                color: Color(ColorList.sys[0]),
                size: 20,
              ),
              AutoSizeText.rich(
                TextSpan(
                  text: texto1,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(ColorList.sys[0]),
                  ),
                ),
                minFontSize: 5,
                maxLines: 2,
              ),
            ],
          ),
          AutoSizeText(
            texto2,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(ColorList.sys[0]),
            ),
            minFontSize: 5,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}