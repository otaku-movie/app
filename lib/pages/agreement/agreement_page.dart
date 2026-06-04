import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/utils/index.dart';

class AgreementPage extends StatefulWidget {
  final String code;

  const AgreementPage({super.key, required this.code});

  @override
  State<AgreementPage> createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  bool loading = true;
  String title = '';
  String content = '';
  String version = '';
  String effectiveDate = '';
  String lastUpdated = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      String lang = 'ja';
      if (Get.isRegistered<LanguageController>()) {
        lang = Get.find<LanguageController>().locale.value.languageCode;
      }
      final res = await ApiRequest().request<Map<String, dynamic>?>(
        path: '/agreement/detail',
        method: 'GET',
        queryParameters: {'code': widget.code, 'lang': lang},
        fromJsonT: (json) =>
            json == null ? null : Map<String, dynamic>.from(json),
      );
      final data = res.data;
      if (data != null && ((data['content'] as String?)?.isNotEmpty ?? false)) {
        setState(() {
          title = data['title'] as String? ?? '';
          content = data['content'] as String? ?? '';
          version = data['version'] as String? ?? '';
          // 后端 Agreement 实体经 Jackson 序列化后字段为 effectiveAt / updateTime
          // (Lombok @Data + @JsonFormat)；historical 的 effectiveDate / updatedAt
          // 字段名只在 dart fallback 里出现过，从 DB 拉到的真协议永远是 At/Time 后缀。
          effectiveDate = (data['effectiveAt'] as String?) ??
              (data['effectiveDate'] as String?) ??
              '';
          lastUpdated = (data['updateTime'] as String?) ??
              (data['updatedAt'] as String?) ??
              (data['lastUpdated'] as String?) ??
              '';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  String _formatDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      String pad(int v) => v.toString().padLeft(2, '0');
      return '${dt.year}/${pad(dt.month)}/${pad(dt.day)}';
    } catch (_) {
      return raw;
    }
  }

  /// 把协议正文里的占位符替换成实际值。
  ///
  /// `{{APP_NAME}}` / `{{EFFECTIVE_DATE}}` / `{{LAST_UPDATED}}` 由 App 端
  /// 动态填充；其余运营信息（公司、客服、邮箱、保留期等）目前先用合理的
  /// 默认值兜底，正式上线前请通过后台 / SQL 把它们替换为真实值，避免协议
  /// 正文出现 `{{XXX}}` 这种模板符号外漏。
  String _resolvePlaceholders(String src) {
    final today = DateTime.now();
    String pad(int v) => v.toString().padLeft(2, '0');
    final todayStr = '${today.year}/${pad(today.month)}/${pad(today.day)}';
    final eff = effectiveDate.isNotEmpty
        ? _formatDate(effectiveDate)
        : (version.isNotEmpty ? 'v$version' : todayStr);
    final upd = lastUpdated.isNotEmpty ? _formatDate(lastUpdated) : eff;

    final replacements = <String, String>{
      'APP_NAME': 'Otaku Movie',
      'EFFECTIVE_DATE': eff,
      'LAST_UPDATED': upd,
      'COMPANY_NAME': 'Otaku Movie 運営チーム',
      'COMPANY_ADDRESS': '日本国東京都（運営情報の確定後に更新）',
      'JURISDICTION_COURT': '東京地方裁判所',
      'SUPPORT_EMAIL': 'support@otaku-movie.com',
      'SUPPORT_PHONE': '03-0000-0000',
      'SUPPORT_HOURS': '平日 10:00 - 18:00 (JST)',
      'DPO_EMAIL': 'privacy@otaku-movie.com',
      'DPO_RESPONSE_DAYS': '15',
      'REFUND_HOURS': '1',
      'ACCOUNT_RETENTION_DAYS': '30',
      'LOG_RETENTION_DAYS': '180',
      'SUPPORT_RETENTION_DAYS': '365',
      'MIN_AGE': '13',
      'CLOUD_PROVIDERS': 'AWS（東京リージョン）',
      'COMMS_PROVIDERS': 'SendGrid / Twilio',
      'OVERSEAS_LOCATIONS': '日本国外（米国・欧州を含む）',
      'STORAGE_LOCATIONS': '日本（東京リージョン）',
      'API_DOMAIN': 'api.otaku-movie.com',
    };

    var out = src;
    replacements.forEach((key, value) {
      out = out.replaceAll('{{$key}}', value);
    });
    // 兜底：剩余未配置的 `{{XXX}}` 也清掉，避免显示大括号字面量。
    out = out.replaceAll(RegExp(r'\{\{[A-Z0-9_]+\}\}'), '—');
    return out;
  }

  MarkdownStyleSheet _markdownStyle() {
    return MarkdownStyleSheet(
      p: TextStyle(
          fontSize: 28.sp, height: 1.7, color: const Color(0xFF323233)),
      h1: TextStyle(
          fontSize: 40.sp, fontWeight: FontWeight.bold, height: 1.3),
      h2: TextStyle(
          fontSize: 36.sp, fontWeight: FontWeight.bold, height: 1.3),
      h3: TextStyle(
          fontSize: 32.sp, fontWeight: FontWeight.bold, height: 1.3),
      h4: TextStyle(
          fontSize: 30.sp, fontWeight: FontWeight.w600, height: 1.3),
      h1Padding: EdgeInsets.only(top: 8.h, bottom: 14.h),
      h2Padding: EdgeInsets.only(top: 28.h, bottom: 14.h),
      h3Padding: EdgeInsets.only(top: 22.h, bottom: 10.h),
      h4Padding: EdgeInsets.only(top: 18.h, bottom: 8.h),
      listBullet: TextStyle(fontSize: 28.sp, height: 1.7),
      a: TextStyle(
        fontSize: 28.sp,
        color: const Color(0xFF1989FA),
        decoration: TextDecoration.underline,
      ),
      blockquoteDecoration: BoxDecoration(
        color: const Color(0xFFE8F4FF),
        borderRadius: BorderRadius.circular(8.r),
      ),
      blockquotePadding: EdgeInsets.all(18.w),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFFEEF0F3),
            width: 2.h,
          ),
        ),
      ),
      blockSpacing: 16.h,
    );
  }

  /// 把内容按表格切成文本段 / 表格段。
  List<_DocSegment> _splitSegments(String md) {
    final lines = md.split('\n');
    final segments = <_DocSegment>[];
    final buffer = StringBuffer();
    final separator =
        RegExp(r'^\s*\|?\s*:?-+:?\s*(\|\s*:?-+:?\s*)+\|?\s*$');
    int i = 0;
    while (i < lines.length) {
      final isTableStart = lines[i].trimLeft().startsWith('|') &&
          i + 1 < lines.length &&
          separator.hasMatch(lines[i + 1]);
      if (isTableStart) {
        if (buffer.isNotEmpty) {
          segments.add(_DocSegment.text(buffer.toString()));
          buffer.clear();
        }
        final tableLines = <String>[lines[i], lines[i + 1]];
        i += 2;
        while (i < lines.length && lines[i].trimLeft().startsWith('|')) {
          tableLines.add(lines[i]);
          i++;
        }
        segments.add(_DocSegment.table(tableLines));
      } else {
        buffer.writeln(lines[i]);
        i++;
      }
    }
    if (buffer.isNotEmpty) {
      segments.add(_DocSegment.text(buffer.toString()));
    }
    return segments;
  }

  List<String> _splitRow(String line) {
    var s = line.trim();
    if (s.startsWith('|')) s = s.substring(1);
    if (s.endsWith('|')) s = s.substring(0, s.length - 1);
    return s
        .split('|')
        .map((e) => e.trim().replaceAll(r'\|', '|'))
        .toList();
  }

  Widget _buildTable(List<String> tableLines) {
    if (tableLines.length < 2) return const SizedBox.shrink();
    final header = _splitRow(tableLines[0]);
    final body = tableLines.length > 2
        ? tableLines.sublist(2).map(_splitRow).toList()
        : const <List<String>>[];
    final colCount = header.length;
    const outerBorderColor = Color(0xFFE4E7EC);
    const innerBorderColor = Color(0xFFF0F2F5);
    const headerSeparatorColor = Color(0xFFDDE3EB);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: outerBorderColor, width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final preferredColumnWidth =
                  colCount <= 3 ? availableWidth / colCount : 170.w;
              final columnWidth = preferredColumnWidth.clamp(120.w, 190.w);
              final tableWidth = (columnWidth * colCount)
                  .clamp(availableWidth, double.infinity);
              final table = Table(
                defaultColumnWidth: FixedColumnWidth(columnWidth),
                border: const TableBorder(
                  horizontalInside:
                      BorderSide(color: innerBorderColor, width: 1),
                  verticalInside:
                      BorderSide(color: innerBorderColor, width: 1),
                ),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F8FA),
                      border: Border(
                        bottom: BorderSide(
                          color: headerSeparatorColor,
                          width: 1,
                        ),
                      ),
                    ),
                    children: List.generate(colCount, (idx) {
                      return _tableCell(
                        idx < header.length ? header[idx] : '',
                        isHeader: true,
                      );
                    }),
                  ),
                  ...body.map((row) {
                    return TableRow(
                      children: List.generate(colCount, (idx) {
                        return _tableCell(idx < row.length ? row[idx] : '');
                      }),
                    );
                  }),
                ],
              );
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: availableWidth,
                    maxWidth: tableWidth,
                  ),
                  child: table,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _tableCellBody(String raw, {required bool isHeader}) {
    if (raw.isEmpty) {
      return Text(
        '—',
        style: TextStyle(
          fontSize: 22.sp,
          color: Colors.grey.shade500,
        ),
      );
    }
    final normalized =
        raw.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '  \n');
    return _tableCellMarkdown(normalized, isHeader: isHeader);
  }

  Widget _tableCellMarkdown(String raw, {required bool isHeader}) {
    return MarkdownBody(
      data: raw,
      builders: {
        'code': _InlineCodeBuilder(fontSize: 20.sp, radius: 6.r),
      },
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          fontSize: 22.sp,
          height: 2.1,
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
          color:
              isHeader ? const Color(0xFF323233) : const Color(0xFF4A4A4A),
        ),
        a: TextStyle(
          fontSize: 22.sp,
          color: const Color(0xFF1989FA),
          decoration: TextDecoration.underline,
        ),
        blockSpacing: 0,
      ),
      onTapLink: (text, href, t) {
        if (href != null && href.isNotEmpty) launchURL(href);
      },
    );
  }

  Widget _tableCell(String raw, {bool isHeader = false}) {
    return TableCell(
      verticalAlignment: isHeader
          ? TableCellVerticalAlignment.middle
          : TableCellVerticalAlignment.top,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 120.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: _tableCellBody(raw, isHeader: isHeader),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolved = _resolvePlaceholders(content);
    final segments = _splitSegments(resolved);
    final style = _markdownStyle();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text(
          title.isEmpty ? widget.code : title,
          style: TextStyle(color: Colors.white, fontSize: 32.sp),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : content.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48.w),
                    child: Text(
                      S.of(context).agreement_emptyContent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26.sp,
                        color: Colors.grey.shade600,
                        height: 1.6,
                      ),
                    ),
                  ),
                )
              : SelectionArea(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 24.h,
                    ),
                    itemCount: segments.length,
                    itemBuilder: (context, index) {
                      final seg = segments[index];
                      if (seg.isTable) {
                        return _buildTable(seg.tableLines);
                      }
                      return MarkdownBody(
                        data: seg.text,
                        styleSheet: style,
                        builders: {
                          'code': _InlineCodeBuilder(
                            fontSize: 24.sp,
                            radius: 6.r,
                          ),
                        },
                        onTapLink: (text, href, t) {
                          if (href != null && href.isNotEmpty) launchURL(href);
                        },
                      );
                    },
                  ),
                ),
    );
  }
}

class _DocSegment {
  final bool isTable;
  final String text;
  final List<String> tableLines;

  _DocSegment.text(this.text)
      : isTable = false,
        tableLines = const [];

  _DocSegment.table(this.tableLines)
      : isTable = true,
        text = '';
}

/// 用一个带圆角背景 + padding 的容器渲染 markdown 的 inline code (`xxx`)，
/// 默认的 `TextStyle.backgroundColor` 是紧贴字形的扁平色块，无法加 padding。
class _InlineCodeBuilder extends MarkdownElementBuilder {
  final double fontSize;
  final double radius;

  _InlineCodeBuilder({required this.fontSize, required this.radius});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        element.textContent,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'monospace',
          color: const Color(0xFF323233),
        ),
      ),
    );
  }
}
