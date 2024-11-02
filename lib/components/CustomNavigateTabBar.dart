import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNavigateTabBar extends StatefulWidget {
  const CustomNavigateTabBar({super.key});

  @override
  _CustomNavigateTabBarState createState() => _CustomNavigateTabBarState();
}

class _CustomNavigateTabBarState extends State<CustomNavigateTabBar> {
  @override
  Widget build(BuildContext context) {
    // 使用 ScreenUtil 提供的扩展方法来设置高度
    // double height = 100.h;

    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w), // 添加水平填充
      color: Colors.blueAccent, // 设置背景色
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home,
              size: 48.sp, color: Colors.white), // 使用 ScreenUtil 提供的扩展方法设置图标大小
          Icon(Icons.search, size: 48.sp, color: Colors.white),
          Icon(Icons.notifications, size: 48.sp, color: Colors.white),
          Icon(Icons.account_circle, size: 48.sp, color: Colors.white),
        ],
      ),
    );
  }
}
