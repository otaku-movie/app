import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

// 全局图片前缀
String globalPrefix = "";

class CustomExtendedImage extends StatelessWidget {
  final String src;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Widget? loadingWidget;
  final Widget? errorWidget;


  const CustomExtendedImage(this.src, {
    super.key, 
    this.fit,
    this.width,
    this.height,
    this.loadingWidget,
    this.errorWidget
  });

  @override
  Widget build(BuildContext context) {
    // 组合图片的完整 URL
    String imageUrl = globalPrefix + src;

    return ExtendedImage.network(
      imageUrl,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.failed) {
          // 自定义错误处理
          return errorWidget ?? const  Icon(Icons.broken_image, color: Colors.grey); // 默认错误图标
        }
        if (state.extendedImageLoadState == LoadState.loading) {
          // 自定义加载状态
          return loadingWidget ?? const Center(child: CircularProgressIndicator());
        }
        return null; // 加载成功时显示图片
      }
    );
  }
}
