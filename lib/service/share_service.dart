import 'package:flutter/widgets.dart';
import 'package:otaku_movie/config/auth_config.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:share_plus/share_plus.dart';

/// 统一封装系统分享面板的入口。
///
/// 关键约定：
/// - 所有分享文案都遵循「一行标题 + 一行说明 + URL」结构，
///   方便 IM / 社交平台预览。
/// - URL 一律走 [AuthConfig.webShareBaseUrl]，由 movie-web 落地页负责
///   渲染 Open Graph meta，并在已装 App 时通过 Universal Link / App Link
///   直接拉起 App 对应详情页。
class ShareService {
  ShareService._();

  static final ShareService instance = ShareService._();

  /// 分享电影详情：高频入口，最常被分发到 IM。
  Future<void> shareMovie({
    required String movieId,
    required String movieName,
    String? description,
    String? coverUrl,
    BuildContext? sharePositionOrigin,
  }) async {
    final url = '${AuthConfig.webShareBaseUrl}/share/movie/$movieId';
    final lines = <String>[
      movieName,
      if (description != null && description.trim().isNotEmpty) description.trim(),
      url,
    ];
    await _share(
      text: lines.join('\n'),
      subject: movieName,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// 分享订单/电影票：「炫耀已购票」+ 「邀请朋友一起去」。
  Future<void> shareTicket({
    required String orderNumber,
    required String movieName,
    String? showTime,
    String? cinemaName,
    BuildContext? sharePositionOrigin,
  }) async {
    final url = '${AuthConfig.webShareBaseUrl}/share/order/$orderNumber';
    final lines = <String>[
      '🎬 $movieName',
      if (showTime != null && showTime.isNotEmpty) '🕒 $showTime',
      if (cinemaName != null && cinemaName.isNotEmpty) '📍 $cinemaName',
      url,
    ];
    await _share(
      text: lines.join('\n'),
      subject: movieName,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// 分享入场者特典：病毒传播的关键入口（粉丝看到会想要同款）。
  Future<void> shareBenefit({
    required String movieId,
    required String benefitId,
    required String benefitName,
    String? movieName,
    BuildContext? sharePositionOrigin,
  }) async {
    final url =
        '${AuthConfig.webShareBaseUrl}/share/benefit/$movieId/$benefitId';
    final lines = <String>[
      '🎁 $benefitName',
      if (movieName != null && movieName.isNotEmpty) '🎬 $movieName',
      url,
    ];
    await _share(
      text: lines.join('\n'),
      subject: benefitName,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  Future<void> _share({
    required String text,
    String? subject,
    BuildContext? sharePositionOrigin,
  }) async {
    try {
      // iPad 上 share sheet 是 popover，需要 anchor，否则会崩。
      Rect? origin;
      if (sharePositionOrigin != null) {
        final box = sharePositionOrigin.findRenderObject() as RenderBox?;
        if (box != null) {
          origin = box.localToGlobal(Offset.zero) & box.size;
        }
      }
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          subject: subject,
          sharePositionOrigin: origin,
        ),
      );
    } catch (e, st) {
      log.e('Share failed', error: e, stackTrace: st);
    }
  }
}
