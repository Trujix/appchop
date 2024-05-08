import 'package:flutter/material.dart';

import '../../utils/color_list.dart';

class StandardTextform extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<double> ltrbp;
  final TextInputType keyboardType;
  final int maxLength;
  final String text;
  final IconData icon;
  final bool upper;
  final bool enabled;
  final TextAlign textAlign;
  final void Function(String?)? onChanged;

  const StandardTextform({
    super.key,
    this.controller,
    this.focusNode,
    this.ltrbp = const [10, 10, 10, 10],
    this.keyboardType = TextInputType.text,
    this.maxLength = 9999999,
    this.text = "",
    this.icon = Icons.keyboard,
    this.upper = false,
    this.enabled = true,
    this.onChanged,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ltrbp[0],
        ltrbp[1],
        ltrbp[2],
        ltrbp[3],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLength: maxLength,
        textAlign: textAlign,
        decoration: InputDecoration(
          counterText: "",
          labelText: text,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            icon,
            color: Color(ColorList.sys[0]),
          ),
          hintText: text,
        ),
        textCapitalization: upper 
          ? TextCapitalization.characters 
          : TextCapitalization.none,
        enabled: enabled,
        onChanged: (value) {
          if(upper) {
            controller!.text = value.toUpperCase();
            controller!.selection = TextSelection.fromPosition(
              TextPosition(offset: controller!.text.length),
            );
          }
          try {
            onChanged!(value);
          } finally { }
        },
      ),
    );
  }
}