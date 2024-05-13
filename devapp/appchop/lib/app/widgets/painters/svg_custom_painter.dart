import 'package:flutter/material.dart';

class SvgCustomPainter extends CustomPainter {
  final Path path;
  final Color color;
  final double sizeOriginal;

  const SvgCustomPainter({
    required this.path,
    required this.color,
    required this.sizeOriginal,
  });

  @override
  bool shouldRepaint(SvgCustomPainter oldDelegate) =>
      oldDelegate.path != path || oldDelegate.color != color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _rescalar(path, size),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill
    );
  }

  Path _rescalar(Path path, Size size) {
    var matrix4 = Matrix4.identity();
    matrix4.scale(size.width / sizeOriginal, size.height / sizeOriginal);
    var pathNuevo = path.transform(matrix4.storage);
    return pathNuevo;
  }

  @override
  bool hitTest(Offset position) => path.contains(position);
}