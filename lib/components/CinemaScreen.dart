import 'package:flutter/material.dart';

class CinemaScreen extends StatelessWidget {
  final double width;
  final double height;
  final String hallName;

  CinemaScreen({required this.width, required this.height, required this.hallName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(width, height),
        painter: CinemaScreenPainter(seatWidth: width, hallName: hallName),
      ),
    );
  }
}

class CinemaScreenPainter extends CustomPainter {
  final double seatWidth;
  final String hallName;

  CinemaScreenPainter({required this.seatWidth, required this.hallName});

  @override
  void paint(Canvas canvas, Size size) {
    // Fill and border paints
    final fillPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 屏幕宽度 = 座位宽度，居中绘制
    final double screenWidth = seatWidth;
    final double startX = (size.width - screenWidth) / 2.0;
    final double endX = startX + screenWidth;
    final double topY = size.height * 0.25;
    final double bottomY = size.height * 0.75;
    final double ctrlTopY = size.height * 0.10;
    final double ctrlBottomY = size.height * 0.90;

    // 弧形屏幕路径
    final Path path = Path()
      ..moveTo(startX, topY)
      ..quadraticBezierTo(
        (startX + endX) / 4.0, ctrlTopY, endX, topY,
      )
      ..lineTo(endX, bottomY)
      ..quadraticBezierTo(
        (startX + endX) / 4.0, ctrlBottomY, startX, bottomY,
      )
      ..close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);

    // 影厅名称标签
    if (hallName.isNotEmpty) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: hallName,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        ellipsis: '…',
      )..layout(maxWidth: screenWidth - 8);

      final double textX = startX + (screenWidth - textPainter.width) / 2.0;
      final double textY = (topY + bottomY) / 2.0 - textPainter.height / 2.0;
      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
