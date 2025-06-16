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

  @override
  Widget build(BuildContext context) {
    // 如果src是完整url，直接使用，否则拼接base url
    final String imageUrl = src.startsWith('http') ? src : '${Config.imageBaseUrl}$src';

    return ExtendedImage.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      cache: true, // 缓存图片，提升性能
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return loadingWidget ?? const Center(child: CircularProgressIndicator());
          case LoadState.failed:
            return errorWidget ?? const Icon(Icons.broken_image, color: Colors.grey);
          case LoadState.completed:
            return null; // 正常显示图片
        }
      },
    );
  }
}
