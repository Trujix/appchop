import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../utils/color_list.dart';
import '../../utils/literals.dart';
import '../../utils/svg_assets.dart';
import '../sizedboxes/svg_asset_sizedbox.dart';

class MenuHeaderContainer extends StatelessWidget {
  final String idUsduario;
  final String nombre;
  final void Function() actualizarImagen;
  const MenuHeaderContainer({
    super.key,
    this.idUsduario = "",
    this.nombre = "",
    required this.actualizarImagen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
      ),
      height: 150,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            Row(
              children: [
                InkWell(
                  onTap: actualizarImagen,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      color: Colors.transparent,
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2000.0),
                      child: CachedNetworkImage(
                        imageUrl: "${Literals.uri}media/usuarios/$idUsduario.jpg",
                        errorWidget: (context, url, error) {
                          return SvgAssetSizedbox(
                            assets: SvgAssets.assets['alpha_logo']!,
                            size: 80,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                AutoSizeText(
                  'BIENVENIDO',
                  style: TextStyle(
                    color: Color(ColorList.sys[1]),
                    fontWeight: FontWeight.bold,
                  ),
                  minFontSize: 16,
                  maxFontSize: 18,
                  maxLines: 1,
                )
              ],
            ),
            Row(
              children: <Widget>[
                AutoSizeText(
                  nombre,
                  style: TextStyle(
                    color: Color(ColorList.sys[1]),
                    fontWeight: FontWeight.w300,
                  ),
                  minFontSize: 10,
                  maxFontSize: 18,
                  maxLines: 1,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}