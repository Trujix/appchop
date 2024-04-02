import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';

class BackAppbar extends StatelessWidget implements PreferredSizeWidget {
  final void Function() cerrar;
  final int fondo;
  final int? iconoColor;
  final String texto;
  final int textoColor;

  const BackAppbar({
    super.key,
    required this.cerrar,
    this.fondo = 0xFFFFFFFF,
    this.iconoColor,
    this.texto = "",
    this.textoColor = 0xFF000000,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        texto,
        style: TextStyle(
          color: Color(textoColor),
          fontSize: 16,
        ),
      ),
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Color(fondo),
      leading: IconButton(
        onPressed: cerrar,
        icon: Icon(
          MaterialIcons.arrow_back,
          color: Color(iconoColor ?? ColorList.sys[0]),
          size: 30,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight);
}