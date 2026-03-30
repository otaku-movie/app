import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/app_version_check_response.dart';
import 'package:otaku_movie/response/user/user_detail_response.dart';
import 'package:otaku_movie/service/version_check_service.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _PageState();
}

class _PageState extends State<UserInfo> {
  final LanguageController languageController = Get.find();
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
            expandedHeight: 280.h,
            floating: false,
            pinned: true,
            backgroundColor: Colors.blue.shade600,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade600,
                      Colors.blue.shade800,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 用户头像和基本信息
                        Row(
                          children: [
                            // 头像
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50.w,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: data.cover != null 
                                  ? NetworkImage('${Config.imageBaseUrl}${data.cover}')
                                  : null,
                                child: data.cover == null 
                                  ? Icon(Icons.person, size: 50.sp, color: Colors.grey.shade600)
                                  : null,
                              ),
                            ),
                            SizedBox(width: 20.w),
                            // 用户信息
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name ?? S.of(context).user_title,
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    data.email ?? '',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  // 注册时间
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      '${S.of(context).user_registerTime}: ${data.createTime ?? ''}',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
  // 统计卡片
  Widget _buildStatsCard() {
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
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).user_data_orderCount,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.receipt_long,
                    title: S.of(context).user_data_orderCount,
                    value: '${data.orderCount ?? 0}',
                    color: Colors.blue,
                    onTap: () => context.pushNamed('orderList'),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.movie,
                    title: S.of(context).user_data_watchHistory,
                    value: '${data.orderCount ?? 0}',
                    color: Colors.green,
                    onTap: () => context.pushNamed('orderList'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 统计项目
  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
            icon: Icons.edit,
            title: S.of(context).user_editProfile,
            onTap: () {
              context.pushNamed('userProfile', queryParameters: {
                'id': data.id.toString(),
              });
            },
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.language,
            title: S.of(context).user_language,
            trailing: langName,
            onTap: () => _showLanguageSheet(context),
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
            icon: Icons.privacy_tip,
            title: S.of(context).user_privateAgreement,
            onTap: () => launchURL('https://www.google.com'),
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.system_update,
            title: S.of(context).user_checkUpdate,
            trailing: _buildUpdateCheckTrailing(),
            onTap: _checkUpdate,
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.info_outline,
            title: S.of(context).user_about,
            onTap: () => context.pushNamed('about'),
          ),
          _buildDivider(),
          _buildModernListTile(
            icon: Icons.logout,
            title: S.of(context).user_logout,
            textColor: Colors.red,
            onTap: () {},
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
  }) {
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
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: textColor ?? Colors.grey.shade600,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? Colors.grey.shade800,
                  ),
                ),
              ),
              if (trailing != null) ...[
                trailing is String 
                  ? Text(
                      trailing,
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.grey.shade600,
                      ),
                    )
                  : trailing as Widget,
                SizedBox(width: 8.w),
              ],
              Icon(
                Icons.arrow_forward_ios,
                size: 16.sp,
                color: Colors.grey.shade400,
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

  Widget _buildListTile({
    IconData? icon,
    required dynamic title,
    dynamic trailing,
    required GestureTapCallback onTap,
    bool showArrow = true, // ✅ 控制是否显示箭头
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)),
      ),
      child: ListTile(
        leading: icon != null
            ? Icon(icon, color: Colors.grey.shade500)
            : const SizedBox(width: 24), // ✅ 占位保持对齐
        title: title is String
            ? Text(title, style: TextStyle(fontSize: 24.sp))
            : title as Widget,
        trailing: trailing != null
            ? trailing is String
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(trailing, style: TextStyle(fontSize: 22.sp)),
                      if (showArrow) ...[
                        SizedBox(width: 8.w),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ],
                  )
                : trailing as Widget
            : (showArrow
                ? const Icon(Icons.arrow_forward_ios, size: 16)
                : null),
        onTap: onTap,
      ),
    );
  }

}
