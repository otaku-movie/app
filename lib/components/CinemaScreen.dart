import 'package:flutter/material.dart';

class CinemaScreen extends StatelessWidget {
  final double width;
  final double height;

  CinemaScreen({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(width, height), // 使用动态宽度和高度
        painter: CinemaScreenPainter(),
      ),
    );
  }
}

class CinemaScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300; // 屏幕的颜色
      // ..style = PaintingStyle.fill;

    // 定义屏幕的弧形路径
    final path = Path();
    path.moveTo(0, size.height); // 起点在左下角
    path.quadraticBezierTo(
        size.width / 2, size.height - 50, size.width, size.height); // 弧形到右下角
    path.lineTo(size.width, size.height); // 右下角的直线
    path.lineTo(0, size.height); // 左下角的直线
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
