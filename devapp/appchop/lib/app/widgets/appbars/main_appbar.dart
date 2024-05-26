import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../data/models/menu_popup_opciones.dart';
import '../../utils/color_list.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final void Function() onTap;
  final void Function(String?) onTapPopup;
  final void Function(String?) onChanged;
  final void Function() onTapClear;
  final List<MenuPopupOpciones> opciones;
  final String? opcionPopup;
  final double height;
  const MainAppbar({
    super.key,
    this.controller,
    required this.onTap,
    required this.onTapPopup,
    required this.onChanged,
    required this.onTapClear,
    this.opciones = const [],
    this.opcionPopup = "",
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(ColorList.ui[1]),
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
      leading: GestureDetector(
        onTap: onTap,
        child: Icon(
          MaterialIcons.menu,
          color: Color(ColorList.sys[0]),
        ),
      ),
      actions: <Widget>[
        PopupMenuButton(
          onSelected: (value) {},
          itemBuilder: (BuildContext context) {
            return opciones.map((MenuPopupOpciones opcion) {
              return opcion.tipo == "R" 
                ? CheckedPopupMenuItem(
                  checked: opcionPopup == opcion.id,
                  value: opcion.id,
                  labelTextStyle: WidgetStateProperty.all(
                    TextStyle(
                      color: Color(ColorList.sys[0]),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    onTapPopup(opcion.id);
                  },
                  child: Text(opcion.value!,),
                ) : PopupMenuItem(
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
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}