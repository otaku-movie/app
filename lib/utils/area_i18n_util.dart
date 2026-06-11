import 'package:flutter/material.dart';
import 'package:otaku_movie/response/area_response.dart';

/// 地区名称国际化工具。
///
/// 地区筛选要求「日文 + 翻译语言」并列显示：
///   - 当前语言为日语：只显示日文 name；
///   - 中文 / 英文：显示「日文 翻译」（译名为空或与日文相同时回退为只显示日文）。
///
/// 后端仍返回原始日文 name（自动定位匹配依赖它），译名走独立字段 nameZh / nameEn。
class AreaI18nUtil {
  AreaI18nUtil._();

  static String _languageCode(BuildContext context) {
    return Localizations.localeOf(context).languageCode;
  }

  /// 按当前语言拼接地区显示名。
  static String displayName(
    BuildContext context, {
    String? name,
    String? nameZh,
    String? nameEn,
  }) {
    final ja = (name ?? '').trim();
    final lang = _languageCode(context);
    if (lang == 'ja') {
      return ja;
    }

    String? translation;
    if (lang == 'zh') {
      translation = nameZh;
    } else if (lang == 'en') {
      translation = nameEn;
    }

    final t = (translation ?? '').trim();
    if (t.isEmpty || t == ja) {
      return ja;
    }
    if (ja.isEmpty) {
      return t;
    }
    return '$ja $t';
  }

  /// 返回用于「右侧两端对齐」展示的译名部分。
  /// - 日语环境：返回空串（只显示日文 name，不需要右侧列）；
  /// - 中文 / 英文环境：返回对应译名；即使译名与日文写法相同也照常返回，
  ///   译名缺失时回退日文。保证中文/英文下每行都有右侧列、整体两端对齐一致。
  static String translation(
    BuildContext context, {
    String? name,
    String? nameZh,
    String? nameEn,
  }) {
    final ja = (name ?? '').trim();
    final lang = _languageCode(context);
    if (lang == 'ja') return '';
    String? tr;
    if (lang == 'zh') {
      tr = nameZh;
    } else if (lang == 'en') {
      tr = nameEn;
    }
    final t = (tr ?? '').trim();
    return t.isNotEmpty ? t : ja;
  }

  /// 便捷重载：直接传 AreaResponse。
  static String displayNameOf(BuildContext context, AreaResponse area) {
    return displayName(
      context,
      name: area.name,
      nameZh: area.nameZh,
      nameEn: area.nameEn,
    );
  }
}
