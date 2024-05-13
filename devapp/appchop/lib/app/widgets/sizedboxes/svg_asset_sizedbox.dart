import 'package:flutter/material.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

import '../../data/models/svg_imagenes.dart';
import '../../utils/color_list.dart';
import '../painters/svg_custom_painter.dart';

class SvgAssetSizedbox extends StatelessWidget {
  final List<SvgImagenes> assets;
  final double size;
  const SvgAssetSizedbox({
    super.key,
    required this.assets,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: assets.map((asset) {
              int color = asset.color!;
              if(color >= 0 && color <= 2) {
                color = ColorList.sys[asset.color!];
              }
              return CustomPaint(
                painter: SvgCustomPainter(
                  path: parseSvgPath(asset.path!),
                  color: Color(color),
                  sizeOriginal: asset.sizeOrignal!,
                ),
                willChange: true,
                isComplex: true,
                child: SizedBox.square(dimension: size),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}