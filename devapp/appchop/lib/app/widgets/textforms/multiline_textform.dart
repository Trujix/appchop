import 'package:flutter/material.dart';

import '../../utils/color_list.dart';

class MultilineTextform extends StatelessWidget {
  final ScrollController? scrollController;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int lines;
  final List<double> ltrbp;
  final int maxLength;
  final String text;
  final IconData icon;
  final bool upper;
  final bool enabled;
  final void Function(String?)? onChanged;

  const MultilineTextform({
    super.key,
    this.scrollController,
    this.controller,
    this.focusNode,
    this.lines = 4,
    this.ltrbp = const [10, 10, 10, 10],
    this.maxLength = 9999999,
    this.text = "",
    this.icon = Icons.keyboard,
    this.upper = false,
    this.enabled = true,
    this.onChanged,
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
        scrollController: scrollController,
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.multiline,
        maxLength: maxLength,
        minLines: lines,
        maxLines: lines,
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