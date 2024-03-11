import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/combo/selection_combo.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/radiobuttons/group_radiobutton.dart';
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
            TituloContainer(
              texto: "${_.nuevo ? "Nuevo" : "Editar"} Cobranza",
              ltrbp: const [20, 0, 0, 5],
            ),
            const TituloContainer(
              texto: '(*) - Los campos son olbigatorios',
              ltrbp: [20, 0, 0, 5],
              size: 14,
            ),
            CardContainer(
              fondo: 0xFFFDFEFE,
              children: [
                GroupRadiobutton(
                  buttonLables: _.labelsTipoCobranza,
                  buttonValues: _.valuesTipoCobranza,
                  defaultSelected: _.tipoCobranza,
                  radioButtonValue: _.cobranzaSelected,
                ),
                SelectionCombo(
                  titulo: "- Elige categoría -",
                  controller: _.categoria,
                  values: _.listaCategoria,
                  icono: MaterialIcons.list_alt,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: StandardTextform(
                        controller: _.nombre,
                        focusNode: _.nombreFocus,
                        text: "Nombre *",
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
                  text: "Cantidad *",
                  controller: _.cantidad,
                  focusNode: _.cantidadFocus,
                  icon: MaterialIcons.attach_money,
                  keyboardType: TextInputType.number,
                  enabled: _.nuevo,
                ),
              ],
            ),
            CardContainer(
              fondo: 0xFFFDFEFE,
              children: [
                StandardTextform(
                  controller: _.descripcion,
                  focusNode: _.descripcionFocus,
                  text: "Descripción (80 caract.)",
                  icon: MaterialIcons.description,
                  maxLength: 80,
                ),
                StandardTextform(
                  controller: _.telefono,
                  focusNode: _.telefonoFocus,
                  text: "Teléfono",
                  icon: MaterialIcons.phone_iphone,
                  keyboardType: TextInputType.phone,
                ),
                StandardTextform(
                  controller: _.direccion,
                  focusNode: _.direccionFocus,
                  text: "Dirección",
                  icon: MaterialIcons.home,
                ),
                StandardTextform(
                  controller: _.email,
                  focusNode: _.emailFocus,
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
              texto: "Guardar ${_.nuevo ? "registro" : "cambios"}",
              icono: MaterialIcons.save,
              fondoColor: ColorList.sys[2],
              textoColor: ColorList.sys[0],
              ltrbm: const [0, 0, 0, 15,],
              onPressed: _.guardarNuevaCobranza,
              onLongPress: () {},
            ),
          ],
        ),
      ),
    );
  }
}