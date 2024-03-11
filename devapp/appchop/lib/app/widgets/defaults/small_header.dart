import 'package:flutter/material.dart';

class SmallHeader extends StatelessWidget {
  final double height;
  const SmallHeader({
    super.key,
    this.height = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: height,),
    );
  }
}