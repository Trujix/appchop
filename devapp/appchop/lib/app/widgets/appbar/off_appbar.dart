import 'package:flutter/material.dart';

class OffAppbar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color color;

  const OffAppbar({
    super.key,
    this.height = 0,
    this.color = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: color,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}