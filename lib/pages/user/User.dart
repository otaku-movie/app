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
  
  void updateLangName () {
    Map<String, String> lang = languageController.lang.firstWhere(
      (el) => el['code'] == languageController.locale.value.languageCode,
      orElse: () => {'code': 'ja', 'name': '日本語'});

    setState(() {
      langName = '${lang['name']}';
    });
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
            icon: Icons.check,
            title: S.of(context).user_checkUpdate,
            trailing: '1.0.0',
            onTap: () {},
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
    String? trailing,
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
                Text(
                  trailing,
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
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
