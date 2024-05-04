import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../data/models/local_storage/usuarios.dart';
import '../../data/models/local_storage/zonas.dart';
import '../../data/models/local_storage/zonas_usuarios.dart';
import '../../utils/color_list.dart';
import '../buttons/circular_buttons.dart';
import '../buttons/solid_button.dart';
import '../combo/selection_combo.dart';
import '../containers/basic_bottom_sheet_container.dart';
import '../containers/card_container.dart';
import '../containers/titulo_container.dart';
import '../slidables/activo_inactivo_slidable.dart';
import '../texts/etiqueta_text.dart';

class UsuariosCustomscrollview extends StatelessWidget {
  final TextEditingController? zonasController;
  final ScrollController? scrollController;
  final List<Usuarios> usuarios;
  final List<Zonas> zonas;
  final List<ZonasUsuarios> zonasUsuarios;
  final List<BottomSheetAction> zonasLista;
  final IconData icono;
  final void Function() onTap;
  final void Function(dynamic) onLongPress;
  final void Function(Usuarios) actualizarPassword;
  final void Function(Usuarios, bool) modificarZona;
  final bool Function() verificarZonas;
  final void Function(Usuarios) cambiarEstatus;
  const UsuariosCustomscrollview({
    super.key,
    this.zonasController,
    this.scrollController,
    this.usuarios = const [],
    this.zonas = const [],
    this.zonasUsuarios = const [],
    this.zonasLista = const [],
    this.icono = MaterialIcons.person,
    required this.onTap,
    required this.onLongPress,
    required this.actualizarPassword,
    required this.modificarZona,
    required this.verificarZonas,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: usuario.activo!,
                            child: CircularButton(
                              colorIcono: ColorList.sys[0],
                              color: ColorList.sys[2],
                              icono: MaterialIcons.lock,
                              onPressed: () {
                                actualizarPassword(usuario);
                              },
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Visibility(
                            visible: (usuario.activo! && zona == "Sin Zona") || (!usuario.activo! && zona != "Sin Zona"),
                            child: CircularButton(
                              colorIcono: ColorList.sys[0],
                              color: ColorList.sys[zona == "Sin Zona" ? 1 : 2],
                              icono: zona == "Sin Zona" ? MaterialIcons.list_alt : Icons.playlist_remove,
                              onPressed: () {
                                if(zona == "Sin Zona") {
                                  if(!verificarZonas()) {
                                    return;
                                  }
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    expand: true,
                                    enableDrag: false,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => StatefulBuilder(builder: (context, setState) {
                                      return BasicBottomSheetContainer(
                                        context: context,
                                        cerrar: true,
                                        child: Column(
                                          children: [
                                            TituloContainer(
                                              texto: "Usuario: ${usuario.usuario!}",
                                              ltrbp: const [10, 0, 0, 0],
                                              size: 16,
                                            ),
                                            CardContainer(
                                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0,),
                                              children: [
                                                const SizedBox(height: 15,),
                                                const TituloContainer(
                                                  texto: "Zona *",
                                                  ltrbp: [10, 0, 0, 0],
                                                  size: 15,
                                                ),
                                                SelectionCombo(
                                                  titulo: "- Elige zona -",
                                                  controller: zonasController,
                                                  values: zonasLista,
                                                  icono: MaterialIcons.list_alt,
                                                  ltrb: const [0, 0, 0, 10,],
                                                  height: 70,
                                                  textAlignVertical: TextAlignVertical.bottom,
                                                ),
                                                const SizedBox(height: 15,),
                                              ],
                                            ),
                                            SolidButton(
                                              texto: "Asignar Zona",
                                              icono: MaterialIcons.save,
                                              fondoColor: ColorList.sys[2],
                                              textoColor: ColorList.sys[0],
                                              ltrbm: const [0, 0, 0, 0,],
                                              onPressed: () => modificarZona(usuario, true),
                                              onLongPress: () {},
                                            ),
                                          ],
                                        ),
                                      );
                                    },),
                                  );
                                } else {
                                  modificarZona(usuario, false);
                                }
                              },
                            ),
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