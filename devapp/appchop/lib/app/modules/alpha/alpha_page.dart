import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../utils/color_list.dart';
import 'alpha_controller.dart';

class AlphaPage extends StatelessWidget with WidgetsBindingObserver {
  const AlphaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlphaController>(
      builder: (_) => Scaffold(
        backgroundColor: Color(ColorList.alpha[0]),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(child: SizedBox()),
            Expanded(
              child: Center(
                child: Shimmer(
                  color: Color(ColorList.sys[0]),
                  colorOpacity: 1,
                  child: Image.asset(
                    "assets/home/menu_logo.png",
                  ),
                ),
              ),
            ),
            Expanded(
              child: SpinKitWave(
                color: Color(ColorList.sys[1]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}