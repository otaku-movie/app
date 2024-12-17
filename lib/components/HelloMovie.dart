import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:otaku_movie/response/hello_movie.dart';

enum HelloMovieGuide {
  sub(1),
  audio(2);
  

   final int code;  // 定义一个字段来存储 code

  const HelloMovieGuide(this.code);  // 构造函数，赋值给 code
}

class HelloMovie extends StatelessWidget {
  final List<HelloMovieResponse>? guideData;
  final HelloMovieGuide type; // 新增的type属性，用于判断需要渲染哪个
  final double? width;

  const HelloMovie({super.key, required this.guideData, required this.type, this.width});

  @override
  Widget build(BuildContext context) {
    if (guideData == null) return Container();
    
    // 根据传入的type选择需要渲染的类型
    HelloMovieResponse helloMovieResponse =  guideData!.firstWhere(
      (guide) => guide.code == (type == HelloMovieGuide.sub ? 1 : 2),
      orElse: () => HelloMovieResponse(), 
    );

    // 根据type选择对应的图片路径
    String imagePath = '';
    // ignore: unrelated_type_equality_checks
    if (helloMovieResponse.code == HelloMovieGuide.audio.code) {
      imagePath = 'assets/image/audio-guide.png'; // 音频引导的图片路径
    }
    
    // ignore: unrelated_type_equality_checks
    if (helloMovieResponse.code == HelloMovieGuide.sub.code) {
      imagePath = 'assets/image/sub-guide.png'; // 音频引导的图片路径
    } 

    return ExtendedImage.asset(
      imagePath,
      width: width,  // 设置宽度为80
    );
  }
}
