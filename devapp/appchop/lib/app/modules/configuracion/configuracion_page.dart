import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../utils/literals.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/buttons/circular_buttons.dart';
import '../../widgets/buttons/default_sliderbutton.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/containers/card_button_container.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/texts/etiqueta_jump_text.dart';
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
        body: ListView(
          controller: _.scrollController,
          children: [
            Column(
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
                CardContainer(
                  fondo: ColorList.ui[3],
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: EtiquetaText(
                            texto1: "Verificar con el servidor",
                            icono: MaterialIcons.storage,
                          ),
                        ),
                        CircularButton(
                          onPressed: _.verificarServidorBackup,
                          icono: MaterialIcons.sync_icon,
                          colorIcono: ColorList.sys[0],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    EtiquetaJumpText(
                      texto1: " Última actualización:",
                      texto2: "   Id: ${_.idBackup}\n   Fecha: ${_.fechaBackup}",
                      icono: MaterialIcons.sync_alt,
                    ),
                  ],
                ),
                SolidButton(
                  texto: "Realizar sincronización",
                  icono: MaterialIcons.backup,
                  fondoColor: ColorList.sys[1],
                  textoColor: ColorList.sys[0],
                  ltrbm: const [0, 0, 0, 15,],
                  onPressed: _.sincronizar,
                  onLongPress: () {},
                ),
                Visibility(
                  visible: _.esAdmin,
                  child: const TituloContainer(
                    texto: "Reportes generales",
                    ltrbp: [20, 5, 0, 10],
                    size: 20,
                  ),
                ),
                Visibility(
                  visible: _.esAdmin,
                  child: CardButtonContainer(
                    texto: "Lista de clientes",
                    icono: MaterialIcons.description,
                    onTap: () => _.exportarReportes(Literals.reportesClientes),
                  ),
                ),
                Visibility(
                  visible: _.esAdmin,
                  child: CardButtonContainer(
                    texto: "Lista de usuario",
                    icono: MaterialIcons.description,
                    onTap: () => _.exportarReportes(Literals.reportesUsuarios),
                  ),
                ),
                Visibility(
                  visible: _.esAdmin,
                  child: CardButtonContainer(
                    texto: "Base inventarios",
                    icono: MaterialIcons.description,
                    onTap: () => _.exportarReportes(Literals.reportesBaseInventarios),
                  ),
                ),
                const TituloContainer(
                  texto: "Configuración general",
                  ltrbp: [20, 10, 0, 0],
                  size: 20,
                ),
                CardButtonContainer(
                  texto: "Reestablecer estatus manual",
                  icono: MaterialIcons.restore,
                  onTap: () => _.reestablecerEstatusManual(),
                ),
                CardContainer(
                  padding: const EdgeInsets.all(20,),
                  fondo: ColorList.ui[3],
                  children: [
                    EtiquetaText(
                      texto1: "% Bonificación\n",
                      texto2: "${_.configuracion.porcentajeBonificacion} %",
                      icono: FontAwesome.dollar,
                    ),
                    EtiquetaText(
                      texto1: "% Intereses\n",
                      texto2: "${_.configuracion.porcentajeMoratorio} %",
                      icono: MaterialIcons.money_off,
                    ),
                  ],
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
          ],
        ),
      ),
    );
  }
}