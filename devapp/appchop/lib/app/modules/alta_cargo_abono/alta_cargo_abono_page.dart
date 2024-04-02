import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import 'alta_cargo_abono_controller.dart';

class AltaCargoAbonoPage extends StatelessWidget with WidgetsBindingObserver {
  const AltaCargoAbonoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AltaCargoAbonoController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.sys[3]),
        appBar: BackAppbar(
          cerrar: _.cerrar,
          fondo: ColorList.sys[3],
        ),
        body: ListView(
          children: <Widget>[
            
          ],
        ),
      ),
    );
  }
}