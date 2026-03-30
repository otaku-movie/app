import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/app_version_check_response.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// 应用版本检查：请求 `/app/version/check`，并在需要时展示更新弹窗（含 Markdown 更新说明）。
class VersionCheckService {
  /// 避免冷启动重复弹出更新框（仅内存标记，进程重启后失效）。
  static bool _startupDialogShown = false;

  /// 拉取服务端版本信息；不弹 UI。
  static Future<AppVersionCheckResponse?> checkVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final platform =
        defaultTargetPlatform == TargetPlatform.iOS ? 'IOS' : 'Android';
    final buildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;
    final res = await ApiRequest().request(
      path: '/app/version/check',
      method: 'GET',
      queryParameters: {
        'platform': platform,
        'version': packageInfo.version,
        'buildNumber': buildNumber,
      },
      fromJsonT: (json) =>
          AppVersionCheckResponse.fromJson(json as Map<String, dynamic>),
    );
    return res.data;
  }

  /// 启动时若需要更新则弹窗；失败静默忽略。
  static Future<void> checkOnStartup(BuildContext context) async {
    if (_startupDialogShown) return;
    try {
      final result = await checkVersion();
      if (result != null && result.needUpdate == true && context.mounted) {
        _startupDialogShown = true;
        await _showUpdateDialog(context, result, manualCheck: false);
      }
    } catch (_) {
      // 启动检查失败不阻断
    }
  }

  /// 按平台打开商店：Android → Google Play，iOS → App Store；其余平台用接口 [downloadUrl]。
  static String _resolveUpdateLaunchUrl(AppVersionCheckResponse result) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Config.googlePlayStoreUrl;
      case TargetPlatform.iOS:
        return Config.appStoreListingUrl ?? (result.downloadUrl ?? '').trim();
      default:
        return (result.downloadUrl ?? '').trim();
    }
  }

  /// 用户主动「检查更新」：无更新/失败时 Toast 提示。
  static Future<void> checkByUserAction(BuildContext context) async {
    try {
      final result = await checkVersion();
      if (!context.mounted) return;
      if (result == null) {
        ToastService.showInfo(S.of(context).user_updateErrorMessage);
        return;
      }
      if (result.needUpdate == true) {
        await _showUpdateDialog(context, result, manualCheck: true);
      } else {
        ToastService.showInfo(S.of(context).user_noUpdateAvailable);
      }
    } catch (_) {
      if (!context.mounted) return;
      ToastService.showInfo(S.of(context).user_updateErrorMessage);
    }
  }

  /// 更新弹窗：[manualCheck] 为 true 表示从设置进入，跳转商店成功后可关闭弹窗。
  static Future<void> _showUpdateDialog(
    BuildContext context,
    AppVersionCheckResponse result, {
    required bool manualCheck,
  }) async {
    final force = result.forceUpdate == true;
    final current = (await PackageInfo.fromPlatform()).version;
    if (!context.mounted) return;
    final latest = result.latestVersion ?? '-';
    final note = result.releaseNote?.trim();
    final hasNote = note != null && note.isNotEmpty;
    final sizeDisplay = result.packageSizeDisplay;
    final hasSize = sizeDisplay != null && sizeDisplay.isNotEmpty;
    final versionForTitle = _versionPlain(latest);

    const primaryBlue = Color(0xFF1989FA);
    const titleColor = Color(0xFF1A1A1A);
    const labelGrey = Color(0xFF969799);
    const bodyGrey = Color(0xFF646566);

    await showDialog<void>(
      context: context,
      barrierDismissible: !force,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (dialogContext) {
        final s = S.of(context);
        final markdownSheet = _updateMarkdownStyleSheet();

        // 打开下载链接；非强制且为用户主动检查时，成功拉起商店后关闭弹窗。
        Future<void> onUpdate() async {
          final url = _resolveUpdateLaunchUrl(result);
          if (url.isEmpty) {
            ToastService.showInfo(s.user_updateErrorMessage);
            return;
          }
          final ok = await launchUrl(Uri.parse(url),
              mode: LaunchMode.externalApplication);
          if (!dialogContext.mounted) return;
          if (!ok) {
            ToastService.showInfo(s.user_updateErrorMessage);
          } else if (!force && manualCheck) {
            Navigator.of(dialogContext).pop();
          }
        }

        return PopScope(
          canPop: !force,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // 相对屏幕边缘留白；弹窗内容宽度还受下方 [SizedBox.width] 约束。
            insetPadding:
                EdgeInsets.symmetric(horizontal: 22.w, vertical: 28.h),
            // 宽度为屏幕宽度的比例（.sw = ScreenUtil 屏宽）。
            child: SizedBox(
              width: 0.88.sw,
              child: Material(
                color: Colors.white,
                elevation: 16,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(18.r),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ---------- 顶栏：渐变背景、火箭图标、标题与副文案；非强制时右上角关闭 ----------
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(26.w, 30.h, 26.w, 24.h),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFE8F4FF),
                                Color(0xFFF2ECFF),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 72.r,
                                height: 72.r,
                                decoration: BoxDecoration(
                                  color: primaryBlue,
                                  borderRadius: BorderRadius.circular(18.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          primaryBlue.withValues(alpha: 0.35),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Icon(Icons.rocket_launch_rounded,
                                    color: Colors.white, size: 40.sp),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                s.user_updateDialogTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  color: titleColor,
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                s.user_updateAvailable,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  height: 1.45,
                                  color: bodyGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!force)
                          Positioned(
                            top: 4.h,
                            right: 2.w,
                            child: IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              icon: Icon(Icons.close_rounded,
                                  color: Colors.grey.shade600, size: 30.sp),
                            ),
                          ),
                      ],
                    ),
                    // ---------- 主体：版本对比、可选包体大小、强制提示、Markdown 说明、底部按钮 ----------
                    Padding(
                      padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 22.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 左侧：当前版 → 最新版胶囊；右侧（可选）：接口返回的 packageSizeDisplay 等
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: hasSize ? 5 : 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.user_updateToLatestHint,
                                      style: TextStyle(
                                          fontSize: 21.sp,
                                          color: labelGrey,
                                          height: 1.3),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: _versionChip(
                                              _withVPrefix(current),
                                              highlight: false),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.w),
                                          child: Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 24.sp,
                                              color: labelGrey),
                                        ),
                                        Flexible(
                                          child: _versionChip(
                                              _withVPrefix(latest),
                                              highlight: true,
                                              primaryBlue: primaryBlue),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (hasSize) ...[
                                SizedBox(width: 16.w),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        s.user_updatePackageSizeLabel,
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            color: labelGrey,
                                            height: 1.3),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        sizeDisplay,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w700,
                                          color: titleColor,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (force) ...[
                            SizedBox(height: 14.h),
                            // 强制更新：不可关闭弹窗，仅展示说明条
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7E8),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                    color: const Color(0xFFFFD591)
                                        .withValues(alpha: 0.65)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.info_outline_rounded,
                                      color: const Color(0xFFED6A0C),
                                      size: 28.sp),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      s.user_forceUpdateHint,
                                      style: TextStyle(
                                        color: const Color(0xFF646566),
                                        fontSize: 18.sp,
                                        height: 1.45,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (hasNote) ...[
                            SizedBox(height: 18.h),
                            // releaseNote 为 Markdown；样式见 [_updateMarkdownStyleSheet]
                            Text(
                              s.user_updateWhatsNewInVersion(versionForTitle),
                              style: TextStyle(
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w700,
                                color: titleColor,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFEBEDF0)),
                            SizedBox(height: 12.h),
                            // 更新说明可滚动；过高时由 [maxHeight] 限制，避免撑满整屏
                            Container(
                              constraints: BoxConstraints(maxHeight: 300.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F8FA),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(
                                      18.w, 14.h, 18.w, 16.h),
                                  child: MarkdownBody(
                                    data: note,
                                    styleSheet: markdownSheet,
                                    selectable: false,
                                    shrinkWrap: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 20.h),
                          // 非强制：稍后提醒 + 更新；强制：仅更新（全宽）
                          if (!force)
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: bodyGrey,
                                      side: const BorderSide(
                                          color: Color(0xFFEBEDF0), width: 1.5),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 26.h, horizontal: 10.w),
                                      minimumSize: Size(0, 56.h),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                    ),
                                    child: Text(
                                      s.user_updateRemindLater,
                                      style: TextStyle(
                                          fontSize: 23.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: onUpdate,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryBlue,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 26.h, horizontal: 10.w),
                                      minimumSize: Size(0, 56.h),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.download_rounded,
                                            size: 30.sp),
                                        SizedBox(width: 10.w),
                                        Flexible(
                                          child: Text(
                                            s.user_update,
                                            style: TextStyle(
                                                fontSize: 23.sp,
                                                fontWeight: FontWeight.w700),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: onUpdate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 26.h, horizontal: 16.w),
                                  minimumSize: Size(double.infinity, 56.h),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.download_rounded, size: 30.sp),
                                    SizedBox(width: 12.w),
                                    Text(
                                      s.user_update,
                                      style: TextStyle(
                                          fontSize: 23.sp,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 展示用版本号，统一带上 `v` 前缀（避免重复前缀）。
  static String _withVPrefix(String ver) {
    final t = ver.trim();
    if (t.isEmpty || t == '-') return 'v—';
    if (t.startsWith('v') || t.startsWith('V')) return t;
    return 'v$t';
  }

  /// 标题用「v{version}」占位时去掉重复的 `v`
  static String _versionPlain(String ver) {
    final t = ver.trim();
    if (t.isEmpty || t == '-') return '—';
    if (t.startsWith('v') || t.startsWith('V')) return t.substring(1);
    return t;
  }

  /// 版本胶囊：灰底为当前版，蓝底为最新版（带星标）。
  static Widget _versionChip(String text,
      {required bool highlight, Color primaryBlue = const Color(0xFF1989FA)}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: highlight ? primaryBlue : const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: highlight ? Colors.white : const Color(0xFF323233),
              ),
            ),
          ),
          if (highlight) ...[
            SizedBox(width: 6.w),
            Icon(Icons.auto_awesome_rounded,
                size: 18.sp, color: Colors.white.withValues(alpha: 0.9)),
          ],
        ],
      ),
    );
  }

  /// 更新说明 [releaseNote] 的 Markdown 样式；无序列表圆点大小主要由 [listBullet.fontSize] 控制。
  static MarkdownStyleSheet _updateMarkdownStyleSheet() {
    const primaryBlue = Color(0xFF1989FA);
    const body = Color(0xFF323233);

    return MarkdownStyleSheet(
      h1: TextStyle(
          fontSize: 26.sp,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
          height: 1.35),
      h2: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
          height: 1.35),
      h3: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A1A),
          height: 1.3),
      p: TextStyle(fontSize: 20.sp, height: 1.55, color: body),
      strong: const TextStyle(fontWeight: FontWeight.w600, color: body),
      em: const TextStyle(fontStyle: FontStyle.italic, color: body),
      // `li` 前的圆点：字号越大圆点越大；[listIndent] 为列表整体左缩进。
      listBullet: TextStyle(
        color: primaryBlue,
        fontSize: 26.sp,
        height: 1.4,
      ),
      listIndent: 34.w,
      blockSpacing: 18.h,
      horizontalRuleDecoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEBEDF0), width: 1)),
      ),
      code: TextStyle(
        fontSize: 15.sp,
        color: body,
        backgroundColor: const Color(0xFFEBEDF0),
        fontFamily: 'monospace',
      ),
      blockquotePadding: EdgeInsets.only(left: 16.w),
      blockquoteDecoration: const BoxDecoration(
        border: Border(left: BorderSide(color: primaryBlue, width: 8)),
      ),
    );
  }
}
