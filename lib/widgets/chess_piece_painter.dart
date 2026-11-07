import 'package:flutter/material.dart';

class ChessPiecePainter extends CustomPainter {
  final String piece; // e.g. 'P', 'R', 'N', 'B', 'Q', 'K' for white, lowercase for black

  ChessPiecePainter(this.piece);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = piece == piece.toUpperCase() ? const Color(0xFFFFD166) : const Color(0xFF263238)
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    double radius = size.width * 0.35;

    // Simple custom drawing representations for chess pieces
    switch (piece.toUpperCase()) {
      case 'P':
        canvas.drawCircle(Offset(center.dx, center.dy + size.height * 0.1), radius * 0.6, paint);
        canvas.drawCircle(Offset(center.dx, center.dy - size.height * 0.2), radius * 0.4, paint);
        break;
      case 'R':
        canvas.drawRect(Rect.fromCenter(center: center, width: size.width * 0.5, height: size.height * 0.6), paint);
        break;
      case 'N':
        canvas.drawOval(Rect.fromCenter(center: center, width: size.width * 0.5, height: size.height * 0.7), paint);
        break;
      case 'B':
        canvas.drawCircle(center, radius * 0.8, paint);
        break;
      case 'Q':
        canvas.drawCircle(center, radius, paint);
        canvas.drawPoints(PointMode.polygon, [
          Offset(center.dx - radius, center.dy - radius),
          center,
          Offset(center.dx + radius, center.dy - radius)
        ], strokePaint);
        break;
      case 'K':
        canvas.drawRect(Rect.fromCenter(center: center, width: size.width * 0.60, height: size.height * 0.80), paint);
        // Draw cross for king
        canvas.drawRect(Rect.fromCenter(center: Offset(center.dx, center.dy - size.height * 0.4), width: 4, height: 12), paint..color = Colors.white);
        canvas.drawRect(Rect.fromCenter(center: Offset(center.dx, center.dy - size.height * 0.4), width: 12, height: 4), paint);
        break;
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}