import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../../utils/color_list.dart';
import 'card_container.dart';

class SinNotasContainer extends StatelessWidget {
  const SinNotasContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      fondo: ColorList.ui[3],
      padding: const EdgeInsets.all(5),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MaterialIcons.description,
              color: Color(ColorList.sys[0]),
              size: 16,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Sin notas que mostrar",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(ColorList.sys[0]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}