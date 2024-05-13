import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/widgets.dart';

import '../../utils/color_list.dart';
import '../../utils/svg_assets.dart';
import '../sizedboxes/svg_asset_sizedbox.dart';

class SinElementosColumn extends StatelessWidget {
  final String imagenAsset;
  final double sizeAsset;
  final String texto;
  const SinElementosColumn({
    super.key,
    this.imagenAsset = "",
    this.texto = "",
    this.sizeAsset = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgAssetSizedbox(
          assets: SvgAssets.assets[imagenAsset]!,
          size: sizeAsset,
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