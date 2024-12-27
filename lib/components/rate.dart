import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as Math;

import 'package:otaku_movie/components/CustomNavigateTabBar.dart';
import 'package:otaku_movie/components/space.dart';

class Rate extends StatefulWidget {
  final double maxRating; // 最大评分
  final double starSize; // 星星大小
  final ValueChanged<double>? onRatingUpdate; // 改为可选参数
  final Color color;
  final Color borderColor;
  final Color fontColor;
  final double fontSize;
  final double point;
  final Widget? icon; // 添加自定义图标参数
  final int count; // 星星数量
  final Color filledColor; // 已填充的颜色
  final Color unfilledColor; // 未填充的颜色
  final bool readOnly; // 只读模式
  final double starSpacing = 0;

  const Rate({
    super.key,
    this.maxRating = 5.0,
    this.starSize = 40.0,
    this.color = Colors.amber,
    this.fontColor = Colors.orange,
    this.fontSize = 24.0,
    this.point = 0,
    this.count = 5, // 默认5颗星
    this.icon, // 添加图标参数
    this.filledColor = Colors.amber, // 默认填充颜色
    this.unfilledColor = const Color.fromARGB(224, 189, 187, 187), // 默认未填充颜色
    this.borderColor = Colors.transparent,
    this.readOnly = false, // 默认可以评分
    this.onRatingUpdate, // 移除 required
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
    _rating = widget.point;
  }

  void _updateRating(Offset localPosition, double totalWidth) {
    if (widget.readOnly) return;
    
    final starSpacing = 8.w; // 使用相同的间距值
    final starTotalWidth = widget.starSize + starSpacing; // 单个星星占用的总宽度(包含间距)
    
    // 计算触摸位置对应的星星索引
    int touchedStarIndex = (localPosition.dx / starTotalWidth).floor();
    
    // 确保索引在有效范围内
    touchedStarIndex = touchedStarIndex.clamp(0, widget.count - 1);
    
    // 计算在当前星星内的相对位置(0-1之间)
    final starLocalX = localPosition.dx - (touchedStarIndex * starTotalWidth);
    final percentInStar = (starLocalX / widget.starSize).clamp(0.0, 1.0);
    
    // 计算最终评分
    final starValue = widget.maxRating / widget.count;
    final newRating = (touchedStarIndex + percentInStar) * starValue;
    
    setState(() {
      _rating = double.parse(newRating.toStringAsFixed(1));
    });
    widget.onRatingUpdate?.call(_rating); // 使用可选调用
  }

  @override
  Widget build(BuildContext context) {
    // 减小间距
    final starSpacing = widget.starSpacing;
    final starWidth = widget.starSize * widget.count + (starSpacing * (widget.count - 1));

    return GestureDetector(
          onPanUpdate: (details) {
            RenderBox box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.globalPosition);
            _updateRating(localPosition, starWidth);
          },
          onTapDown: (details) {
            RenderBox box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.globalPosition);
            _updateRating(localPosition, starWidth);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.count, (index) {
              final starValue = widget.maxRating / widget.count;
              final fillPercent = _calculateStarFill(index + 1, starValue);
              if (widget.icon != null) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: GestureDetector(
                    onTap: widget.readOnly ? null : () {
                      setState(() {
                        _rating = (index + 1) * (widget.maxRating / widget.count);
                      });
                      widget.onRatingUpdate?.call(_rating);
                    },
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [fillPercent, fillPercent],
                          colors: [widget.filledColor, widget.unfilledColor],
                        ).createShader(bounds);
                      },
                      child: SizedBox(
                        width: widget.starSize,
                        height: widget.starSize,
                        child: widget.icon,
                      ),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(right: index < widget.count - 1 ? starSpacing : 0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque, // 增加这一行使触摸区域更精确
                    onTapDown: (details) {
                      if (!widget.readOnly) {
                        setState(() {
                          _rating = (index + 1) * starValue;
                        });
                        widget.onRatingUpdate?.call(_rating);
                      }
                    },
                    child: CustomPaint(
                      size: Size(widget.starSize, widget.starSize),
                      painter: _StarPainter(
                        borderColor: widget.borderColor,
                        backgroundColor: widget.unfilledColor,
                        color: widget.filledColor,
                        filledPercent: fillPercent,
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
        );
  }

  double _calculateStarFill(int starIndex, double starValue) {
    final starScore = starIndex * starValue; // 当前星星对应的分值
    if (_rating >= starScore) {
      return 1.0; // 完全填充
    } else if (_rating > (starIndex - 1) * starValue) {
      return (_rating - (starIndex - 1) * starValue) / starValue; // 部分填充
    }
    return 0.0; // 不填充
  }
}

class _StarPainter extends CustomPainter {
  final double filledPercent; // 填充比例 (0.0 ~ 1.0)
  final Color color;
  final Color borderColor;
  final Color backgroundColor;

  _StarPainter({required this.filledPercent, required this.borderColor, required this.color,required this.backgroundColor});

  // 增加自定义背景色
  @override
  void paint(Canvas canvas, Size size) {
    final starPath = _createStarPath(size);
    
    // 先画未填充的背景
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(starPath, bgPaint);

    // 再画填充部分
    if (filledPercent > 0.0) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final clipRect = Rect.fromLTRB(
        0,
        0,
        size.width * filledPercent,
        size.height,
      );
      canvas.save();
      canvas.clipRect(clipRect);
      canvas.drawPath(starPath, paint);
      canvas.restore();
    }
    
    // 画星星边框
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1; // 减小边框宽度
    canvas.drawPath(starPath, borderPaint);
  }

  Path _createStarPath(Size size) {
    final path = Path();
    final scale = size.width / 1024;
    
    // 使用antd的star图标路径
    path.moveTo(908.1 * scale, 353.1 * scale);
    path.lineTo(654.2 * scale, 316.2 * scale);
    path.lineTo(540.7 * scale, 86.1 * scale);
    path.cubicTo(
      537.6 * scale, 79.8 * scale,
      529.4 * scale, 74.7 * scale,
      526.2 * scale, 71.6 * scale
    );
    path.cubicTo(
      510.4 * scale, 63.8 * scale,
      491.2 * scale, 70.3 * scale,
      483.3 * scale, 86.1 * scale
    );
    path.lineTo(369.8 * scale, 316.2 * scale);
    path.lineTo(115.9 * scale, 353.1 * scale);
    path.cubicTo(
      108.9 * scale, 354.1 * scale,
      102.5 * scale, 357.4 * scale,
      97.6 * scale, 362.4 * scale
    );
    path.cubicTo(
      85.3 * scale, 375.1 * scale,
      85.5 * scale, 395.3 * scale,
      98.2 * scale, 407.7 * scale
    );
    path.lineTo(281.9 * scale, 586.8 * scale);
    path.lineTo(238.5 * scale, 839.7 * scale);
    path.cubicTo(
      237.3 * scale, 846.6 * scale,
      238.4 * scale, 853.8 * scale,
      241.7 * scale, 860.0 * scale
    );
    path.cubicTo(
      249.9 * scale, 875.6 * scale,
      269.3 * scale, 881.7 * scale,
      284.9 * scale, 873.4 * scale
    );
    path.lineTo(512 * scale, 754 * scale);
    path.lineTo(739.1 * scale, 873.4 * scale);
    path.cubicTo(
      745.3 * scale, 876.7 * scale,
      752.5 * scale, 877.8 * scale,
      759.4 * scale, 876.6 * scale
    );
    path.cubicTo(
      776.8 * scale, 873.6 * scale,
      788.5 * scale, 857.1 * scale,
      785.5 * scale, 839.7 * scale
    );
    path.lineTo(742.1 * scale, 586.8 * scale);
    path.lineTo(925.8 * scale, 407.7 * scale);
    path.cubicTo(
      930.8 * scale, 402.8 * scale,
      934.1 * scale, 396.4 * scale,
      935.1 * scale, 389.4 * scale
    );
    path.cubicTo(
      937.8 * scale, 371.9 * scale,
      925.6 * scale, 355.7 * scale,
      908.1 * scale, 353.1 * scale
    );
    path.close();
    
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
