import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';
import '../buttons/solid_button.dart';
import '../containers/card_scrollable_container.dart';
import '../containers/titulo_container.dart';
import '../textforms/standard_textform.dart';

class InventarioFormColumn extends StatelessWidget {
  final TextEditingController? codigoArticulo;
  final FocusNode? codigoArticuloFocus;
  final TextEditingController? descripcion;
  final FocusNode? descripcionFocus;
  final TextEditingController? precioCompra;
  final FocusNode? precioCompraFocus;
  final TextEditingController? precioVenta;
  final FocusNode? precioVentaFocus;
  final TextEditingController? existencia;
  final FocusNode? existenciaFocus;
  final TextEditingController? maximo;
  final FocusNode? maximoFocus;
  final TextEditingController? minimo;
  final FocusNode? minimoFocus;
  final bool elementosImportados;
  final bool editandoElemento;
  final bool Function() validarForm;
  final void Function() agregarElementoInventario;
  final void Function() guardarElementoInventario;
  const InventarioFormColumn({
    super.key,
    this.codigoArticulo,
    this.codigoArticuloFocus,
    this.descripcion,
    this.descripcionFocus,
    this.precioCompra,
    this.precioCompraFocus,
    this.precioVenta,
    this.precioVentaFocus,
    this.existencia,
    this.existenciaFocus,
    this.maximo,
    this.maximoFocus,
    this.minimo,
    this.minimoFocus,
    this.elementosImportados = false,
    this.editandoElemento = false,
    required this.validarForm,
    required this.agregarElementoInventario,
    required this.guardarElementoInventario,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TituloContainer(
          texto: "(*) Los campos son obligatorios",
          ltrbp: [10, 0, 0, 0],
          size: 16,
        ),
        Expanded(
          child: CardScrollableContainer(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0,),
            children: [
              StandardTextform(
                controller: codigoArticulo,
                focusNode: codigoArticuloFocus,
                text: "Código artículo *",
                icon: MaterialIcons.qr_code,
                keyboardType: TextInputType.text,
                ltrbp: const [0, 10, 0, 10],
                maxLength: 15,
                enabled: !editandoElemento,
              ),
              StandardTextform(
                controller: descripcion,
                focusNode: descripcionFocus,
                text: "Descripción *",
                icon: MaterialIcons.inventory,
                keyboardType: TextInputType.text,
                ltrbp: const [0, 10, 0, 10],
                maxLength: 40,
              ),
              StandardTextform(
                controller: precioCompra,
                focusNode: precioCompraFocus,
                text: "Precio compra *",
                icon: MaterialIcons.money,
                keyboardType: TextInputType.number,
                ltrbp: const [0, 10, 0, 10],
              ),
              StandardTextform(
                controller: precioVenta,
                focusNode: precioVentaFocus,
                text: "Precio venta *",
                icon: MaterialIcons.attach_money,
                keyboardType: TextInputType.number,
                ltrbp: const [0, 10, 0, 10],
              ),
              StandardTextform(
                controller: existencia,
                focusNode: existenciaFocus,
                text: "Existencias *",
                icon: MaterialIcons.format_list_numbered,
                keyboardType: TextInputType.number,
                ltrbp: const [0, 10, 0, 10],
              ),
              StandardTextform(
                controller: maximo,
                focusNode: maximoFocus,
                text: "Máximo *",
                icon: MaterialIcons.add_circle,
                keyboardType: TextInputType.number,
                ltrbp: const [0, 10, 0, 10],
              ),
              StandardTextform(
                controller: minimo,
                focusNode: minimoFocus,
                text: "Mínimo *",
                icon: MaterialIcons.remove_circle,
                keyboardType: TextInputType.number,
                ltrbp: const [0, 10, 0, 10],
              ),
            ],
          ),
        ),
        SolidButton(
          texto: "${(elementosImportados ? "Agregar" : (editandoElemento ? "Editar" : "Guardar"))} artículo",
          icono: MaterialIcons.save,
          fondoColor: ColorList.sys[2],
          textoColor: ColorList.sys[0],
          ltrbm: const [0, 0, 0, 0,],
          onPressed: () {
            if (!validarForm()) {
              return;
            }
            if (elementosImportados) {
              agregarElementoInventario();
            } else {
              guardarElementoInventario();
            }
          },
          onLongPress: () {},
        ),
      ],
    );
  }
}