import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

import '../../utils/color_list.dart';

class DefaultSimplecalculator extends StatelessWidget {
  const DefaultSimplecalculator({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    double? cantidad = 0;
    return StatefulBuilder(
      builder: (context, setState) {
        return SimpleCalculator(
          value: cantidad!,
          autofocus: true,
          onChanged: (key, value, expression) {
            setState(() {
              cantidad = value ?? 0;
            });
          },
          onTappedDisplay: (value, details) { },
          theme: CalculatorThemeData(
            displayStyle: TextStyle(
              color: Color(ColorList.sys[0]),
              fontSize: 35,
            ),
            numStyle: TextStyle(
              color: Color(ColorList.sys[0]),
              fontSize: 26,
            ),
            commandStyle: TextStyle(
              color: Color(ColorList.sys[0]),
              fontSize: 26,
            ),
            operatorStyle: TextStyle(
              color: Color(ColorList.sys[0]),
              fontSize: 26,
            ),
            commandColor: Color(ColorList.sys[1]),
            operatorColor: Color(ColorList.sys[2]),
          ),
        );
      },
    );
  }
}