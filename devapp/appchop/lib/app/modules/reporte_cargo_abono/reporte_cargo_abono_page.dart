import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:material_color_gen/material_color_gen.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../utils/color_list.dart';
import '../../utils/literals.dart';
import '../../widgets/appbars/back_appbar.dart';
import '../../widgets/columns/sin_elementos_column.dart';
import '../../widgets/combo/selection_combo.dart';
import '../../widgets/containers/badge_container.dart';
import '../../widgets/containers/card_container.dart';
import '../../widgets/containers/titulo_container.dart';
import '../../widgets/customscrollviews/cargo_abono_customscrollview.dart';
import '../../widgets/defaults/small_header.dart';
import '../../widgets/radiobuttons/group_radiobutton.dart';
import '../../widgets/textforms/date_textform.dart';
import 'reporte_cargo_abono_controller.dart';

class ReporteCargoAbonoPage extends StatelessWidget {
  const ReporteCargoAbonoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReporteCargoAbonoController>(
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
              texto: "Reporte Cargos - Abonos",
              ltrbp: [20, 0, 0, 0],
              size: 18,
            ),
            CardContainer(
              fondo: ColorList.ui[3],
              children: [
                GroupRadiobutton(
                  buttonLables: _.labelsTipo,
                  buttonValues: _.valuesTipo,
                  defaultSelected: _.tipoSelected,
                  radioButtonValue: _.tipoSeleccion,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DateTextform(
                        controller: _.fechaInicio,
                        focusNode: _.fechaInicioFocus,
                        dateSelected: _.dateSelected,
                        text: "Fecha Inicio",
                        canTap: false,
                        height: 63,
                      ),
                    ),
                    Expanded(
                      child: DateTextform(
                        controller: _.fechaFin,
                        focusNode: _.fechaFinFocus,
                        dateSelected: _.dateSelected,
                        text: "Fecha Fin",
                        canTap: false,
                        height: 63,
                      ),
                    ),
                  ],
                ),
                SelectionCombo(
                  titulo: "- Elige zona -",
                  controller: _.zona,
                  values: _.listaZona,
                  icono: MaterialIcons.list_alt,
                  height: 35,
                  ltrb: const [10, 0, 10, 0,],
                  textAlignVertical: TextAlignVertical.bottom,
                ),
              ],
            ),
            CardContainer(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              fondo: ColorList.ui[3],
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Total: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(ColorList.sys[0]),
                      ),
                    ),
                    BadgeContainer(
                      texto: MoneyFormatter(
                        amount: _.totalConsulta,
                      ).output.symbolOnLeft,
                      textoColor: ColorList.sys[0],
                      fondoColor: ColorList.sys[_.tipoSelected == Literals.movimientoAbono ? 1 : 2],
                    ),
                  ],
                ),
              ],
            ),
            Builder(
              builder: (context) {
                if(_.listaCargosAbonos.isNotEmpty) {
                  return Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, isScrolled) {
                        return [const SmallHeader(height: 5,)];
                      },
                      body: CargoAbonoCustomscrollview(
                        scrollController: _.scrollController,
                        listaCargosAbonos: _.listaCargosAbonos,
                        onPdf: (_) {},
                        onBorrar: (_) {},
                        onLongPress: (_) {},
                        enabledSlider: false,
                        esAdmin: _.esAdmin,
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: SinElementosColumn(
                      texto: "Su lista de ${_.tipoSelected.toLowerCase()}s está vacía",
                      imagenAsset: "cargo_abonos_reporte",
                      sizeAsset: 250,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _.exportar,
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
