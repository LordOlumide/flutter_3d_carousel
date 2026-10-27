// import 'package:flutter/material.dart';
//
// class ArrowPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final String axisLabel;
//
//   ArrowPainter({
//     this.color = Colors.black,
//     this.strokeWidth = 3,
//     required this.axisLabel,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke;
//
//     final start = Offset(0, size.height / 2);
//     final end = Offset(size.width, size.height / 2);
//
//     // Arrow shaft
//     canvas.drawLine(start, end, paint);
//
//     // Arrowhead
//     const headLength = 12.0;
//     const headAngle = 0.5; // radians
//
//     final path = Path()
//       ..moveTo(
//         end.dx - headLength * 0.8776,
//         end.dy - headLength * 0.4794,
//       )
//       ..lineTo(end.dx, end.dy)
//       ..lineTo(
//         end.dx - headLength * 0.8776,
//         end.dy + headLength * 0.4794,
//       );
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant ArrowPainter oldDelegate) {
//     return oldDelegate.color != color ||
//         oldDelegate.strokeWidth != strokeWidth ||
//         oldDelegate.axisLabel != axisLabel;
//   }
// }
