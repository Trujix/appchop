import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../data/models/menu_popup_opciones.dart';
import '../../utils/color_list.dart';

class MenuAppbar extends StatelessWidget implements PreferredSizeWidget {
  final void Function() cerrar;
  final int fondo;
  final int? iconoColor;
  final String texto;
  final int textoColor;
  final List<MenuPopupOpciones> opciones;
  final void Function(String?) onTapPopup;

  const MenuAppbar({
    super.key,
    required this.cerrar,
    this.fondo = 0xFFFFFFFF,
    this.iconoColor,
    this.texto = "",
    this.textoColor = 0xFF000000,
    this.opciones = const [],
    required this.onTapPopup,
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
      actions: <Widget>[
         PopupMenuButton(
          onSelected: (value) {},
          itemBuilder: (BuildContext context) {
            return opciones.map((MenuPopupOpciones opcion) {
              return PopupMenuItem(
                onTap: () {
                  onTapPopup(opcion.id);
                },
                  labelTextStyle: WidgetStateProperty.all(
                    TextStyle(
                      color: Color(ColorList.sys[0]),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      opcion.icono,
                      color: Color(ColorList.sys[0]),
                    ),
                    title: Text(opcion.value!,),
                  ),
              );
            }).toList();
          }
         ),
      ],
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