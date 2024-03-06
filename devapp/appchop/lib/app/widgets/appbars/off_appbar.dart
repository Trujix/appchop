import 'package:flutter/material.dart';

class OffAppbar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color color;
  final Widget leading;

  const OffAppbar({
    super.key,
    this.height = 0,
    this.color = Colors.transparent,
    this.leading = const SizedBox(height: 0,),
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: color,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}