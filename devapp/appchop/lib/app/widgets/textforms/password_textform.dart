import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';

class PasswordTextform extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<double> ltrbp;
  final bool readOnly;
  final String text;
  final IconData icon;
  final Function()? obscureTextFunc;
  final bool obscureText;

  const PasswordTextform({
    super.key,
    this.controller,
    this.focusNode,
    this.ltrbp = const [10, 10, 10, 10,],
    this.readOnly = false,
    this.text = "",
    this.icon = Icons.lock,
    this.obscureTextFunc,
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
            color: Color(ColorList.sys[0]),
          ),
          hintText: text,
          suffixIcon: InkWell(
            onTap: obscureTextFunc,
            child: Icon(
              obscureText
                ? FontAwesome.eye
                : FontAwesome.eye_slash,
              color: Color(ColorList.sys[0]),
            ),
          ),
        ),
      ),
    );
  }
}