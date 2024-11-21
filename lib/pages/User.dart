import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../components/CustomAppBar.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _PageState();
}

class _PageState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Home Page', style: TextStyle(color: Colors.white)),
        showBackButton: false,
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24.sp),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.w), // 统一的内边距
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 用户信息部分，使用 Card 组件
              Card(
                margin: EdgeInsets.only(bottom: 16.h),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      // 用户头像
                      CircleAvatar(
                        radius: 60.w, // 根据屏幕调整头像大小
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: const NetworkImage('https://example.com/image.jpg'),
                      ),
                      SizedBox(width: 20.w),
                      // 用户信息文本
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last Order', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8.h),
                          Text('123456@gmail.com', style: TextStyle(color: Colors.grey.shade500, fontSize: 20.sp)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // 统计信息部分的网格布局
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard("Orders", "1", Colors.purple, () {
                      context.goNamed('orderList');
                    }),
                    _buildStatCard("To Watch", "1", Colors.orange, () {}),
                    _buildStatCard("Voice Actors", "1", Colors.blue, () {}),
                    _buildStatCard("Staff", "1", Colors.green, () {}),
                  ],
                ),
              ),
              // 设置项的列表
              _buildListTile(Icons.language, 'Language', '简体中文', () {}),
              _buildListTile(Icons.edit, 'Edit Profile', null, () {}),
              _buildListTile(Icons.privacy_tip, 'Privacy Agreement', null, () {}),
              _buildListTile(Icons.check, 'Check for Updates', '1.0.0', () {}),
              _buildListTile(Icons.info_outline, 'About', null, () {}),
              _buildListTile(Icons.logout, 'Logout', null, () {}),
            ],
          ),
        ),
      ),
    );
  }

  // 创建统计卡片的辅助方法
  Widget _buildStatCard(String title, String count, Color color, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 24.sp)),
            Text(count, style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // 创建 ListTile 的辅助方法
  Widget _buildListTile(IconData icon, String title, String? trailingText, GestureTapCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade500),
        title: Text(title, style: TextStyle(fontSize: 24.sp)),
        trailing: trailingText != null
            ? Text(trailingText, style: TextStyle(fontSize: 22.sp))
            : Icon(Icons.arrow_forward_ios, size: 24.sp),
        onTap: onTap,
      ),
    );
  }
}
