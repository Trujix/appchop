import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import 'inventarios_controller.dart';

class InventariosPage extends StatelessWidget {
  const InventariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventariosController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.sys[3]),
        appBar: BackAppbar(
          cerrar: _.cerrar,
          fondo: ColorList.sys[3],
        ),
        body: Column(
          children: [],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _.elegir,
          shape: const CircleBorder(),
          backgroundColor: Color(ColorList.sys[2]),
          child: Icon(
            MaterialIcons.post_add,
            color: Color(ColorList.sys[0]).toMaterialColor(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      ),
    );
  }
}