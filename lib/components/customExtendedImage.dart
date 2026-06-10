import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:otaku_movie/config/config.dart';

class CustomExtendedImage extends StatelessWidget {
  final String src;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const CustomExtendedImage(
    this.src, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.loadingWidget,
    this.errorWidget,
  });

  /// 统一的占位/失败底图：给一个比卡片/背景略深的灰底 + 居中图标，
  /// 避免图片缺失时只剩一个浅灰图标和背景糊在一起、看不清。
  Widget _buildPlaceholder(IconData icon) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFE8E8EC),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: const Color(0xFFB0B3BA),
        size: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (src.isEmpty) {
      return errorWidget ?? _buildPlaceholder(Icons.image_not_supported_outlined);
    }
    final String imageUrl = src.startsWith('http') ? src : '${Config.imageBaseUrl}$src';

    return ExtendedImage.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      cache: true,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return loadingWidget ?? _buildPlaceholder(Icons.image_outlined);
          case LoadState.failed:
            return errorWidget ?? _buildPlaceholder(Icons.broken_image_outlined);
          case LoadState.completed:
            return null; // 正常显示图片
        }
      },
    );
  }
}
