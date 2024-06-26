import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/color_list.dart';
import '../../utils/svg_assets.dart';
import '../sizedboxes/svg_asset_sizedbox.dart';

class SinBusquedaCenter extends StatelessWidget {
  final String texto;
  const SinBusquedaCenter({
    super.key,
    this.texto = "",
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Expanded(child: SizedBox()),
          SvgAssetSizedbox(
            assets: SvgAssets.assets['busqueda_fondo']!,
            size: 230,
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: AutoSizeText(
              texto,
              minFontSize: 16,
              maxLines: 2,
              style: TextStyle(
                color: Color(ColorList.sys[0]),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}