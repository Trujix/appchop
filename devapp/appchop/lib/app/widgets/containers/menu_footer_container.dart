import 'package:flutter/material.dart';

import '../../utils/color_list.dart';

class MenuFooterContainer extends StatelessWidget {
  final List<Widget> widgets;
  final double height;

  const MenuFooterContainer({
    super.key,
    this.height = 130,
    this.widgets = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.only(
        left: 10,
      ),
      child: Scaffold(
        backgroundColor: Color(ColorList.sys[0]),
        body: Column(
          children: widgets,
        ),
      ),
    );
  }
}