import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';

import '../../utils/color_list.dart';

class SinCategoriasColumn extends StatelessWidget {
  const SinCategoriasColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/categorias/background.png",
          scale: 0.9,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10,),
          child: AutoSizeText(
            'No tiene categorías registradas',
            maxLines: 2,
            minFontSize: 18,
            style: TextStyle(
              color: Color(ColorList.sys[0]),
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}