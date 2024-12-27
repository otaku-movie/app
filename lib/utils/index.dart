import 'package:flutter/material.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

String formatNumberToTime(int totalMinutes) {
  int hours = totalMinutes ~/ 60;  // 计算小时数
  int minutes = totalMinutes % 60; // 计算剩余的分钟数
  
  // 格式化小时和分钟，确保它们是两位数
  String formattedHours = hours.toString().padLeft(2, '0');
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  
  return '$formattedHours:$formattedMinutes';
}

  // 邮箱格式验证
  bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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

  String getDay (String date, BuildContext context) {
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
  callTel (String tel) async {
    final Uri telUrl = Uri(scheme: 'tel', path: tel);
                                      
    if (await canLaunchUrl(telUrl)) {
      await launchUrl(telUrl);
    } else {
      // '无法打开拨号界面';
    }
  }
  callMap (double latitude, double longitude) async {    
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps?q=$latitude,$longitude');
    
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      // 无法打开应用
    }
  }
  launchURL (String url) async {
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
  