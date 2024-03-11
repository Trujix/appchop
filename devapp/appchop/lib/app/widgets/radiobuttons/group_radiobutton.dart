import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';

import '../../utils/color_list.dart';

class GroupRadiobutton extends StatelessWidget {
  final List<String> buttonLables;
  final List<String> buttonValues;
  final String defaultSelected;
  final void Function(String) radioButtonValue;
  final List<double> ltrbp;
  
  const GroupRadiobutton({
    super.key,
    this.buttonLables = const [""],
    this.buttonValues = const [""],
    this.defaultSelected = "",
    required this.radioButtonValue,
    this.ltrbp = const [20, 10, 20, 10],
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
      child: CustomRadioButton(
        unSelectedBorderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        elevation: 0,
        radius: 0,
        shapeRadius: 0,
        width: (MediaQuery.of(context).size.width / 2) - 50,
        absoluteZeroSpacing: true,
        unSelectedColor: Theme.of(context).canvasColor,
        buttonLables: buttonLables,
        buttonValues: buttonValues,
        defaultSelected: defaultSelected,
        selectedColor: Color(ColorList.sys[1]),
        buttonTextStyle: const ButtonTextStyle(
          selectedColor: Colors.white,
          unSelectedColor: Colors.black,
          textStyle: TextStyle(fontSize: 16),
        ),
        radioButtonValue: radioButtonValue,
      ),
    );
  }
}