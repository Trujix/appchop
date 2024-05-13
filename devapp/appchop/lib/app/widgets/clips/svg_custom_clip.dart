import 'package:flutter/material.dart';

class SvgCustomClip extends CustomClipper<Path> {
  final Path path;
  const SvgCustomClip({
    required this.path,
  });

  @override
  Path getClip(Size size) {
    final Rect pathBounds = path.getBounds();
    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(size.width / pathBounds.width, size.height / pathBounds.height);
    return path.transform(matrix4.storage);
  }

  @override
  bool shouldReclip(SvgCustomClip oldClipper) => false;
}