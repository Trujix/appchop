import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:money_formatter/money_formatter.dart';

import '../../data/models/local_storage/inventarios.dart';
import '../../utils/color_list.dart';
import '../buttons/circular_buttons.dart';
import '../containers/card_container.dart';
import '../slidables/editar_borrar_slidable.dart';

class InventarioCustomscrollview extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Inventarios> listaInventarios;
  final void Function(Inventarios) onBorrar;
  final void Function(Inventarios) onEditar;
  const InventarioCustomscrollview({
    super.key,
    this.scrollController,
    this.listaInventarios = const [],
    required this.onBorrar,
    required this.onEditar,
  });
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: listaInventarios.map((inventario) {
        return SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              return EditarBorrarSlidable(
                onEditar: () => onEditar(inventario),
                onBorrar: () => onBorrar(inventario),
                child: InkWell(
                  onLongPress: () {},
                  child: CardContainer(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.fromLTRB(10, 2, 10, 2,),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  inventario.codigoArticulo!,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Color(ColorList.sys[0]),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                AutoSizeText(
                                  inventario.descripcion!,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Color(ColorList.sys[0]),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: inventario.existencia! <= inventario.minimo!,
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 10),
                                        child: Icon(
                                          MaterialIcons.warning,
                                          size: 14,
                                          color: Color(ColorList.sys[2]),
                                        ),
                                      ),
                                    ),
                                    AutoSizeText(
                                      "Existencia: ${inventario.existencia!.toInt()}",
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Color(ColorList.sys[0]),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              AutoSizeText(
                                MoneyFormatter(amount: inventario.precioVenta!).output.symbolOnLeft,
                                style: TextStyle(
                                  color: Color(ColorList.sys[0]),
                                ),
                              ),
                              CircularButton(
                                colorIcono: ColorList.sys[0],
                                color: ColorList.sys[1],
                                icono: MaterialIcons.exposure,
                                onPressed: () {
                                  
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}