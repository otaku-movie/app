import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

String formatNumberToTime(int totalMinutes) {
  int hours = totalMinutes ~/ 60; // 计算小时数
  int minutes = totalMinutes % 60; // 计算剩余的分钟数

  // 格式化小时和分钟，确保它们是两位数
  String formattedHours = hours.toString().padLeft(2, '0');
  String formattedMinutes = minutes.toString().padLeft(2, '0');

  return '$formattedHours:$formattedMinutes';
}

// 邮箱格式验证
bool isValidEmail(String email) {
  RegExp emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegExp.hasMatch(email);
}

// 密码格式验证
bool isValidPassword(String password) {
  RegExp passwordRegExp = RegExp(r'^[a-zA-Z0-9_]{6,16}$');
  // 密码长度6-16位，且包含数字、字母和下划线
  // RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*_).{6,16}$');

  return passwordRegExp.hasMatch(password);
}

bool isSixDigitNumber(String input) {
  final regex = RegExp(r'^\d{6}$');
  return regex.hasMatch(input);
}

String getDay(String date, BuildContext context) {
  if (date.isEmpty) return '';

  List<String> weekList = [
    S.of(context).common_week_monday,
    S.of(context).common_week_tuesday,
    S.of(context).common_week_wednesday,
    S.of(context).common_week_thursday,
    S.of(context).common_week_friday,
    S.of(context).common_week_saturday,
    S.of(context).common_week_sunday,
  ];

  DateTime datetime = DateTime.parse(date);

  return weekList[datetime.weekday - 1];
}

callTel(String tel) async {
  final Uri telUrl = Uri(scheme: 'tel', path: tel);

  if (await canLaunchUrl(telUrl)) {
    await launchUrl(telUrl);
  } else {
    // '无法打开拨号界面';
  }
}

callMap(double latitude, double longitude) async {
  final Uri googleMapsUrl =
      Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');

  if (await canLaunchUrl(googleMapsUrl)) {
    await launchUrl(googleMapsUrl);
  } else {
    // 无法打开应用
  }
}

launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication, // 打开外部浏览器
    );
  } else {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('无法打开链接: $url')),
    // );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // 点击外部不会关闭弹窗
    builder: (BuildContext context) {
      return const Dialog(
        backgroundColor: Colors.transparent, // 透明背景
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ), // 显示加载动画
        ),
      );
    },
  );
}

// 关闭加载弹窗
void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop(); // 关闭弹窗
}

String formatTime(
    {String parser = 'yyyy-MM-dd HH:mm:ss',
    required String format,
    String? timeString}) {
  if (timeString != null && timeString.isNotEmpty) {
    try {
      // 解析并格式化时间
      return DateFormat(format).format(DateFormat(parser).parse(timeString));
    } catch (e) {
      // 如果解析失败，返回原始字符串
      return timeString;
    }
  }
  return ''; // 如果时间为空，返回空字符串
}

EnvironmentType getEnvironment() {
  const env = String.fromEnvironment('ENV', defaultValue: 'prod');

  switch (env) {
    case 'dev':
      return EnvironmentType.dev;
    case 'test':
      return EnvironmentType.test;
    case 'preprod':
      return EnvironmentType.preprod;
    case 'prod':
    default:
      return EnvironmentType.prod;
  }
}

/// 解析CSS颜色字符串为Flutter Color对象
/// 支持多种格式：十六进制、RGB、RGBA、HSL、HSLA、命名颜色
Color parseColor(String? colorString) {
  if (colorString == null || colorString.isEmpty) {
    return Colors.grey; // 默认颜色
  }
  
  // 移除可能的空格
  colorString = colorString.trim();
  
  // 处理命名颜色（常见颜色名称）- 优先处理
  switch (colorString.toLowerCase()) {
    case 'red': return Colors.red;
    case 'green': return Colors.green;
    case 'blue': return Colors.blue;
    case 'yellow': return Colors.yellow;
    case 'orange': return Colors.orange;
    case 'purple': return Colors.purple;
    case 'pink': return Colors.pink;
    case 'brown': return Colors.brown;
    case 'grey': case 'gray': return Colors.grey;
    case 'black': return Colors.black;
    case 'white': return Colors.white;
    case 'transparent': return Colors.transparent;
  }
  
  // 处理十六进制颜色 (#FF0000, #ff0000, FF0000)
  if (colorString.startsWith('#')) {
    colorString = colorString.substring(1);
  }
  
  // 验证是否为有效的十六进制字符串
  bool isValidHex(String str) {
    return RegExp(r'^[0-9A-Fa-f]+$').hasMatch(str);
  }
  
  if (colorString.length == 6 && isValidHex(colorString)) {
    // 6位十六进制
    try {
      return Color(int.parse('FF$colorString', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  } else if (colorString.length == 3 && isValidHex(colorString)) {
    // 3位十六进制，扩展为6位
    try {
      String expanded = '';
      for (int i = 0; i < 3; i++) {
        expanded += colorString[i] + colorString[i];
      }
      return Color(int.parse('FF$expanded', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  } else if (colorString.length == 8 && isValidHex(colorString)) {
    // 8位十六进制，包含透明度
    try {
      return Color(int.parse(colorString, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
  
  // 处理rgb/rgba格式
  if (colorString.startsWith('rgb')) {
    RegExp rgbRegex = RegExp(r'rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)');
    Match? match = rgbRegex.firstMatch(colorString);
    if (match != null) {
      int r = int.parse(match.group(1)!);
      int g = int.parse(match.group(2)!);
      int b = int.parse(match.group(3)!);
      double a = match.group(4) != null ? double.parse(match.group(4)!) : 1.0;
      return Color.fromRGBO(r, g, b, a);
    }
  }
  
  // 处理hsl格式
  if (colorString.startsWith('hsl')) {
    RegExp hslRegex = RegExp(r'hsla?\((\d+),\s*(\d+)%,\s*(\d+)%(?:,\s*([\d.]+))?\)');
    Match? match = hslRegex.firstMatch(colorString);
    if (match != null) {
      int h = int.parse(match.group(1)!);
      int s = int.parse(match.group(2)!);
      int l = int.parse(match.group(3)!);
      double a = match.group(4) != null ? double.parse(match.group(4)!) : 1.0;
      
      // 将HSL转换为RGB
      double c = (1 - (2 * l / 100 - 1).abs()) * s / 100;
      double x = c * (1 - ((h / 60) % 2 - 1).abs());
      double m = l / 100 - c / 2;
      
      double r, g, b;
      if (h < 60) {
        r = c; g = x; b = 0;
      } else if (h < 120) {
        r = x; g = c; b = 0;
      } else if (h < 180) {
        r = 0; g = c; b = x;
      } else if (h < 240) {
        r = 0; g = x; b = c;
      } else if (h < 300) {
        r = x; g = 0; b = c;
      } else {
        r = c; g = 0; b = x;
      }
      
      return Color.fromRGBO(
        ((r + m) * 255).round(),
        ((g + m) * 255).round(),
        ((b + m) * 255).round(),
        a,
      );
    }
  }
  
  // 如果无法解析，返回默认颜色
  return Colors.grey;
}