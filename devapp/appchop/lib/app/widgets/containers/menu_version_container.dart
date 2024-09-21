import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/color_list.dart';
import '../../utils/app_info.dart';

class MenuVersionContainer extends StatelessWidget {
  const MenuVersionContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
        left: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AutoSizeText(
            "Version: ${AppInfo.version}",
            style: TextStyle(
              color: Color(ColorList.sys[1]),
              fontWeight: FontWeight.w500,
            ),
            minFontSize: 8,
            maxFontSize: 16,
          ),
        ],
      ),
    );
  }
}