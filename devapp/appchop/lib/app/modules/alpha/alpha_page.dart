import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';
import 'alpha_controller.dart';

class AlphaPage extends StatelessWidget with WidgetsBindingObserver {
  const AlphaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlphaController>(
      builder: (_) => Scaffold(
        backgroundColor: Color(ColorList.alpha[0]),
        body: Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/home/menu_logo.png",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}