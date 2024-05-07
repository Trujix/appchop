import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../utils/color_list.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/buttons/solid_button.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/customscrollviews/cargo_abono_customscrollview.dart';
import '../../widgets/defaults/small_header.dart';
import '../../widgets/inkwells/icono_boton_inkwell.dart';
import '../../widgets/textforms/standard_textform.dart';
import '../../widgets/texts/etiqueta_text.dart';
import 'alta_cargo_abono_controller.dart';

class AltaCargoAbonoPage extends StatelessWidget with WidgetsBindingObserver {
  const AltaCargoAbonoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AltaCargoAbonoController>(
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
            TituloContainer(
              texto: _.pendiente ? "(*) - Los campos son olbigatorios" : "Registro pagado",
              ltrbp: const [20, 0, 0, 0],
              size: 14,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 0,),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: EtiquetaText(
                      texto1: _.etiqueta,
                      texto2: _.cobranzaEditar!.nombre!,
                      icono: MaterialIcons.person,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _.pendiente,
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0,),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: EtiquetaText(
                        texto1: "Saldo pendiente: ",
                        texto2: MoneyFormatter(
                          amount: _.cobranzaEditar!.saldo!,
                        ).output.symbolOnLeft,
                        icono: MaterialIcons.monetization_on,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0,),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  EtiquetaText(
                    texto1: "Cargos: ",
                    texto2: MoneyFormatter(
                      amount: _.saldoCargos,
                    ).output.symbolOnLeft,
                    icono: MaterialIcons.add_circle,
                  ),
                  const SizedBox(width: 15,),
                  EtiquetaText(
                    texto1: "Abonos: ",
                    texto2: MoneyFormatter(
                      amount: _.saldoAbonos,
                    ).output.symbolOnLeft,
                    icono: MaterialIcons.remove_circle,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _.pendiente,
              child: CardContainer(
                fondo: ColorList.ui[3],
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: StandardTextform(
                          text: "Cantidad *",
                          controller: _.cantidad,
                          focusNode: _.cantidadFocus,
                          icon: MaterialIcons.attach_money,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      IconoBotonInkwell(
                        onTap: _.abrirCalculadora,
                        icon: FontAwesome.calculator,
                      ),
                    ],
                  ),
                  StandardTextform(
                    controller: _.referencia,
                    focusNode: _.referenciaFocus,
                    text: "Referencia",
                    icon: MaterialIcons.push_pin,
                    ltrbp: const [10, 0, 10, 0],
                    maxLength: 200,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SolidButton(
                          texto: "Aumentar",
                          icono: MaterialIcons.add_circle,
                          fondoColor: ColorList.sys[2],
                          textoColor: ColorList.sys[0],
                          ltrbm: const [0, 0, 0, 0,],
                          textoSize: 14,
                          onPressed: _.crearCargo,
                          onLongPress: () {},
                        ),
                      ),
                      Expanded(
                        child: SolidButton(
                          texto: "Disminuir",
                          icono: MaterialIcons.remove_circle,
                          fondoColor: ColorList.sys[1],
                          textoColor: ColorList.sys[0],
                          ltrbm: const [0, 0, 0, 0,],
                          textoSize: 14,
                          onPressed: _.crearAbono,
                          onLongPress: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: NestedScrollView(
                headerSliverBuilder: (context, isScrolled) {
                  return [const SmallHeader(height: 5,)];
                },
                body: CargoAbonoCustomscrollview(
                  scrollController: _.scrollController,
                  listaCargosAbonos: _.listaCargosAbonos,
                  enabledSlider: _.pendiente && _.esAdmin,
                  onLongPress: _.mostrarDetalleCargoAbono,
                  onBorrar: _.revertirCargoAbono,
                  onPdf: _.crearAbonoReportePdf,
                  esAdmin: _.esAdmin,
                ),
              ),
            ),
            Visibility(
              visible: _.pendiente,
              child: SolidButton(
                texto: "Marcar como pagada",
                icono: MaterialIcons.done_all,
                fondoColor: ColorList.sys[0],
                textoColor: ColorList.ui[0],
                ltrbm: const [0, 0, 0, 15,],
                onPressed: _.marcarCobranzaPagada,
                onLongPress: () {},
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _.crearEstadoCuentaPdf,
          shape: const CircleBorder(),
          backgroundColor: Color(ColorList.sys[2]),
          child: Icon(
            MaterialIcons.share,
            color: Color(ColorList.sys[0]).toMaterialColor(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      ),
    );
  }
}