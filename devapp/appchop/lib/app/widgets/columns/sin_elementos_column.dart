import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';

import '../../utils/color_list.dart';

class SinElementosColumn extends StatelessWidget {
  final String imagenAsset;
  final String texto;
  const SinElementosColumn({
    super.key,
    this.imagenAsset = "",
    this.texto = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/$imagenAsset",
          scale: 1.1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10,),
              child: AutoSizeText(
                texto,
                maxLines: 2,
                minFontSize: 18,
                style: TextStyle(
                  color: Color(ColorList.sys[0]),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}