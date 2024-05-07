import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../data/models/local_storage/cargos_abonos.dart';
import '../../utils/color_list.dart';
import '../../utils/literals.dart';
import '../containers/badge_container.dart';
import '../containers/card_container.dart';

class CargoAbonoInkwell extends StatelessWidget {
  final CargosAbonos cargoAbono;
  final void Function() onLongPress;
  const CargoAbonoInkwell({
    super.key,
    required this.cargoAbono,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        onLongPress();
      },
      child: CardContainer(
        margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        radius: 5,
        fondo: ColorList.ui[3],
        children: [
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              Text(
                cargoAbono.fechaRegistro!,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(ColorList.sys[0]),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(15, 2, 15, 2, ),
                  child: AutoSizeText(
                    cargoAbono.referencia!,
                    style: TextStyle(
                      color: Color(ColorList.sys[0]),
                    ),
                    minFontSize: 8,
                    maxLines: 2,
                  ),
                ),
              ),
              BadgeContainer(
                texto: MoneyFormatter(
                  amount: cargoAbono.monto!
                ).output.symbolOnLeft,
                textoColor: ColorList.sys[0],
                fondoColor: ColorList
                    .sys[cargoAbono.tipo == Literals.movimientoAbono ? 1 : 2],
              ),
            ],
          ),
          const SizedBox(
            height: 3,
          ),
        ],
      ),
    );
  }
}