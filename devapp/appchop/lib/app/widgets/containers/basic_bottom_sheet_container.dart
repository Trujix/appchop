import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';

class BasicBottomSheetContainer extends StatelessWidget {
  final BuildContext? context;
  final ScrollController? scrollController;
  final Widget child;
  final bool cerrar;
  const BasicBottomSheetContainer({
    super.key,
    this.context,
    this.scrollController,
    required this.child,
    this.cerrar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
      decoration: BoxDecoration(
        color: Color(ColorList.ui[0]),
        border: Border.all(
          color: Color(ColorList.ui[0]),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20,),
                const Expanded(child: SizedBox()),
                Container(
                  width: 100,
                  height: 8,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration: BoxDecoration(
                    color: Color(ColorList.ui[1]),
                    border: Border.all(
                      color: Color(ColorList.ui[1]),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Visibility(
                  visible: cerrar,
                  child: GestureDetector(
                    child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(
                        MaterialIcons.close,
                        size: 19,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop(true);
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: child,
            )
          ],
        ),
      ),
    );
  }
}