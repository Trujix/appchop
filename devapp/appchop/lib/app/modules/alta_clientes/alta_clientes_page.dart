import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import 'alta_clientes_controller.dart';

class AltaClientesPage extends StatelessWidget {
  const AltaClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AltaClientesController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.sys[3]),
        appBar: BackAppbar(
          cerrar: _.cerrar,
          fondo: ColorList.sys[3],
        ),
        body: const Column(
          children: [

          ],
        ),
      ),
    );
  }
}