import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';

class SearchAppbar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final void Function() onTap;
  final void Function(String?) onChanged;
  final void Function() onTapClear;
  final double height;
  final int? iconoColor;
  final int fondo;
  const SearchAppbar({
    super.key,
    this.controller,
    required this.onTap,
    required this.onChanged,
    required this.onTapClear,
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}