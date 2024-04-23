import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../data/models/busqueda_popup_opciones.dart';
import '../../utils/color_list.dart';

class OptionsAppbar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final void Function() onTap;
  final void Function(String?) onTapPopup;
  final void Function(String?) onChanged;
  final void Function() onTapClear;
  final List<BusquedaPopupOpciones> opciones;
  final String? opcionPopup;
  final double height;
  final int? iconoColor;
  final int fondo;
  const OptionsAppbar({
    super.key,
    this.controller,
    required this.onTap,
    required this.onTapPopup,
    required this.onChanged,
    required this.onTapClear,
    this.opciones = const [],
    this.opcionPopup = "",
    this.height = 50,
    this.iconoColor,
    this.fondo = 0xFFFFFFFF,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(fondo),
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Busqueda',
          prefixIcon: const Icon(
            MaterialIcons.search,
          ),
          suffixIcon: IconButton(
            onPressed: onTapClear, 
            icon: const Icon(
              Icons.clear,
              size: 16,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
      leading: IconButton(
        onPressed: onTap,
        icon: Icon(
          MaterialIcons.arrow_back,
          color: Color(iconoColor ?? ColorList.sys[0]),
          size: 24,
        ),
      ),
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (value) {},
          itemBuilder: (BuildContext context) {
            return opciones.map((BusquedaPopupOpciones opcion) {
              return CheckedPopupMenuItem(
                checked: opcionPopup == opcion.id,
                value: opcion.id,
                labelTextStyle: MaterialStateProperty.all(
                  TextStyle(
                    color: Color(ColorList.sys[0]),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  onTapPopup(opcion.id);
                },
                child: Text(opcion.value!,),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}