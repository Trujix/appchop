import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 10.milliseconds,
      curve: Curves.fastLinearToSlowEaseIn,
       child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                height: 120,
                decoration: BoxDecoration(
                  color: Color(ColorList.ui[0]),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(ColorList.ui[2]),
                      blurRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SpinKitWave(
                        color: Color(0xFF627486),
                        size: 35,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Porfavor espere...',
                        style: TextStyle(
                          color: Color(0xFF3F5264),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
       ),
    );
  }
}