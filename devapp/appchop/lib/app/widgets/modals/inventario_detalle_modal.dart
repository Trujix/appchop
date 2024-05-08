import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../data/models/local_storage/inventarios.dart';
import '../containers/card_container.dart';
import '../texts/etiqueta_jump_text.dart';

class InventarioDetalleModal extends StatelessWidget {
  final Inventarios inventarios;
  const InventarioDetalleModal({
    super.key,
    required this.inventarios,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.fromLTRB(20, 15, 10, 15,),
      children: [
        EtiquetaJumpText(
          texto1: "Codigo:",
          texto2: inventarios.codigoArticulo!,
          icono: MaterialIcons.qr_code,
        ),
        EtiquetaJumpText(
          texto1: "Artículo:",
          texto2: inventarios.descripcion!,
          icono: MaterialIcons.inventory,
        ),
        EtiquetaJumpText(
          texto1: "Precio compra:",
          texto2: MoneyFormatter(amount: inventarios.precioCompra!).output.symbolOnLeft,
          icono: MaterialIcons.money,
        ),
        EtiquetaJumpText(
          texto1: "Precio venta:",
          texto2: MoneyFormatter(amount: inventarios.precioVenta!).output.symbolOnLeft,
          icono: MaterialIcons.attach_money,
        ),
        EtiquetaJumpText(
          texto1: "Existencia:",
          texto2: inventarios.existencia!.toString(),
          icono: MaterialIcons.format_list_numbered,
        ),
        EtiquetaJumpText(
          texto1: "Máximo:",
          texto2: inventarios.maximo!.toString(),
          icono: MaterialIcons.add_circle,
        ),
        EtiquetaJumpText(
          texto1: "Mínimo:",
          texto2: inventarios.minimo!.toString(),
          icono: MaterialIcons.remove_circle,
        ),
        EtiquetaJumpText(
          texto1: "Fecha de actualización:",
          texto2: inventarios.fechaCambio!,
          icono: MaterialIcons.calendar_today,
        ),
      ],
    );
  }
}