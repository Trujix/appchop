import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../data/models/busqueda_elementos.dart';
import '../../utils/color_list.dart';
import '../containers/dotborder_container.dart';
import '../texts/etiqueta_text.dart';

class BusquedaCustomscrollview extends StatelessWidget {
  final ScrollController? scrollController;
  final List<BusquedaElementos> elementos;
  final IconData icono;
  final void Function() onTap;
  final void Function(dynamic) onLongPress;
  const BusquedaCustomscrollview({
    super.key,
    this.scrollController,
    this.elementos = const [],
    this.icono = MaterialIcons.person,
    required this.onTap,
    required this.onLongPress,
  });
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: elementos.map((elemento) {
        final etiqueta = elemento.etiqueta.split("~");
        return SliverToBoxAdapter(
          child: InkWell(
            onTap: onTap,
            onLongPress: () => onLongPress(elemento.elemento),
            child: DotborderContainer(
              ltrbm: const [10, 0, 10, 0],
              bordeColor: ColorList.sys[0],
              children: <Widget>[
                Row(
                  children: [
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: etiqueta.map((tags) {
                          var tag = tags.split("Ø");
                          return EtiquetaText(
                            texto1: tag[0],
                            texto2: tag[1],
                            icono: MaterialIcons.search,
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10,),
                      child: Icon(
                        icono,
                        color: Color(ColorList.sys[0]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}