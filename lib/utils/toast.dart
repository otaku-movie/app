import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { info, success, error, warning }

class ToastService {
  // 显示 Toast 消息的通用方法
  static void showToast(String message, {ToastType type = ToastType.info}) {
    Color backgroundColor;
    Color textColor;
    Icon icon;

    switch (type) {
      case ToastType.success:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        icon = const Icon(Icons.check_circle, color: Colors.white);
        break;
      case ToastType.error:
        backgroundColor = const Color(0xffff4d4f);
        textColor = Colors.white;
        icon = const Icon(Icons.error, color: Colors.white);
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        icon = const Icon(Icons.warning, color: Colors.white);
        break;
      case ToastType.info:
      default:
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        icon = const Icon(Icons.info, color: Colors.white);
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 26.sp,
      webPosition: "center",
    );
  }

  // 显示信息提示
  static void showInfo(String message) {
    showToast(message, type: ToastType.info);
  }

  // 显示成功提示
  static void showSuccess(String message) {
    showToast(message, type: ToastType.success);
  }

  // 显示错误提示
  static void showError(String message) {
    showToast(message, type: ToastType.error);
  }

  // 显示警告提示
  static void showWarning(String message) {
    showToast(message, type: ToastType.warning);
  }
}
