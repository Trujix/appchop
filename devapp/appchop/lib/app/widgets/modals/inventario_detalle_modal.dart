import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../data/models/local_storage/inventarios.dart';
import '../texts/etiqueta_jump_text.dart';

class InventarioDetalleModal extends StatelessWidget {
  final Inventarios inventarios;
  final ScrollController? scrollController;
  final double height;
  final int color;
  const InventarioDetalleModal({
    super.key,
    required this.inventarios,
    this.scrollController,
    this.height = 500,
    this.color = 0xFFEAECEE,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10,),
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          color: Color(color),
          border: Border.all(
            color: Color(color),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        height: height,
        child: ListView(
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
              texto1: "Marca:",
              texto2: inventarios.marca!,
              icono: MaterialCommunityIcons.tshirt_v,
            ),
            EtiquetaJumpText(
              texto1: "Talla:",
              texto2: inventarios.talla!,
              icono: MaterialCommunityIcons.size_xs,
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
        ),
      ),
    );
  }
}