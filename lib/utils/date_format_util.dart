import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:otaku_movie/generated/l10n.dart';

class DateFormatUtil {
  // 私有常量 - 避免重复定义
  static const List<String> _monthsEn = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  
  static const List<String> _weekdaysZh = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  static const List<String> _weekdaysEn = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  /// 获取当前语言代码
  static String _getLanguageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  /// 获取英文月份名称
  static String _getMonthName(int month) {
    if (month >= 1 && month <= 12) {
      return _monthsEn[month - 1];
    }
    return '';
  }

  /// 获取星期名称（支持中日英国际化）
  static String getWeekday(DateTime date, BuildContext context) {
    final languageCode = _getLanguageCode(context);
    final weekdayIndex = date.weekday - 1;
    
    switch (languageCode) {
      case 'zh':
      case 'zh_CN':
      case 'zh_TW':
      case 'zh_HK':
      case 'ja':
      case 'ja_JP':
        return _weekdaysZh[weekdayIndex];
      default:
        return _weekdaysEn[weekdayIndex];
    }
  }

  /// 获取星期名称（使用国际化文件）
  static String getWeekdayI18n(DateTime date, BuildContext context) {
    final s = S.of(context);
    switch (date.weekday) {
      case 1: return s.common_week_monday;
      case 2: return s.common_week_tuesday;
      case 3: return s.common_week_wednesday;
      case 4: return s.common_week_thursday;
      case 5: return s.common_week_friday;
      case 6: return s.common_week_saturday;
      case 7: return s.common_week_sunday;
      default: return '';
    }
  }

  /// 获取本地化的"日期待定"文本（支持中日英）
  static String getUnknownDateText(BuildContext context) {
    final languageCode = _getLanguageCode(context);
    
    switch (languageCode) {
      case 'zh':
      case 'zh_CN':
      case 'zh_TW':
      case 'zh_HK':
        return '日期待定';
      case 'ja':
      case 'ja_JP':
        return '日程未定';
      default:
        return 'Date to be determined';
    }
  }

  /// 解析日期字符串为DateTime对象
  /// 支持多种输入格式：yyyy-MM-dd, yyyy-MM-dd HH:mm:ss, MM/dd/yyyy, dd-MM-yyyy等
  static DateTime? parseDate(String? dateString, {String? inputFormat}) {
    if (dateString == null || dateString.isEmpty) {
      return null;
    }

    try {
      // 如果指定了输入格式，使用DateFormat解析
      if (inputFormat != null) {
        return DateFormat(inputFormat).parse(dateString);
      }

      // 自动检测常见格式
      final cleanedDate = dateString.trim();

      // yyyy-MM-dd HH:mm:ss
      if (RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$').hasMatch(cleanedDate)) {
        return DateTime.parse(cleanedDate);
      }

      // yyyy-MM-dd
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(cleanedDate)) {
        return DateTime.parse(cleanedDate);
      }

      // yyyy/MM/dd
      if (RegExp(r'^\d{4}/\d{2}/\d{2}$').hasMatch(cleanedDate)) {
        return DateFormat('yyyy/MM/dd').parse(cleanedDate);
      }

      // MM/dd/yyyy
      if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(cleanedDate)) {
        return DateFormat('MM/dd/yyyy').parse(cleanedDate);
      }

      // dd/MM/yyyy
      if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(cleanedDate)) {
        try {
          return DateFormat('dd/MM/yyyy').parse(cleanedDate);
        } catch (e) {
          // 如果dd/MM/yyyy失败，尝试MM/dd/yyyy
          return DateFormat('MM/dd/yyyy').parse(cleanedDate);
        }
      }

      // dd-MM-yyyy
      if (RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(cleanedDate)) {
        return DateFormat('dd-MM-yyyy').parse(cleanedDate);
      }

      // yyyy年MM月dd日
      if (RegExp(r'^\d{4}年\d{1,2}月\d{1,2}日$').hasMatch(cleanedDate)) {
        return DateFormat('yyyy年MM月dd日').parse(cleanedDate);
      }

      // 尝试直接解析
      return DateTime.parse(cleanedDate);
    } catch (e) {
      return null;
    }
  }

  /// 通用日期格式化方法
  /// 支持自定义输入格式和输出格式
  static String formatDateCustom(
    String? dateString, 
    BuildContext context, {
    String? inputFormat,
    String? outputFormat,
    bool showWeekday = false,
    bool smartYear = false, // 智能年份显示（当年不显示年份）
  }) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }

    try {
      final date = parseDate(dateString, inputFormat: inputFormat);
      if (date == null) return dateString;

      // 如果指定了输出格式，直接使用
      if (outputFormat != null) {
        String result = DateFormat(outputFormat).format(date);
        if (showWeekday) {
          final weekday = getWeekday(date, context);
          result += ' $weekday';
        }
        return result;
      }

      // 使用默认的多语言格式化
      final languageCode = _getLanguageCode(context);
      final currentYear = DateTime.now().year;
      String dateFormat;

      switch (languageCode) {
        case 'zh':
        case 'zh_CN':
        case 'zh_TW':
        case 'zh_HK':
        case 'ja':
        case 'ja_JP':
          if (smartYear && date.year == currentYear) {
            dateFormat = '${date.month}月${date.day}日';
          } else {
            dateFormat = '${date.year}年${date.month}月${date.day}日';
          }
          break;
        default:
          // 英文和其他语言
          final monthName = _getMonthName(date.month);
          if (smartYear && date.year == currentYear) {
            dateFormat = '$monthName ${date.day}';
          } else {
            dateFormat = '$monthName ${date.day}, ${date.year}';
          }
          break;
      }

      if (showWeekday) {
        final weekday = getWeekday(date, context);
        dateFormat += ' $weekday';
      }

      return dateFormat;
    } catch (e) {
      return dateString;
    }
  }
  /// 格式化日期为年月日格式
  /// 输入格式: yyyy-MM-dd（或自动检测）
  /// 输出格式:
  /// - 中文: 2024年12月25日
  /// - 日文: 2024年12月25日
  /// - 英文: Dec 25, 2024
  static String formatDate(String? dateString, BuildContext context, {String? inputFormat}) {
    return formatDateCustom(dateString, context, inputFormat: inputFormat);
  }

  /// 格式化日期为年月格式
  /// 输入格式: yyyy-MM-dd（或自动检测）
  /// 输出格式:
  /// - 中文: 2024年12月
  /// - 日文: 2024年12月
  /// - 英文: Dec 2024
  static String formatYearMonth(String? dateString, BuildContext context, {String? inputFormat}) {
    final languageCode = _getLanguageCode(context);
    String outputFormat;
    
    switch (languageCode) {
      case 'zh':
      case 'zh_CN':
      case 'zh_TW':
      case 'zh_HK':
      case 'ja':
      case 'ja_JP':
        outputFormat = 'yyyy年MM月';
        break;
      default:
        outputFormat = 'MMM yyyy';
        break;
    }
    
    return formatDateCustom(dateString, context, 
      inputFormat: inputFormat, 
      outputFormat: outputFormat
    );
  }

  /// 格式化日期为智能年月日格式（带星期）
  /// 输入格式: yyyy-MM-dd（或自动检测）
  /// 输出格式:
  /// - 当年: 12月25日 周三 (中文/日文) 或 Dec 25 Wednesday (英文)
  /// - 非当年: 2024年12月25日 周三 (中文/日文) 或 Dec 25, 2024 Wednesday (英文)
  static String formatDateWithWeekday(String? dateString, BuildContext context, {String? inputFormat}) {
    if (dateString == null || dateString.isEmpty) {
      return getUnknownDateText(context);
    }
    
    return formatDateCustom(dateString, context, 
      inputFormat: inputFormat,
      showWeekday: true,
      smartYear: true
    );
  }

  /// 从带星期的日期字符串中提取日期部分
  /// 输入: "12月25日 周三" 或 "2024年12月25日 周三"
  /// 输出: "12月25日" 或 "2024年12月25日"
  static String extractDatePart(String dateWithWeekday) {
    final parts = dateWithWeekday.split(' ');
    return parts.isNotEmpty ? parts[0] : dateWithWeekday;
  }

  /// 从带星期的日期字符串中提取星期部分
  /// 输入: "12月25日 周三" 或 "Dec 25 Wednesday"
  /// 输出: "周三" 或 "Wednesday"
  static String extractWeekdayPart(String dateWithWeekday) {
    final parts = dateWithWeekday.split(' ');
    return parts.length > 1 ? parts[1] : '';
  }

  /// 验证日期格式是否为 yyyy-MM-dd
  static bool isValidDate(String date) {
    RegExp regExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return regExp.hasMatch(date);
  }

  /// 通用时间格式化方法（兼容utils/index.dart中的formatTime方法）
  /// 支持自定义输入和输出格式
  static String formatTime({
    String inputFormat = 'yyyy-MM-dd HH:mm:ss',
    required String outputFormat,
    String? timeString,
  }) {
    if (timeString != null && timeString.isNotEmpty) {
      try {
        return DateFormat(outputFormat).format(DateFormat(inputFormat).parse(timeString));
      } catch (e) {
        return timeString;
      }
    }
    return '';
  }

  /// 格式化时间为小时:分钟格式（兼容utils/index.dart中的formatNumberToTime方法）
  static String formatNumberToTime(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    String formattedHours = hours.toString().padLeft(2, '0');
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    return '$formattedHours:$formattedMinutes';
  }

  /// 便捷方法：格式化为ISO日期字符串
  static String toISODate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// 便捷方法：格式化为ISO日期时间字符串
  static String toISODateTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  /// 便捷方法：获取今天的日期字符串
  static String today({String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(DateTime.now());
  }

  /// 便捷方法：获取昨天的日期字符串
  static String yesterday({String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(DateTime.now().subtract(const Duration(days: 1)));
  }

  /// 便捷方法：获取明天的日期字符串
  static String tomorrow({String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(DateTime.now().add(const Duration(days: 1)));
  }

  /// 计算两个日期之间的天数差
  static int daysBetween(String startDate, String endDate, {String? inputFormat}) {
    final start = parseDate(startDate, inputFormat: inputFormat);
    final end = parseDate(endDate, inputFormat: inputFormat);
    
    if (start == null || end == null) return 0;
    
    return end.difference(start).inDays;
  }

  /// 判断是否为今天
  static bool isToday(String dateString, {String? inputFormat}) {
    final date = parseDate(dateString, inputFormat: inputFormat);
    if (date == null) return false;
    
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// 判断是否为昨天
  static bool isYesterday(String dateString, {String? inputFormat}) {
    final date = parseDate(dateString, inputFormat: inputFormat);
    if (date == null) return false;
    
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  /// 判断是否为明天
  static bool isTomorrow(String dateString, {String? inputFormat}) {
    final date = parseDate(dateString, inputFormat: inputFormat);
    if (date == null) return false;
    
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }

  /// 获取支持的语言列表（中日英）
  static List<String> getSupportedLanguages() {
    return [
      'zh', 'zh_CN', 'zh_TW', 'zh_HK',  // 中文
      'ja', 'ja_JP',                     // 日文
      'en', 'en_US', 'en_GB',            // 英文
    ];
  }

  /// 获取语言的本地化名称（中日英）
  static String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'zh':
      case 'zh_CN':
        return '简体中文';
      case 'zh_TW':
        return '繁體中文';
      case 'zh_HK':
        return '繁體中文（香港）';
      case 'ja':
      case 'ja_JP':
        return '日本語';
      case 'en':
      case 'en_US':
        return 'English (US)';
      case 'en_GB':
        return 'English (UK)';
      default:
        return languageCode;
    }
  }

  /// 检查是否支持指定语言
  static bool isLanguageSupported(String languageCode) {
    return getSupportedLanguages().contains(languageCode);
  }

  /// 检查语言是否为从右到左（中日英都是从左到右）
  static bool isRightToLeft(String languageCode) {
    // 中日英都是从左到右
    return false;
  }
}

