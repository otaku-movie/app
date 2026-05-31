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

  /// 格式化完整的日期时间范围给后端（格式：yyyy-MM-dd HH:mm:ss-yyyy-MM-dd HH:mm:ss）
  /// 30小时制：24-29对应下一天的00:00-05:59
  /// 
  /// [startHour] 开始小时（滑块值，30小时制是6-29，24小时制是0-24）
  /// [endHour] 结束小时（滑块值，30小时制是6-29，24小时制是0-24）
  /// [baseDate] 基准日期，用于计算完整的日期时间
  /// [use30HourFormat] 是否使用30小时制
  static String formatFullDateTimeRangeForBackend(
    double startHour, 
    double endHour, 
    DateTime baseDate,
    bool use30HourFormat,
  ) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    
    DateTime startDateTime;
    DateTime endDateTime;
    
    if (use30HourFormat) {
      // 30小时制处理
      if (startHour >= 24) {
        // 24-29对应下一天的00:00-05:59
        final hour = (startHour - 24).toInt();
        final minute = ((startHour - startHour.toInt()) * 60).toInt();
        startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day + 1, hour, minute);
      } else {
        // 6-23对应当天的06:00-23:59
        final hour = startHour.toInt();
        final minute = ((startHour - startHour.toInt()) * 60).toInt();
        startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
      }
      
      if (endHour >= 24) {
        // 24-29对应下一天的00:00-05:59
        if (endHour == 29) {
          // 29表示全天，显示为下一天的05:59:59
          endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day + 1, 5, 59, 59);
        } else {
          final hour = (endHour - 24).toInt();
          final minute = ((endHour - endHour.toInt()) * 60).toInt();
          endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day + 1, hour, minute);
        }
      } else {
        // 6-23对应当天的06:00-23:59
        final hour = endHour.toInt();
        final minute = ((endHour - endHour.toInt()) * 60).toInt();
        endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
      }
    } else {
      // 24小时制处理
      if (endHour == 24) {
        // 24表示全天，显示为当天的23:59:59
        final hour = startHour.toInt();
        final minute = ((startHour - startHour.toInt()) * 60).toInt();
        startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
        endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, 23, 59, 59);
      } else {
        final startHourInt = startHour.toInt();
        final startMinute = ((startHour - startHour.toInt()) * 60).toInt();
        final endHourInt = endHour.toInt();
        final endMinute = ((endHour - endHour.toInt()) * 60).toInt();
        startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, startHourInt, startMinute);
        endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, endHourInt, endMinute);
      }
    }
    
    return '${dateFormat.format(startDateTime)}-${dateFormat.format(endDateTime)}';
  }

  /// 格式化时间为30小时制或24小时制显示
  /// 
  /// [dateTime] 要格式化的时间，如果为 null 则返回 '--:--'
  /// [use30HourFormat] 是否使用30小时制
  /// [baseDate] 基准日期，用于判断时间是否属于下一天（30小时制时，下一天的0-5点显示为24-29点）
  /// 
  /// 返回格式化的时间字符串，格式为 'HH:mm'
  /// 
  /// 30小时制规则：
  /// - 当天的6-23点显示为6-23点
  /// - 下一天的0-5点显示为24-29点（表示前一天的24-29点）
  static String formatShowTime({
    DateTime? dateTime,
    required bool use30HourFormat,
    DateTime? baseDate,
  }) {
    if (dateTime == null) return '--:--';
    
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    
    // 如果是30小时制，需要判断是否应该显示为24-29点
    if (use30HourFormat && baseDate != null) {
      // 获取基准日期和时间的日期部分（不包含时间）
      final baseDateOnly = DateTime(baseDate.year, baseDate.month, baseDate.day);
      final dateTimeOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);
      
      // 如果时间日期是基准日期的下一天，且小时是0-5点，说明是前一天的24-29点
      if (dateTimeOnly.difference(baseDateOnly).inDays == 1 && hour >= 0 && hour <= 5) {
        hour += 24;
      }
      // 注意：当天的0-5点不转换为24-29点，因为30小时制是从6点开始的
    }
    
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// 把"完整时刻 datetime 字符串"按 24h / 30h 规则格式化为展示文本。
  ///
  /// 参数：
  /// - [timeStr]：完整 datetime 字符串（含年月日时分秒），例如：
  ///   `'2026-11-26 00:00:00'`、`'2026-11-26T02:35:00'`。
  ///   只接受可被 [DateTime.parse] 解析的字符串；纯 "HH:mm" 请先用
  ///   [combineDateTime] 拼成完整 datetime 再传入。
  /// - [use30HourFormat]：是否使用 30 小时制。
  ///   `true` 且小时 < 06:00 时，会被视作"前一营业日的凌晨场"，
  ///   pattern 里的**日期占位会自动回退一天**，**小时占位会变成 24~29**。
  ///   例如：`'2026-11-26 00:00:00'` → `'2026-11-25 24:00:00'`；
  ///        `'2026-11-26 02:35:00'` → `'2026-11-25 26:35:00'`。
  /// - [pattern]：输出 pattern（默认 `'HH:mm'`），遵循 [DateFormat] 规则。
  ///
  /// 解析失败时回退到原始字符串。
  static String formatShowTimeFromString({
    required String? timeStr,
    required bool use30HourFormat,
    String pattern = 'HH:mm',
  }) {
    if (timeStr == null || timeStr.trim().isEmpty) return '--:--';
    final clean = timeStr.trim();
    try {
      final dt = DateTime.parse(clean.replaceFirst(' ', 'T'));

      // 24h 模式 / 非凌晨场：直接按原 pattern 渲染原 datetime。
      if (!use30HourFormat || dt.hour >= 6) {
        return DateFormat(pattern).format(dt);
      }

      // 30h 模式 + 凌晨场：日期回退一天，小时 +24。
      // 用占位符把 pattern 中的 H/HH 暂换成"字面量字符串"，
      // 让 DateFormat 不去解析，剩余的 yyyy/MM/dd/E 等正常按"前一天日期"渲染。
      const hhPlaceholder = '__OM_HH__';
      const hPlaceholder = '__OM_H__';
      final hasHH = pattern.contains('HH');
      final escaped = pattern
          .replaceAll('HH', "'$hhPlaceholder'")
          .replaceAllMapped(
            RegExp(r"(?<![A-Za-z'])H(?![A-Za-z'])"),
            (_) => "'$hPlaceholder'",
          );
      final displayDt = dt.subtract(const Duration(days: 1));
      var rendered = DateFormat(escaped).format(displayDt);
      if (hasHH) {
        rendered = rendered.replaceAll(
          hhPlaceholder,
          (dt.hour + 24).toString().padLeft(2, '0'),
        );
      }
      rendered = rendered.replaceAll(
        hPlaceholder,
        (dt.hour + 24).toString(),
      );
      return rendered;
    } catch (_) {
      return clean;
    }
  }

  /// 把"营业日 + 纯时间（HH:mm[:ss]）"拼成 `yyyy-MM-dd HH:mm:ss` 形式的
  /// 完整 datetime 字符串，便于直接传给 [formatShowTimeFromString]。
  ///
  /// 参数：
  /// - [date]：营业日，格式 `yyyy-MM-dd`（也可包含时分秒，会被截到日）。
  /// - [time]：纯时间字符串，格式 `HH:mm[:ss]`。
  /// - [referenceStartTime]：可选；当 [time] 数值上 < [referenceStartTime] 时，
  ///   自动把日期 +1 天，用于"场次跨过 24:00 的结束时间"。
  ///   支持 `HH:mm[:ss]` 或完整 datetime 字符串。
  ///
  /// 任一关键参数缺失或解析失败时返回 `null`。
  static String? combineDateTime({
    required String? date,
    required String? time,
    String? referenceStartTime,
  }) {
    if (date == null || date.trim().isEmpty) return null;
    if (time == null || time.trim().isEmpty) return null;
    try {
      final t = time.trim();
      final parts = t.split(':');
      final hour = parts.isNotEmpty ? int.parse(parts[0]) : 0;
      final minute = parts.length >= 2 ? int.parse(parts[1]) : 0;
      final second = parts.length >= 3 ? int.parse(parts[2]) : 0;

      final baseDate = DateTime.parse(date.trim());
      var dt = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        hour,
        minute,
        second,
      );

      if (referenceStartTime != null &&
          referenceStartTime.trim().isNotEmpty) {
        try {
          final refClean = referenceStartTime.trim();
          final refParts = (refClean.contains(' ') || refClean.contains('T'))
              ? refClean.replaceFirst('T', ' ').split(' ').last.split(':')
              : refClean.split(':');
          final refMinutes = int.parse(refParts[0]) * 60 +
              (refParts.length >= 2 ? int.parse(refParts[1]) : 0);
          final curMinutes = hour * 60 + minute;
          if (curMinutes < refMinutes) {
            dt = dt.add(const Duration(days: 1));
          }
        } catch (_) {/* 解析失败则不偏移 */}
      }

      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
    } catch (_) {
      return null;
    }
  }
}

