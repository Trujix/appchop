import 'package:appchop/app/widgets/texts/etiqueta_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/off_appbar.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import 'app_backup_resultado_controller.dart';

class AppBackupResultadoPage extends StatelessWidget with WidgetsBindingObserver {
  const AppBackupResultadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppBackupResultadoController>(
      builder: (_) => PopScope(
        canPop: _.respaldoTerminado,
        child: Scaffold(
          appBar: const OffAppbar(
            height: 30,
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Color(ColorList.ui[1]),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TituloContainer(
                texto: _.tituloRespaldo,
                ltrbp: const [20, 5, 20, 5],
                size: 18,
              ),
              CardContainer(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                children: [
                  Column(
                    children: _.etiquetas.map((etiqueta) {
                      return EtiquetaText(
                        texto1: etiqueta.texto1,
                        texto2: etiqueta.texto2,
                        icono: etiqueta.icono,
                        ltrbp: const [0, 2, 0, 15],
                      );
                    }).toList(),
                  ),
                  TituloContainer(
                    texto: !_.respaldoTerminado ? "Por favor espere..." : "Respaldo terminado",
                    ltrbp: const [5, 5, 5, 10],
                    size: 16,
                  ),
                ],
              ),
              Visibility(
                visible: !_.respaldoTerminado,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitWave(
                      color: Color(ColorList.theme[4]),
                    ),
                  ],
                ),
              ),
            ],
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