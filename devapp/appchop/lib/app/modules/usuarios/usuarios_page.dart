import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/containers/basic_bottom_sheet_container.dart';
import '../../widgets/containers/titulo_container.dart';
import 'usuarios_controller.dart';

class UsuariosPage extends StatelessWidget {
  const UsuariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsuariosController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.sys[3]),
        appBar: BackAppbar(
          cerrar: _.cerrar,
          fondo: ColorList.sys[3],
        ),
        body: Column(
          children: [
            const TituloContainer(
              texto: "Gestión de usuarios",
              ltrbp: [20, 0, 0, 0],
              size: 18,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showMaterialModalBottomSheet(
              context: context,
              expand: true,
              enableDrag: false,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  StatefulBuilder(builder: (context, setState) {
                return BasicBottomSheetContainer(
                  context: context,
                  cerrar: true,
                  child: Text("Prueba"),
                );
              }),
            );
          },
          shape: const CircleBorder(),
          backgroundColor: Color(ColorList.sys[2]),
          child: Icon(
            MaterialIcons.add,
            color: Color(ColorList.sys[0]).toMaterialColor(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      ),
    );
  }
}
