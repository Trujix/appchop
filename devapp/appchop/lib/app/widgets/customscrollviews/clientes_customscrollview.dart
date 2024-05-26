import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../data/models/local_storage/clientes.dart';
import '../../utils/color_list.dart';
import '../containers/card_container.dart';

class ClientesCustomscrollview extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Clientes> listaClientes;
  final void Function(bool, String) onChanged;
  const ClientesCustomscrollview({
    super.key,
    this.scrollController,
    this.listaClientes = const [],
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: listaClientes.map((cliente) {
        return SliverToBoxAdapter(
          child: Builder(
            builder: (context) {
              return CardContainer(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10,),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              cliente.nombre!,
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(ColorList.sys[0]),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            AutoSizeText(
                              cliente.telefono!,
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(ColorList.sys[0]),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(0),
                        child: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            thumbColor: WidgetStateProperty.all(Color(ColorList.sys[0])),
                            activeTrackColor: Color(ColorList.sys[1]),
                            inactiveTrackColor: Color(ColorList.sys[2]),
                            value: cliente.activo!,
                            onChanged: (status) {
                              onChanged(status, cliente.idCliente!);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      }).toList(),
    );
  }
}