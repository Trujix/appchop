import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../data/models/local_storage/cargos_abonos.dart';
import '../../utils/literals.dart';
import '../inkwells/cargo_abono_inkwell.dart';
import '../slidables/borrar_pdf_slidable.dart';
import '../slidables/borrar_slidable.dart';

class CargoAbonoCustomscrollview extends StatelessWidget {
  final ScrollController? scrollController;
  final List<CargosAbonos> listaCargosAbonos;
  final void Function(CargosAbonos) onLongPress;
  final void Function(CargosAbonos) onBorrar;
  final void Function(CargosAbonos) onPdf;
  final bool enabledSlider;
  const CargoAbonoCustomscrollview({
    super.key,
    this.scrollController,
    this.listaCargosAbonos = const [],
    required this.onLongPress,
    required this.onBorrar,
    required this.onPdf,
    this.enabledSlider = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: listaCargosAbonos.map((cargoAbono) {
        final index = listaCargosAbonos.indexOf(cargoAbono);
        return SliverToBoxAdapter(
          /*child: Builder(
            builder: (context) {
              if(index == 0) {
                return CargoAbonoInkwell(
                  cargoAbono: cargoAbono,
                  onLongPress: () => onLongPress(cargoAbono),
                );
              } else if(cargoAbono.tipo == Literals.movimientoAbono) {
                return BorrarPdfSlidable(
                  onBorrar: () => onBorrar(cargoAbono),
                  onPdf: () => onPdf(cargoAbono),
                  enabled: enabledSlider,
                  child: CargoAbonoInkwell(
                    cargoAbono: cargoAbono,
                    onLongPress: () => onLongPress(cargoAbono),
                  ),
                );
              } else {
                return BorrarSlidable(
                  onBorrar: () => onBorrar(cargoAbono),
                  enabled: enabledSlider,
                  child: CargoAbonoInkwell(
                    cargoAbono: cargoAbono,
                    onLongPress: () => onLongPress(cargoAbono),
                  ),
                );
              }
            },
          ),*/
          child: Container(
            padding: const EdgeInsets.all(15,),
            child: Text(
              MoneyFormatter(
                amount: cargoAbono.monto!,
              ).output.symbolOnLeft,
            ),
          ),
        );
      }).toList(),
    );
  }
}