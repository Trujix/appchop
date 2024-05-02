import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../data/models/local_storage/usuarios.dart';
import '../../data/models/local_storage/zonas.dart';
import '../../data/models/local_storage/zonas_usuarios.dart';
import '../../utils/color_list.dart';
import '../buttons/circular_buttons.dart';
import '../containers/card_container.dart';
import '../slidables/activo_inactivo_slidable.dart';
import '../texts/etiqueta_text.dart';

class UsuariosCustomscrollview extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Usuarios> usuarios;
  final List<Zonas> zonas;
  final List<ZonasUsuarios> zonasUsuarios;
  final IconData icono;
  final void Function() onTap;
  final void Function(dynamic) onLongPress;
  final void Function(Usuarios) actualizarPassword;
  final void Function(Usuarios) cambiarEstatus;
  const UsuariosCustomscrollview({
    super.key,
    this.scrollController,
    this.usuarios = const [],
    this.zonas = const [],
    this.zonasUsuarios = const [],
    this.icono = MaterialIcons.person,
    required this.onTap,
    required this.onLongPress,
    required this.actualizarPassword,
    required this.cambiarEstatus,
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
            child: ActivoInactivoSlidable(
              cambiar: () {
                cambiarEstatus(usuario);
              },
              enabled: true,
              activo: usuario.activo!,
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
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Icon(
                                  usuario.activo! ? MaterialIcons.check_circle : MaterialIcons.cancel,
                                  color: Color(ColorList.theme[usuario.activo! ? 1 : 3]),
                                ),
                                const SizedBox(width: 5,),
                                Text(
                                  usuario.activo! ? "ACTIVO" : "INACTIVO",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(ColorList.sys[0]),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: usuario.activo!,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                CircularButton(
                                  colorIcono: ColorList.sys[0],
                                  color: ColorList.sys[2],
                                  icono: MaterialIcons.lock,
                                  onPressed: () {
                                    actualizarPassword(usuario);
                                  },
                                ),
                              ],
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