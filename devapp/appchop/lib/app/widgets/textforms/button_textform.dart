import 'package:flutter/material.dart';

import '../../utils/color_list.dart';

class ButtonTextform extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<double> ltrbp;
  final bool readOnly;
  final String text;
  final IconData icon;
  final Function() onTap;
  final IconData icono;
  final bool obscureText;

  const ButtonTextform({
    super.key,
    this.controller,
    this.focusNode,
    this.ltrbp = const [10, 10, 10, 10,],
    this.readOnly = false,
    this.text = "",
    this.icon = Icons.person,
    required this.onTap,
    this.icono = Icons.add,
    this.obscureText = false,
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
        obscureText: obscureText,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: text,
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(
            icon,
            color: Color(ColorList.textforms[0]),
          ),
          hintText: text,
          suffixIcon: InkWell(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(
                right: 5,
              ),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(ColorList.sys[1]),
              ),
              child: Icon(
                icono,
                color: Color(ColorList.textforms[0]),
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}