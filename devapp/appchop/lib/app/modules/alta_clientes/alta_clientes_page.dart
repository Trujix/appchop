import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/columns/sin_elementos_column.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/customscrollviews/clientes_customscrollview.dart';
import '../../widgets/inkwells/icono_boton_inkwell.dart';
import '../../widgets/textforms/standard_textform.dart';
import 'alta_clientes_controller.dart';

class AltaClientesPage extends StatelessWidget {
  const AltaClientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AltaClientesController>(
      builder: (_) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(ColorList.ui[1]),
        appBar: BackAppbar(
          cerrar: _.cerrar,
          fondo: ColorList.ui[1],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TituloContainer(
              texto: "Gestión de clientes",
              ltrbp: [20, 0, 0, 0],
              size: 18,
            ),
            CardContainer(
              fondo: ColorList.ui[3],
              children: [
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
                      onTap: _.agregarClienteDirectorio,
                      icon: MaterialIcons.contact_phone,
                    ),
                  ],
                ),
                StandardTextform(
                  controller: _.telefono,
                  focusNode: _.telefonoFocus,
                  text: "Teléfono *",
                  icon: MaterialIcons.phone_iphone,
                  keyboardType: TextInputType.phone,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AutoSizeText(
                        "Clientes registrados: ${_.totalClientes}",
                        maxLines: 1,
                        style: TextStyle(
                          color: Color(ColorList.sys[0]),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if(_.listaClientes.isNotEmpty) {
                    return ClientesCustomscrollview(
                      scrollController: _.scrollController,
                      listaClientes: _.listaClientes,
                      onChanged: _.cambiarClienteEstatus,
                    );
                  } else {
                    return const SinElementosColumn(
                      texto: "Su lista de clientes está vacía",
                      imagenAsset: "clientes_search",
                      sizeAsset: 230,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _.guardarCliente,
          shape: const CircleBorder(),
          backgroundColor: Color(ColorList.sys[2]),
          child: Icon(
            MaterialIcons.save,
            color: Color(ColorList.sys[0]).toMaterialColor(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      ),
    );
  }
}