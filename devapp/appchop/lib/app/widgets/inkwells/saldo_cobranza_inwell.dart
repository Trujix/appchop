import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/color_list.dart';
import '../containers/card_container.dart';

class SaldoCobranzaInkwell extends StatelessWidget {
  final void Function() onTap;
  final String saldoTotal; 
  final int opcionDeudaSeleccion;
  const SaldoCobranzaInkwell({
    super.key,
    required this.onTap,
    this.saldoTotal = "",
    this.opcionDeudaSeleccion = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: CardContainer(
              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2,),
              fondo: ColorList.sys[opcionDeudaSeleccion == 0 ? 1 : 2],
              columnAlign: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_circle_up,
                      color: Color(ColorList.sys[0]),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        saldoTotal,
                        style: TextStyle(
                          color: Color(ColorList.sys[0]),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            width: 80,
          ),
        ],
      ),
    );
  }
}