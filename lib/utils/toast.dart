import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { info, success, error, warning }

class ToastService {
  /// 默认显示时长（1.5 秒），相比系统 `Toast.LENGTH_SHORT`（≈ 2 秒）更轻量，
  /// 避免短促提示停留过久遮挡内容。
  static const Duration _defaultDuration = Duration(milliseconds: 1500);

  /// Android 上系统 `Toast.LENGTH_SHORT` 大致 2 秒，无法直接缩短，
  /// 我们用一个 Timer 在到时后主动 `Fluttertoast.cancel()` 来实现更短时长。
  static Timer? _autoDismissTimer;

  /// 显示 Toast 消息的通用方法。
  /// 通过 [duration] 可以自定义停留时长，默认 1.5 秒。
  static void showToast(
    String message, {
    ToastType type = ToastType.info,
    Duration duration = _defaultDuration,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case ToastType.success:
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      case ToastType.error:
        backgroundColor = const Color(0xffff4d4f);
        textColor = Colors.white;
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        break;
      case ToastType.info:
        backgroundColor = Colors.blue;
        textColor = Colors.white;
        break;
    }

    _autoDismissTimer?.cancel();
    Fluttertoast.cancel();

    // Android 端 LENGTH_SHORT ≈ 2s，LENGTH_LONG ≈ 3.5s；
    // 若调用方希望更短，则下面通过 Timer 主动 cancel 来兜底。
    final toastLength = duration.inMilliseconds >= 2500
        ? Toast.LENGTH_LONG
        : Toast.LENGTH_SHORT;

    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: (duration.inMilliseconds / 1000).ceil().clamp(1, 5),
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 26.sp,
      webPosition: "center",
    );

    if (duration.inMilliseconds < 1800) {
      _autoDismissTimer = Timer(duration, () {
        Fluttertoast.cancel();
      });
    }
  }

  static void showInfo(String message, {Duration? duration}) {
    showToast(message, type: ToastType.info, duration: duration ?? _defaultDuration);
  }

  static void showSuccess(String message, {Duration? duration}) {
    showToast(message, type: ToastType.success, duration: duration ?? _defaultDuration);
  }

  static void showError(String message, {Duration? duration}) {
    showToast(message, type: ToastType.error, duration: duration ?? _defaultDuration);
  }

  static void showWarning(String message, {Duration? duration}) {
    showToast(message, type: ToastType.warning, duration: duration ?? _defaultDuration);
  }
}
