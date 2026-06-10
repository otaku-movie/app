import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:otaku_movie/analytics/analytics.dart';
import 'package:otaku_movie/analytics/events.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/controller/TimeFormatController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/app_version_check_response.dart';
import 'package:otaku_movie/response/user/user_detail_response.dart';
import 'package:otaku_movie/service/auth_logout_service.dart';
import 'package:otaku_movie/service/version_check_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _PageState();
}

class _PageState extends State<UserInfo> {
  final LanguageController languageController = Get.find();
  final TimeFormatController timeFormatController =
      Get.find<TimeFormatController>();
  UserDetailResponse data = UserDetailResponse();
  
  String langName = '';
  String token = '';
  String currentVersion = '';
  bool isCheckingUpdate = false;
  /// 进入页面时静默检查；有更新时用于在「检查更新」右侧展示新版本信息。
  AppVersionCheckResponse? _versionCheckResult;
  
  void updateLangName () {
    Map<String, String> lang = languageController.lang.firstWhere(
      (el) => el['code'] == languageController.locale.value.languageCode,
      orElse: () => {'code': 'ja', 'name': '日本語'});

    setState(() {
      langName = '${lang['name']}';
    });
  }

  /// 静默版本检查（不弹窗），供进入页面与下拉刷新使用。
  Future<void> _silentVersionCheck() async {
    try {
      final r = await VersionCheckService.checkVersion();
      if (!mounted) return;
      setState(() {
        _versionCheckResult = r;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _versionCheckResult = null;
      });
    }
  }

  // 获取当前版本信息
  Future<void> _getCurrentVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        currentVersion = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        currentVersion = '1.0.0';
      });
    }
  }

  // 检查更新
  Future<void> _checkUpdate() async {
    if (isCheckingUpdate) return;
    
    setState(() {
      isCheckingUpdate = true;
    });

    try {
      await VersionCheckService.checkByUserAction(context);
    } catch (e) {
      // 显示错误提示
      _showErrorDialog();
    } finally {
      if (mounted) {
        setState(() {
          isCheckingUpdate = false;
        });
        await _silentVersionCheck();
      }
    }
  }

  // 显示错误对话框
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.red.shade50,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 错误图标
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.red.shade600],
                    ),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Icon(
                    Icons.error,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  S.of(context).user_updateError,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  S.of(context).user_updateErrorMessage,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 2,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close, size: 18.sp),
                        SizedBox(width: 4.w),
                        Text(
                          S.of(context).user_ok,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 退出登录：弹出确认框 -> 清除本地 token -> 跳转登录页
  Future<void> _handleLogout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.red.shade600],
                    ),
                    borderRadius: BorderRadius.circular(36.r),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  S.of(context).user_logout,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  S.of(context).user_logoutConfirmMessage,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          S.of(context).user_cancel,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          S.of(context).user_ok,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true) return;

    // 走完整的「后端登出 + 三方 signOut + 清本地」链路，
    // 避免出现「退了登录还能用旧 token」或「Google 自动续上同一账号」的问题。
    await AuthLogoutService.instance.logout();

    Analytics.instance.logEvent(Ev.logout);
    // 清除 user_id，后续事件不再归属该用户，避免数据串号。
    Analytics.instance.setUserId(null);

    if (!mounted) return;
    context.goNamed('login');
  }

  String _deleteAccountText(String key) {
    final lang = languageController.locale.value.languageCode;
    final zh = {
      'title': '注销账号',
      'message': '注销后账号资料将被删除或匿名化，当前登录状态会立即失效。历史订单等依法需保留的数据会按隐私政策继续保存。是否继续？',
      'confirm': '确认注销',
      'success': '账号已注销',
      'failed': '注销失败，请稍后重试',
    };
    final ja = {
      'title': 'アカウントを削除',
      'message': '削除後、アカウント情報は削除または匿名化され、現在のログイン状態は直ちに無効になります。法令上保持が必要な注文履歴等はプライバシーポリシーに従って保持されます。続行しますか？',
      'confirm': '削除する',
      'success': 'アカウントを削除しました',
      'failed': '削除に失敗しました。しばらくしてから再度お試しください',
    };
    final en = {
      'title': 'Delete Account',
      'message': 'After deletion, your account profile will be deleted or anonymized and your current session will be invalidated. Data that must be retained for legal reasons, such as order history, will be kept according to the Privacy Policy. Continue?',
      'confirm': 'Delete',
      'success': 'Account deleted',
      'failed': 'Failed to delete account. Please try again later.',
    };
    final source = lang == 'zh' ? zh : (lang == 'en' ? en : ja);
    return source[key] ?? key;
  }

  Future<void> _handleDeleteAccount() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade500, Colors.red.shade700],
                    ),
                    borderRadius: BorderRadius.circular(36.r),
                  ),
                  child: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.white,
                    size: 38.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  _deleteAccountText('title'),
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  _deleteAccountText('message'),
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          S.of(context).user_cancel,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          _deleteAccountText('confirm'),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ApiRequest().request<Object?>(
        path: '/user/deleteAccount',
        method: 'POST',
        fromJsonT: (_) => null,
      );
      // 后端注销后再走一遍统一登出链路：清三方 signOut 缓存 + 本地 token。
      await AuthLogoutService.instance.logout();
      Analytics.instance.setUserId(null);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_deleteAccountText('success'))),
      );
      context.goNamed('login');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_deleteAccountText('failed'))),
      );
    }
  }

  void _showLanguageSheet(BuildContext context) {
    final currentCode = languageController.locale.value.languageCode;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCDEE0),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                    child: Text(
                      S.of(context).user_language,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323233),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h + MediaQuery.of(sheetContext).padding.bottom),
                    child: Column(
                      children: languageController.lang.map((el) {
                        final code = el['code'] as String;
                        final name = el['name'] as String;
                        final selected = code == currentCode;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(sheetContext);
                                languageController.changeLanguage(code);
                                updateLangName();
                              },
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: selected ? const Color(0xFF1989FA).withValues(alpha: 0.08) : const Color(0xFFF7F8FA),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: selected ? const Color(0xFF1989FA) : const Color(0xFFEBEDF0),
                                    width: selected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.language_outlined,
                                      size: 24.sp,
                                      color: selected ? const Color(0xFF1989FA) : const Color(0xFF646566),
                                    ),
                                    SizedBox(width: 14.w),
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 28.sp,
                                          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                                          color: const Color(0xFF323233),
                                        ),
                                      ),
                                    ),
                                    if (selected)
                                      Icon(Icons.check_circle_rounded, size: 24.sp, color: const Color(0xFF1989FA)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> getData() async {
    try {
      final res = await ApiRequest().request<UserDetailResponse>(
        path: '/user/detail',
        method: 'GET',
        fromJsonT: (json) {
          return UserDetailResponse.fromJson(json);
        },
      );
      if (!mounted) return;
      if (res.data != null) {
        setState(() {
          data = res.data!;
        });
      }
    } catch (_) {
      if (mounted) setState(() {});
    }
  }
  @override
  void initState() {
    super.initState();
    getData();
    updateLangName();
    _getCurrentVersion();
    _silentVersionCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: RefreshIndicator(
        color: const Color(0xFF1989FA),
        onRefresh: () async {
          await getData();
          await _getCurrentVersion();
          await _silentVersionCheck();
          updateLangName();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
          // 自定义AppBar
          SliverAppBar(
            expandedHeight: 260.h,
            floating: false,
            pinned: true,
            // 底部 Tab「我的」是根页面，不应出现返回键；避免登录后 push 栈残留时显示黑色返回箭头。
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF1E40AF),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3B82F6), // blue-500
                      Color(0xFF1E40AF), // blue-800
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // 装饰光晕：右上 + 左下
                    Positioned(
                      top: -60.h,
                      right: -50.w,
                      child: Container(
                        width: 240.w,
                        height: 240.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -80.h,
                      left: -60.w,
                      child: Container(
                        width: 220.w,
                        height: 220.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 头像 + 用户名 + 邮箱
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildAvatar(),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        data.name ?? S.of(context).user_title,
                                        style: TextStyle(
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 0.3,
                                          height: 1.15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if ((data.email ?? '').isNotEmpty) ...[
                                        SizedBox(height: 6.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.mail_outline_rounded,
                                              size: 22.sp,
                                              color: Colors.white.withValues(alpha: 0.75),
                                            ),
                                            SizedBox(width: 6.w),
                                            Flexible(
                                              child: Text(
                                                data.email!,
                                                style: TextStyle(
                                                  fontSize: 22.sp,
                                                  color: Colors.white.withValues(alpha: 0.85),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            // 元信息 chip 行（注册时间 + 第三方登录绑定）
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                if ((data.createTime ?? '').isNotEmpty)
                                  _buildHeaderChip(
                                    leading: Icon(
                                      Icons.schedule_rounded,
                                      size: 22.sp,
                                      color: Colors.white,
                                    ),
                                    label: _formatRegisterDate(data.createTime!),
                                  ),
                                if (data.oauthBindings != null &&
                                    data.oauthBindings!.isNotEmpty)
                                  ...data.oauthBindings!
                                      .map((b) => _buildProviderChip(b.provider ?? '')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 内容区域
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  // 统计卡片
                  _buildStatsCard(),
                  
                  SizedBox(height: 20.h),
                  
                  // 功能菜单
                  _buildMenuSection(),
                  
                  SizedBox(height: 20.h),
                  
                  // 设置菜单
                  _buildSettingsSection(),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
  /// 顶部「订单数」数据卡片。
  /// 渐变深色块 + 左侧大图标 + 右侧大号数字与标签，整体更现代。
  Widget _buildStatsCard() {
    return _buildStatTile(
      icon: Icons.receipt_long_rounded,
      label: S.of(context).user_data_orderCount,
      value: data.orderCount ?? 0,
      gradient: const LinearGradient(
        colors: [Color(0xFF1989FA), Color(0xFF069EF0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      onTap: () => context.pushNamed('orderList'),
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required String label,
    required int value,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    final shadowColor = gradient is LinearGradient
        ? gradient.colors.first.withValues(alpha: 0.35)
        : Colors.black.withValues(alpha: 0.12);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: Stack(
              children: [
                // 装饰光晕
                Positioned(
                  top: -40.h,
                  right: -30.w,
                  child: Container(
                    width: 180.w,
                    height: 180.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60.h,
                  right: 40.w,
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 顶部：icon + label + 圆形箭头
                      Row(
                        children: [
                          Container(
                            width: 76.sp,
                            height: 76.sp,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            child: Icon(icon, color: Colors.white, size: 40.sp),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Container(
                            width: 56.sp,
                            height: 56.sp,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 28.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 22.h),
                      // 底部：大数字
                      Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Text(
                          '$value',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 64.sp,
                            fontWeight: FontWeight.w800,
                            height: 1,
                            fontFamily: 'Poppins',
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
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
  }

  // 功能菜单部分
  Widget _buildMenuSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModernListTile(
            icon: Icons.credit_card_rounded,
            iconColor: const Color(0xFF3B82F6), // blue-500
            title: S.of(context).user_creditCard,
            onTap: () => context.pushNamed('selectCreditCard'),
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF8B5CF6), // violet-500
            title: S.of(context).user_editProfile,
            onTap: () {
              context.pushNamed('userProfile', queryParameters: {
                'id': data.id.toString(),
              });
            },
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.translate_rounded,
            iconColor: const Color(0xFF10B981), // emerald-500
            title: S.of(context).user_language,
            trailing: langName,
            onTap: () => _showLanguageSheet(context),
          ),
          _buildDivider(),
          _buildTimeFormatTile(),
        ],
      ),
    );
  }

  /// 24h / 30h 切换行：行内 segmented，点击单段或整行都可切换。
  Widget _buildTimeFormatTile() {
    return Obx(() {
      final use30 = timeFormatController.use30HourFormat.value;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => timeFormatController.toggle(),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 64.sp,
                  height: 64.sp,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.schedule_rounded,
                    color: const Color(0xFFF59E0B),
                    size: 32.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).user_timeFormat,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        use30
                            ? S.of(context).user_timeFormat_subtitle_30h
                            : S.of(context).user_timeFormat_subtitle_24h,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey.shade500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                _buildTimeFormatSegmented(use30),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTimeFormatSegmented(bool use30) {
    const primary = Color(0xFF1989FA);
    Widget segment({required String label, required bool selected, required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: selected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          segment(
            label: S.of(context).user_timeFormat_24h,
            selected: !use30,
            onTap: () => timeFormatController.setUse30HourFormat(false),
          ),
          segment(
            label: S.of(context).user_timeFormat_30h,
            selected: use30,
            onTap: () => timeFormatController.setUse30HourFormat(true),
          ),
        ],
      ),
    );
  }

  /// 「检查更新」右侧：加载中显示小圈；有新版本时展示最新版本号、可选包大小、当前版本。
  Widget _buildUpdateCheckTrailing() {
    final cur = currentVersion.isNotEmpty ? currentVersion : '1.0.0';
    if (isCheckingUpdate) {
      return SizedBox(
        width: 160.w,
        height: 32.h,
        child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 22.w,
            height: 22.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ),
      );
    }

    final check = _versionCheckResult;
    final need = check?.needUpdate == true;
    final latestRaw = check?.latestVersion?.trim();
    final hasNew = need == true;

    if (hasNew) {
      final size = check!.packageSizeDisplay?.trim();
      final force = check.forceUpdate == true;
      final latestLine = (latestRaw != null && latestRaw.isNotEmpty)
          ? latestRaw
          : S.of(context).user_updateToLatestHint;
      const highlightBlue = Color(0xFF1989FA);
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 220.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.new_releases_rounded,
                  size: 24.sp,
                  color: const Color(0xFFFF9800),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.rocket_launch_rounded,
                  size: 24.sp,
                  color: highlightBlue,
                ),
                SizedBox(width: 6.w),
                if (force) ...[
                  Icon(
                    Icons.priority_high_rounded,
                    size: 24.sp,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: 4.w),
                ],
                Flexible(
                  child: Text(
                    latestLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: highlightBlue,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            if (size != null && size.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: Text(
                      size,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 4.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.smartphone_rounded,
                  size: 14.sp,
                  color: Colors.grey.shade500,
                ),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    '${S.of(context).user_currentVersion}: $cur',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: 120.w,
      height: 28.h,
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          cur,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 22.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  // 设置菜单部分
  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModernListTile(
            icon: Icons.description_outlined,
            iconColor: const Color(0xFF6366F1), // indigo-500
            title: S.of(context).user_userTerms,
            onTap: () => context.pushNamed(
              'agreement',
              pathParameters: {'code': 'USER_TERMS'},
            ),
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.privacy_tip_outlined,
            iconColor: const Color(0xFF6366F1), // indigo-500
            title: S.of(context).user_privateAgreement,
            onTap: () => context.pushNamed(
              'agreement',
              pathParameters: {'code': 'PRIVACY_POLICY'},
            ),
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.extension_outlined,
            iconColor: const Color(0xFF6366F1), // indigo-500
            title: S.of(context).user_thirdPartySdk,
            onTap: () => context.pushNamed(
              'agreement',
              pathParameters: {'code': 'THIRD_PARTY_SDK'},
            ),
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.system_update_rounded,
            iconColor: const Color(0xFF06B6D4), // cyan-500
            title: S.of(context).user_checkUpdate,
            trailing: _buildUpdateCheckTrailing(),
            onTap: _checkUpdate,
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.info_outline_rounded,
            iconColor: const Color(0xFF64748B), // slate-500
            title: S.of(context).user_about,
            onTap: () => context.pushNamed('about'),
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.no_accounts_outlined,
            iconColor: const Color(0xFFEF4444), // red-500
            title: _deleteAccountText('title'),
            textColor: const Color(0xFFB91C1C), // red-700
            onTap: _handleDeleteAccount,
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.logout_rounded,
            iconColor: const Color(0xFFEF4444), // red-500
            title: S.of(context).user_logout,
            textColor: const Color(0xFFEF4444),
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildModernListTile({
    required IconData icon,
    required String title,
    dynamic trailing,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    Color? iconBgColor,
  }) {
    // iconColor 优先用入参，其次跟 textColor（用于危险动作），最后用默认深灰
    final resolvedIconColor =
        iconColor ?? textColor ?? const Color(0xFF374151);
    // iconBgColor 不传时自动用 iconColor 的 12% 透明度做柔和底色
    final resolvedIconBg = iconBgColor ?? resolvedIconColor.withValues(alpha: 0.12);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                width: 64.sp,
                height: 64.sp,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: resolvedIconBg,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  icon,
                  color: resolvedIconColor,
                  size: 32.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? const Color(0xFF111827),
                  ),
                ),
              ),
              if (trailing != null) ...[
                trailing is String
                  ? Text(
                      trailing,
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    )
                  : trailing as Widget,
                SizedBox(width: 10.w),
              ],
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18.sp,
                color: const Color(0xFFC0C4CC),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 分割线
  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      height: 1.h,
      color: Colors.grey.shade200,
    );
  }

  /// 注册时间格式化：日期 + 时分秒
  /// - zh / ja: 2024年05月24日 13:15:53
  /// - en: May 24, 2024 13:15:53
  ///   (DateFormat 不带 locale 参数时默认 fallback 到 en_US；如 MMM 解析失败再退到纯数字)
  String _formatRegisterDate(String raw) {
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'en') {
      try {
        return DateFormat('MMM d, yyyy HH:mm:ss').format(dt);
      } catch (_) {
        return DateFormat('MM/dd/yyyy HH:mm:ss').format(dt);
      }
    }
    return DateFormat('yyyy年MM月dd日 HH:mm:ss').format(dt);
  }

  /// 头像：白色细描边 + 柔和光晕，让头像在蓝底上更突出
  Widget _buildAvatar() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.95),
            Colors.white.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 52.w,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: _avatarUrl() != null
            ? NetworkImage(_avatarUrl()!)
            : null,
        // 无头像（如 X 登录未设头像）时用「用户名首字母 + 渐变圆」兜底，比灰色图标更好看。
        child: _avatarUrl() == null ? _buildAvatarFallback() : null,
      ),
    );
  }

  /// 解析头像地址：第三方登录（X / Google）返回绝对 URL，直接用；
  /// 自托管头像是相对路径，需拼接 [Config.imageBaseUrl]。空则返回 null。
  String? _avatarUrl() {
    final cover = data.cover;
    if (cover == null || cover.isEmpty) return null;
    if (cover.startsWith('http://') || cover.startsWith('https://')) {
      return cover;
    }
    return '${Config.imageBaseUrl}$cover';
  }

  /// 默认头像：取用户名（或邮箱）首字母，配渐变圆底。
  Widget _buildAvatarFallback() {
    final source = (data.name?.trim().isNotEmpty ?? false)
        ? data.name!.trim()
        : (data.email?.trim() ?? '');
    final initial = source.isNotEmpty ? source.characters.first.toUpperCase() : '?';
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF1989FA), Color(0xFF63B3FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 52.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 通用 header chip 外壳：半透明白底 + 白描边 + leading + 文字
  Widget _buildHeaderChip({required Widget leading, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.32), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  /// 一个 provider 的小 chip：左 icon + 右文字（复用 _buildHeaderChip 外壳）
  Widget _buildProviderChip(String provider) {
    final meta = _providerMeta(provider);
    final leading = meta.assetPath != null
        ? SvgPicture.asset(
            meta.assetPath!,
            width: 22.sp,
            height: 22.sp,
            colorFilter: meta.tintWhite
                ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                : null,
          )
        : Icon(Icons.link, size: 20.sp, color: Colors.white);
    return _buildHeaderChip(leading: leading, label: meta.label);
  }

  _ProviderMeta _providerMeta(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        // Google 多色 logo 保持原色（tintWhite=false），背景半透明白做衬底。
        return const _ProviderMeta(
          label: 'Google',
          assetPath: 'assets/icons/social/google.svg',
          tintWhite: false,
        );
      case 'apple':
        // Apple logo 是纯黑形状，强制染白才能在蓝底上看清。
        return const _ProviderMeta(
          label: 'Apple',
          assetPath: 'assets/icons/social/apple.svg',
          tintWhite: true,
        );
      case 'x':
      case 'twitter':
        return const _ProviderMeta(
          label: 'X',
          assetPath: 'assets/icons/social/x.svg',
          tintWhite: true,
        );
      default:
        return _ProviderMeta(label: provider, assetPath: null, tintWhite: true);
    }
  }

}

/// 第三方登录来源 chip 的展示元数据。
class _ProviderMeta {
  final String label;
  final String? assetPath;

  /// 是否把 SVG 染白（Apple/X 的单色 logo 在蓝色 header 上需要染白才看得清；
  /// Google 是彩色 logo，保持原色）。
  final bool tintWhite;

  const _ProviderMeta({
    required this.label,
    required this.assetPath,
    required this.tintWhite,
  });
}
