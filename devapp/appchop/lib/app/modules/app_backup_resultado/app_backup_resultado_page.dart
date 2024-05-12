import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';

import '../../utils/color_list.dart';
import 'app_backup_resultado_controller.dart';

class AppBackupResultadoPage extends StatelessWidget with WidgetsBindingObserver {
  const AppBackupResultadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppBackupResultadoController>(
      builder: (_) => PopScope(
        canPop: _.respaldoTerminado,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(ColorList.ui[1]),
          body: Column(
            children: [],
          ),
          floatingActionButton: Visibility(
            visible: _.respaldoTerminado,
            child: FloatingActionButton(
              onPressed: _.salir,
              shape: const CircleBorder(),
              backgroundColor: Color(ColorList.sys[2]),
              child: Icon(
                MaterialIcons.arrow_back,
                color: Color(ColorList.sys[0]).toMaterialColor(),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        ),
      ),
    );
  }
}