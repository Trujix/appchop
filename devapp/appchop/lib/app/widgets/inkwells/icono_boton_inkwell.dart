import 'package:flutter/material.dart';

import '../../utils/color_list.dart';

class IconoBotonInkwell extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;
  final List<double> ltrbp;
  const IconoBotonInkwell({
    super.key,
    required this.onTap,
    this.icon = Icons.person,
    this.ltrbp = const [0, 10, 10, 10],
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          ltrbp[0],
          ltrbp[1],
          ltrbp[2],
          ltrbp[3],
        ),
        child: Icon(
          icon,
          color: Color(ColorList.sys[0]),
          size: 30,
        ),
      ),
    );
  }
}