import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';

import '../../utils/color_list.dart';

class DateTextform extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function() dateSelected;
  final List<double> ltrbp;
  final bool readOnly;
  final bool clean;
  final String text;
  final IconData icon;
  final bool canTap;
  final double? height;

  const DateTextform({
    super.key,
    this.controller,
    this.focusNode,
    this.ltrbp = const [10, 10, 10, 10,],
    this.readOnly = true,
    this.clean = false,
    this.text = "Fecha",
    this.icon = Icons.lock,
    required this.dateSelected,
    this.canTap = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.fromLTRB(
        ltrbp[0],
        ltrbp[1],
        ltrbp[2],
        ltrbp[3],
      ),
      child: TextFormField(
        onTap: () {
          if(clean) {
            controller!.text = "";
          }
          if(canTap) {
            return;
          }
          showDatePicker(
            cancelText: "Cancelar",
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            context: context,
            firstDate: DateTime(2024),
            lastDate: DateTime(2050),
            locale: const Locale('es'),
          ).then((selectedDate) {
            controller!.text = DateFormat("dd-MM-yyyy").format(selectedDate!).toString();
            dateSelected();
          });
        },
        controller: controller,
        focusNode: focusNode,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: text,
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            MaterialIcons.calendar_today,
            color: Color(ColorList.sys[0]),
          ),
          hintText: text,
        ),
      ),
    );
  }
}