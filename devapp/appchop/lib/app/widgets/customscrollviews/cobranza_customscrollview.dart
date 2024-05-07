import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../data/models/local_storage/cobranzas.dart';
import '../../utils/color_list.dart';
import '../../utils/literals.dart';
import '../buttons/circular_buttons.dart';
import '../containers/dotborder_container.dart';
import '../slidables/borrar_slidable.dart';

class CobranzaCustomscrollview extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Cobranzas> listaCobranzas;
  final void Function() onTap;
  final void Function(Cobranzas) onLongPress;
  final void Function(Cobranzas) aregarNota;
  final void Function(Cobranzas) agregarCargoAbono;
  final void Function(Cobranzas) borrarCobranza;
  const CobranzaCustomscrollview({
    super.key,
    this.scrollController,
    this.listaCobranzas = const [],
    required this.onTap,
    required this.onLongPress,
    required this.aregarNota,
    required this.agregarCargoAbono,
    required this.borrarCobranza,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: listaCobranzas.map((cobranza) {
        return SliverToBoxAdapter(
          child: InkWell(
            onTap: onTap,
            onLongPress: () => onLongPress(cobranza),
            child: BorrarSlidable(
              enabled: cobranza.estatus! == Literals.statusCobranzaPagada,
              onBorrar: () => borrarCobranza(cobranza),
              child: DotborderContainer(
                fondo: ColorList.ui[3],
                bordeColor:
                    ColorList.sys[cobranza.tipoCobranza == Literals.tipoCobranzaMeDeben ? 1 : 2],
                ltrbm: const [10, 0, 10, 0],
                bordeGrosor: 2,
                padding: 10,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: AutoSizeText(
                                cobranza.nombre!,
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorList.sys[0]),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: AutoSizeText(
                                cobranza.descripcion!,
                                minFontSize: 5,
                                maxLines: 1,
                                style: TextStyle(
                                  color: Color(ColorList.sys[0]),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: AutoSizeText.rich(
                                TextSpan(
                                  text: "Fecha: ",
                                  style: TextStyle(
                                    color: Color(ColorList.sys[0]),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: cobranza.fechaRegistro!,
                                      style: TextStyle(
                                        color: Color(ColorList.sys[0]),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                minFontSize: 5,
                                maxLines: 1,
                              ),
                            ),
                            if (cobranza.fechaVencimiento !=
                                Literals.sinVencimiento)
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: "Vence: ",
                                    style: TextStyle(
                                      color: Color(ColorList.sys[0]),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: cobranza.fechaVencimiento!,
                                        style: TextStyle(
                                          color: Color(ColorList.sys[0]),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  minFontSize: 5,
                                  maxLines: 1,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                MoneyFormatter(
                                  amount: cobranza.saldo!,
                                ).output.symbolOnLeft,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(ColorList.sys[0]),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              CircularButton(
                                colorIcono: ColorList.sys[0],
                                color: ColorList.sys[
                                    cobranza.tipoCobranza == Literals.tipoCobranzaMeDeben ? 1 : 2],
                                icono: MaterialIcons.note_add,
                                onPressed: () {
                                  aregarNota(cobranza);
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CircularButton(
                                colorIcono: ColorList.sys[0],
                                color: ColorList.sys[
                                    cobranza.tipoCobranza == Literals.tipoCobranzaMeDeben ? 1 : 2],
                                icono: MaterialIcons.monetization_on,
                                onPressed: () {
                                  agregarCargoAbono(cobranza);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}