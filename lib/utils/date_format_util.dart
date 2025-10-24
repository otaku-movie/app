import 'package:flutter/material.dart';

class DateFormatUtil {
  /// 格式化日期为年月日格式
  /// 输入格式: yyyy-MM-dd
  /// 输出格式:
  /// - 中文: 2024年12月25日
  /// - 日文: 2024年12月25日
  /// - 英文: Dec 25, 2024
  static String formatDate(String? dateString, BuildContext context) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }
    
    try {
      // 解析 yyyy-MM-dd 格式
      final parts = dateString.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        
        // 根据语言返回不同格式
        final languageCode = Localizations.localeOf(context).languageCode;
        
        if (languageCode == 'zh') {
          return '$year年$month月$day日';
        } else if (languageCode == 'ja') {
          return '$year年$month月$day日';
        } else {
          // 英文: Month Day, Year
          final months = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
          ];
          final monthIndex = int.parse(month) - 1;
          if (monthIndex >= 0 && monthIndex < 12) {
            return '${months[monthIndex]} $day, $year';
          }
        }
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  /// 格式化日期为年月格式
  /// 输入格式: yyyy-MM-dd
  /// 输出格式:
  /// - 中文: 2024年12月
  /// - 日文: 2024年12月
  /// - 英文: Dec 2024
  static String formatYearMonth(String? dateString, BuildContext context) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }
    
    try {
      // 解析 yyyy-MM-dd 格式
      final parts = dateString.split('-');
      if (parts.length >= 2) {
        final year = parts[0];
        final month = parts[1];
        
        // 根据语言返回不同格式
        final languageCode = Localizations.localeOf(context).languageCode;
        
        if (languageCode == 'zh') {
          return '$year年${month.padLeft(2, '0')}月';
        } else if (languageCode == 'ja') {
          return '$year年${month.padLeft(2, '0')}月';
        } else {
          // 英文: Month Year
          final months = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
          ];
          final monthIndex = int.parse(month) - 1;
          if (monthIndex >= 0 && monthIndex < 12) {
            return '${months[monthIndex]} $year';
          }
        }
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  /// 验证日期格式是否为 yyyy-MM-dd
  static bool isValidDate(String date) {
    RegExp regExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return regExp.hasMatch(date);
  }
}

