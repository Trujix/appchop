import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/buttons/default_sliderbutton.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/texts/etiqueta_text.dart';
import 'configuracion_controller.dart';

class ConfiguracionPage extends StatelessWidget with WidgetsBindingObserver {
  const ConfiguracionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfiguracionController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.ui[1]),
        appBar: BackAppbar(
          cerrar: _.cerrar,
          fondo: ColorList.ui[1],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TituloContainer(
              texto: "Información del usuario",
              ltrbp: [20, 0, 0, 0],
              size: 20,
            ),
            CardContainer(
              padding: const EdgeInsets.all(20,),
              fondo: ColorList.ui[3],
              children: [
                EtiquetaText(
                  texto1: "Id de registro\n",
                  texto2: _.idUsuario,
                  icono: MaterialIcons.verified_user,
                ),
                EtiquetaText(
                  texto1: "Usuario\n",
                  texto2: _.usuario,
                  icono: MaterialIcons.account_circle,
                ),
                EtiquetaText(
                  texto1: "Nombre del usuario\n",
                  texto2: _.nombre,
                  icono: MaterialIcons.badge,
                ),
              ],
            ),
            const TituloContainer(
              texto: "Sincronizar con el servidor",
              ltrbp: [20, 5, 0, 0],
              size: 20,
            ),
            SolidButton(
              texto: "Realizar sincronización",
              icono: MaterialIcons.save,
              fondoColor: ColorList.sys[2],
              textoColor: ColorList.sys[0],
              ltrbm: const [0, 0, 0, 15,],
              onPressed: () {},
              onLongPress: () {},
            ),
            const TituloContainer(
              texto: "Desvincular dispositivo",
              ltrbp: [20, 5, 0, 0],
              size: 20,
            ),
            CardContainer(
              fondo: ColorList.sys[2],
              padding: const EdgeInsets.all(15,),
              children: <Widget>[
                AutoSizeText(
                  'Nota: Le recomendamos realizar un respaldo de su información, ya que con este procedimiento los datos almacenados en este dispositivo serán eliminados...',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(ColorList.sys[0]),
                  ),
                ),
              ],
            ),
            DefaultSliderbutton(
              mensaje: "Deslizar para desvincular",
              action: _.desvincularDispositivo,
              ltrbp: const [10, 10, 10, 20,],
            ),
          ],
        ),
      ),
    );
  }
}