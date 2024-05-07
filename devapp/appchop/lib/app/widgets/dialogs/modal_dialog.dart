import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../utils/color_list.dart';

class ModalDialog extends StatelessWidget {
  final List<Widget> widgets;
  final double height;
  const ModalDialog({
    super.key,
    this.widgets = const [],
    this.height = 150,
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
                height: height,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 4, 10, 5),
                            child: Icon(
                              MaterialIcons.cancel,
                              color: Color(ColorList.theme[3]),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: widgets,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}