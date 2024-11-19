import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as Math;

import 'package:otaku_movie/components/CustomNavigateTabBar.dart';

class Rate extends StatefulWidget {
  final double initialRating; // 初始评分
  final double maxRating; // 最大评分
  final double starSize; // 星星大小
  final ValueChanged<double> onRatingUpdate; // 评分更新回调

  const Rate({
    super.key,
    this.initialRating = 0.0,
    this.maxRating = 5.0,
    this.starSize = 40.0,
    required this.onRatingUpdate,
  });

  @override
  _CustomPreciseRatingWidgetState createState() =>
      _CustomPreciseRatingWidgetState();
}

class _CustomPreciseRatingWidgetState extends State<Rate> {
  late double _rating; // 当前评分

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  void _updateRating(Offset localPosition, double totalWidth) {
    final newRating = (localPosition.dx / totalWidth * widget.maxRating)
        .clamp(0.0, widget.maxRating);
    setState(() {
      _rating = double.parse(newRating.toStringAsFixed(1)); // 保留 1 位小数
    });
    widget.onRatingUpdate(_rating);
  }

  @override
  Widget build(BuildContext context) {
    final starWidth = widget.starSize * widget.maxRating;

    return GestureDetector(
      onPanUpdate: (details) => _updateRating(details.localPosition, starWidth),
      onTapUp: (details) => _updateRating(details.localPosition, starWidth),
      child: Wrap(
        // mainAxisSize: MainAxisSize.min,s
        spacing: 10.w,
        children: List.generate(widget.maxRating.toInt(), (index) {
          return CustomPaint(
            size: Size(widget.starSize, widget.starSize),
            painter: _StarPainter(
              filledPercent: _calculateStarFill(index + 1),
            ),
          );
        }),
      ),
    );
  }

  double _calculateStarFill(int starIndex) {
    // 计算每颗星的填充比例
    if (_rating >= starIndex) {
      return 1.0; // 完全填充
    } else if (_rating > starIndex - 1) {
      return _rating - (starIndex - 1); // 部分填充
    } else {
      return 0.0; // 不填充
    }
  }
}

class _StarPainter extends CustomPainter {
  final double filledPercent; // 填充比例 (0.0 ~ 1.0)

  _StarPainter({required this.filledPercent});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final starPath = _createStarPath(size);
    if (filledPercent == 1.0) {
      // 整星填充
      canvas.drawPath(starPath, paint);
    } else if (filledPercent > 0.0) {
      // 部分填充
      final clipRect = Rect.fromLTRB(
        0,
        0,
        size.width * filledPercent,
        size.height,
      );
      canvas.save();
      canvas.clipRect(clipRect); // 按比例裁剪
      canvas.drawPath(starPath, paint);
      canvas.restore();
    }

    // 画星星边框
    final borderPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(starPath, borderPaint);
  }

 Path _createStarPath(Size size, {double spacing = 1.0}) {
  const int points = 5; // 星形顶点数
  final path = Path();
  final outerRadius = size.width / 2; // 外圆半径
  final innerRadius = outerRadius / (2.5 * spacing); // 内圆半径根据 spacing 调整
  final center = Offset(size.width / 2, size.height / 2); // 中心点
  const angle = 2 * 3.1415926 / points; // 每个顶点之间的角度
  const rotation = -3.1415926 / 2; // 初始角度偏移，确保星形顶点指向正上方

  for (int i = 0; i < points; i++) {
    // 计算外顶点坐标
    final x = center.dx + outerRadius * Math.cos(i * angle + rotation);
    final y = center.dy + outerRadius * Math.sin(i * angle + rotation);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
    // 计算内顶点坐标
    final nextX = center.dx + innerRadius * Math.cos((i + 0.5) * angle + rotation);
    final nextY = center.dy + innerRadius * Math.sin((i + 0.5) * angle + rotation);
    path.lineTo(nextX, nextY);
  }
  path.close();
  return path;
}



  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
