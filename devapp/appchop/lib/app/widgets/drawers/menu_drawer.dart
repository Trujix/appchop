import 'package:flutter/widgets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../utils/color_list.dart';

class MenuDrawer extends StatelessWidget {
  final ZoomDrawerController controller;
  final List<Widget> menuScreen;
  final Widget mainScreen;
  const MenuDrawer({
    super.key,
    required this.controller,
    this.menuScreen = const [],
    required this.mainScreen,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: controller,
      menuScreen: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xFF0B4251),
        ),
        child: Column(
          children: menuScreen,
        ),
      ),
      mainScreen: mainScreen,
      borderRadius: 24.0,
        showShadow: true,
        angle: -8.0,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
        menuBackgroundColor: Color(ColorList.sys[0]),
        slideWidth: MediaQuery.of(context).size.width * 0.80,
        mainScreenTapClose: true,
    );
  }
}