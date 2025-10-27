import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/user/user_detail_response.dart';
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
  
  void updateLangName () {
    Map<String, String> lang = languageController.lang.firstWhere(
      (el) => el['code'] == languageController.locale.value.languageCode,
      orElse: () => {'code': 'ja', 'name': '日本語'});

    setState(() {
      langName = '${lang['name']}';
    });
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
      // 这里可以调用API检查更新
      // 模拟检查过程
      await Future.delayed(const Duration(seconds: 2));
      
      // 显示更新对话框
      _showUpdateDialog();
    } catch (e) {
      // 显示错误提示
      _showErrorDialog();
    } finally {
      setState(() {
        isCheckingUpdate = false;
      });
    }
  }

  // 显示更新对话框
  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题图标和文字
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Icon(
                    Icons.system_update,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  S.of(context).user_checkUpdate,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  S.of(context).user_updateAvailable,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                
                // 版本信息卡片
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).user_currentVersion,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            currentVersion,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).user_latestVersion,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '1.1.0',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                
                // 按钮
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          S.of(context).user_cancel,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showUpdateProgress();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
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
                            Icon(Icons.download, size: 18.sp),
                            SizedBox(width: 4.w),
                            Text(
                              S.of(context).user_update,
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
              ],
            ),
          ),
        );
      },
    );
  }

  // 显示更新进度
  void _showUpdateProgress() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                  Colors.grey.shade50,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 进度图标
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                      Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  S.of(context).user_updating,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  S.of(context).user_updateProgress,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                
                // 进度条
                Container(
                  width: double.infinity,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // 模拟更新过程
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();
      _showUpdateSuccess();
    });
  }

  // 显示更新成功
  void _showUpdateSuccess() {
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
                  Colors.green.shade50,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 成功图标
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                    ),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  S.of(context).user_updateSuccess,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  S.of(context).user_updateSuccessMessage,
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
                      backgroundColor: Colors.green.shade600,
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
                        Icon(Icons.check, size: 18.sp),
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
  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: languageController.lang.map((el) {
            return ListTile(
              title: Center(
                child: Text('${el['name']}'),
              ),
              onTap: () {
                Navigator.pop(context);
                languageController.changeLanguage(el['code'] as String);
                updateLangName();
                // Implement your action here
              },
            );
          }).toList()
        );
      },
    );
  }
  getData () {
    ApiRequest().request(
      path: '/user/detail',
      method: 'GET',
      fromJsonT: (json) {
        return UserDetailResponse.fromJson(json);
      },
    ).then((res) async {
      if (res.data != null) {
        setState(() {
          data = res.data!;
        });
      }
    });
  }
  @override
  void initState() {
    super.initState();
    getData();
    updateLangName();
    _getCurrentVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
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
                                    color: Colors.black.withOpacity(0.1),
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
                                      color: Colors.white.withOpacity(0.2),
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
            color: Colors.black.withOpacity(0.05),
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.2)),
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
            color: Colors.black.withOpacity(0.05),
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
            onTap: () => _showActionSheet(context),
          ),
        ],
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
            color: Colors.black.withOpacity(0.05),
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
            icon: isCheckingUpdate ? Icons.hourglass_empty : Icons.system_update,
            title: S.of(context).user_checkUpdate,
            trailing: isCheckingUpdate 
                ? CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))
                : Text(currentVersion.isNotEmpty ? currentVersion : '1.0.0'),
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
