import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/columns/cobranza_googlemap_column.dart';
import '../../widgets/combo/selection_combo.dart';
import '../../widgets/containers/basic_bottom_sheet_container.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/inkwells/icono_boton_inkwell.dart';
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
                    IconoBotonInkwell(
                      onTap: _.abrirContactos,
                      icon: MaterialIcons.contact_page,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: StandardTextform(
                        text: "Cantidad *",
                        controller: _.cantidad,
                        focusNode: _.cantidadFocus,
                        icon: MaterialIcons.attach_money,
                        keyboardType: TextInputType.number,
                        enabled: _.nuevo,
                      ),
                    ),
                    IconoBotonInkwell(
                      onTap: _.abrirCalculadora,
                      icon: FontAwesome.calculator,
                    ),
                  ],
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
                Row(
                  children: [
                    Expanded(
                      child: StandardTextform(
                        controller: _.direccion,
                        focusNode: _.direccionFocus,
                        text: "Dirección",
                        icon: MaterialIcons.home,
                      ),
                    ),
                    IconoBotonInkwell(
                      onTap: () async {
                        if(await _.abrirMapa()) {
                          await showMaterialModalBottomSheet(
                            // ignore: use_build_context_synchronously
                            context: context,
                            expand: true,
                            enableDrag: false,
                            backgroundColor: Colors.transparent,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) {
                                return BasicBottomSheetContainer(
                                  context: context,
                                  cerrar: true,
                                  child: CobranzaGooglemapColumn(
                                    markers: _.marcadorCliente.values.toSet(),
                                    target: _.initLocation,
                                    googleController: _.googleController,
                                    onTap: (pos) {
                                      setState(() {
                                        _.crearClienteMarcador(pos);
                                      });
                                    },
                                    value: _.utilizarUbicacionCliente,
                                    onChanged: (val) {
                                      setState(() {
                                        _.seleccionarUbicacionCliente(val);
                                      });
                                    },
                                  ),
                                );
                              }
                            ),
                          );
                        }
                      },
                      icon: MaterialIcons.location_on,
                    ),
                  ],
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