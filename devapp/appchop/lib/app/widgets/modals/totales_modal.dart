import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../utils/color_list.dart';
import '../buttons/solid_button.dart';
import '../containers/badge_container.dart';
import '../containers/titulo_container.dart';

class TotalesModal extends StatelessWidget {
  final String estatus;
  final double saldoMeDeben;
  final double saldoDebo;
  final int totalMeDeben;
  final int totalDebo;
  final double saldoCargos;
  final double saldoAbonos;
  final int totalCargos;
  final int totalAbonos;
  final void Function() reporteador;
  const TotalesModal({
    super.key,
    this.estatus = "",
    this.saldoMeDeben = 0,
    this.saldoDebo = 0,
    this.totalMeDeben = 0,
    this.totalDebo = 0,
    this.saldoCargos = 0,
    this.saldoAbonos = 0,
    this.totalCargos = 0,
    this.totalAbonos = 0,
    required this.reporteador,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10,),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TituloContainer(
                texto: "Totales (${estatus.toLowerCase()})",
                ltrbp: const [0, 0, 0, 0],
                size: 15,
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Text(
                'Me deben ($totalMeDeben):',
                style: TextStyle(
                  color: Color(ColorList.sys[0]),
                  fontWeight: FontWeight.w700,
                ),
              ),
              BadgeContainer(
                texto: MoneyFormatter(
                  amount: saldoMeDeben,
                ).output.symbolOnLeft,
                fondoColor: ColorList.sys[1],
                textoColor: ColorList.sys[0],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Debo ($totalDebo):',
                style: TextStyle(
                  color: Color(ColorList.sys[0]),
                  fontWeight: FontWeight.w700,
                ),
              ),
              BadgeContainer(
                texto: MoneyFormatter(
                  amount: saldoDebo,
                ).output.symbolOnLeft,
                fondoColor: ColorList.sys[2],
                textoColor: ColorList.sys[0],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          const Divider(),
          const SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Text(
                'Abonos ($totalAbonos):',
                style: TextStyle(
                  color: Color(ColorList.sys[0]),
                  fontWeight: FontWeight.w700,
                ),
              ),
              BadgeContainer(
                texto: MoneyFormatter(
                  amount: saldoAbonos,
                ).output.symbolOnLeft,
                fondoColor: ColorList.sys[1],
                textoColor: ColorList.sys[0],
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                'Cargos ($totalCargos):',
                style: TextStyle(
                  color: Color(ColorList.sys[0]),
                  fontWeight: FontWeight.w700,
                ),
              ),
              BadgeContainer(
                texto: MoneyFormatter(
                  amount: saldoCargos,
                ).output.symbolOnLeft,
                fondoColor: ColorList.sys[2],
                textoColor: ColorList.sys[0],
              ),
            ],
          ),
          SolidButton(
            texto: "Reporte",
            icono: FontAwesome.file_excel_o,
            fondoColor: ColorList.sys[0],
            textoColor: ColorList.ui[0],
            ltrbm: const [0, 15, 0, 0,],
            ltrbp: const [15, 15, 15, 15,],
            textoSize: 14,
            onPressed: reporteador,
            onLongPress: () {},
            height: 60,
          ),
        ],
      ),
    );
  }
}