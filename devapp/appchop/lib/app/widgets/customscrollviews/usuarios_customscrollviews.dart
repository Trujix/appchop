import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../data/models/local_storage/usuarios.dart';
import '../../data/models/local_storage/zonas.dart';
import '../../data/models/local_storage/zonas_usuarios.dart';
import '../containers/card_container.dart';
import '../slidables/borrar_slidable.dart';
import '../texts/etiqueta_text.dart';

class UsuariosCustomscrollview extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Usuarios> usuarios;
  final List<Zonas> zonas;
  final List<ZonasUsuarios> zonasUsuarios;
  final IconData icono;
  final void Function() onTap;
  final void Function(dynamic) onLongPress;
  const UsuariosCustomscrollview({
    super.key,
    this.scrollController,
    this.usuarios = const [],
    this.zonas = const [],
    this.zonasUsuarios = const [],
    this.icono = MaterialIcons.person,
    required this.onTap,
    required this.onLongPress,
  });
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: usuarios.map((usuario) {
        String zona = "Sin Zona";
        var idZona = zonasUsuarios.where((uz) => uz.usuario == usuario.usuario!).firstOrNull;
        if(idZona != null) {
          var zonaVerif = zonas.where((z) => z.valueZona == idZona.idZona).firstOrNull;
          if(zonaVerif != null) {
            zona = zonaVerif.labelZona!;
          }
        }
        return SliverToBoxAdapter(
          child: InkWell(
            onTap: onTap,
            onLongPress: () {},
            child: BorrarSlidable(
              onBorrar: () {},
              enabled: false,
              child: CardContainer(
                fondo: 0xFFFDFEFE,
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            EtiquetaText(
                              texto1: "USUARIO: ",
                              texto2: usuario.usuario!,
                            ),
                            const SizedBox(height: 10,),
                            EtiquetaText(
                              texto1: "ZONA: ",
                              texto2: zona,
                              icono: MaterialIcons.list_alt,
                            ),
                          ],
                        ),
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