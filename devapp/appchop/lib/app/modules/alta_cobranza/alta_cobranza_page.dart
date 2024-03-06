import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/textforms/date_textform.dart';
import '../../widgets/textforms/standard_textform.dart';
import 'alta_cobranza_controller.dart';

class AltaCobranzaPage extends StatelessWidget with WidgetsBindingObserver {
  const AltaCobranzaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AltaCobranzaController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.sys[3]),
        appBar: BackAppbar(
          cerrar: _.cerrar,
          fondo: ColorList.sys[3],
          iconoColor: ColorList.sys[0],
        ),
        body: ListView(
          children: <Widget>[
            const TituloContainer(
              texto: 'Nueva Cobranza',
              ltrbp: [20, 0, 0, 5],
            ),
            CardContainer(
              fondo: 0xFFFDFEFE,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: CustomRadioButton(
                    unSelectedBorderColor: Colors.transparent,
                    selectedBorderColor: Colors.transparent,
                    elevation: 0,
                    radius: 0,
                    shapeRadius: 0,
                    width: (MediaQuery.of(context).size.width / 2) - 50,
                    absoluteZeroSpacing: true,
                    unSelectedColor: Theme.of(context).canvasColor,
                    buttonLables: _.labelsTipoCobranza,
                    buttonValues: _.valuesTipoCobranza,
                    defaultSelected: _.valuesTipoCobranza[0],
                    buttonTextStyle: const ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: Colors.black,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    radioButtonValue: (value) {
                      _.tipoCobranza = value;
                    },
                    selectedColor: Color(ColorList.sys[1]),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: StandardTextform(
                        controller: _.nombre,
                        focusNode: _.nombreFocus,
                        text: "Nombre",
                        icon: MaterialIcons.person,
                      ),
                    ),
                    InkWell(
                      onTap: _.abrirContactos,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Icon(
                          MaterialIcons.contact_page,
                          color: Color(ColorList.sys[0]),
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
                StandardTextform(
                  text: "Cantidad",
                  icon: MaterialIcons.attach_money,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            CardContainer(
              fondo: 0xFFFDFEFE,
              children: [
                StandardTextform(
                  text: "Descripción",
                  icon: MaterialIcons.description,
                ),
                StandardTextform(
                  controller: _.telefono,
                  focusNode: _.telefonoFocus,
                  text: "Teléfono",
                  icon: MaterialIcons.phone_iphone,
                  keyboardType: TextInputType.phone,
                ),
                StandardTextform(
                  text: "Dirección",
                  icon: MaterialIcons.home,
                ),
                StandardTextform(
                  text: "Correo electrónico",
                  icon: MaterialIcons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DateTextform(
                        controller: _.fechaRegistro,
                        focusNode: _.fechaRegistroFocus,
                        dateSelected: _.dateSelected,
                        text: "Fecha registro",
                      ),
                    ),
                    Expanded(
                      child: DateTextform(
                        controller: _.fechaVencimiento,
                        focusNode: _.fechaVencimientoFocus,
                        dateSelected: _.dateSelected,
                        clean: true,
                        text: "Vencimiento",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SolidButton(
              texto: 'Guardar registro',
              icono: MaterialIcons.save,
              fondoColor: ColorList.sys[2],
              textoColor: ColorList.sys[0],
              ltrbm: [
                0,
                0,
                0,
                15,
              ],
              onPressed: () {},
              onLongPress: () {},
            ),
          ],
        ),
      ),
    );
  }
}