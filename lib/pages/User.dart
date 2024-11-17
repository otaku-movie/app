import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/pages/movie/confirmOrder.dart';

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
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // direction: Axis.horizontal,
            children: [
              // 用户信息
              Padding(
                padding: const EdgeInsets.all(15),
                child:  Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: 140.w,
                      height: 140.w,
                      margin: EdgeInsets.only(right: 20.w),
                      child:  CircleAvatar(
                        radius: 50.0, // 半径
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: const NetworkImage('https://example.com/image.jpg'),
                      ),
                    ),
                    Wrap(
                      direction: Axis.vertical,
                      children: [
                        Text('last order', style: TextStyle(fontSize: 36.sp)),
                        Text('123456@gmail.com', style: TextStyle(color: Colors.grey.shade500, fontSize: 24.sp))
                      ],
                    )
                  ],
                ), 
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: GridView.count(
                  crossAxisCount: 4, // 一行 4 个
                  crossAxisSpacing: 10, // 列间距
                  mainAxisSpacing: 10, // 行间距
                  shrinkWrap: true, // 内容包裹，防止占满父容器
                  physics: const NeverScrollableScrollPhysics(), // 禁用滚动
                  children: [
                    {
                      "name": "订单数",
                      "count": "1",
                      "color": const Color.fromARGB(255, 143, 8, 239),
                      "onTap": () {
                        context.goNamed('orderList');
                      }
                    },
                    {
                      "name": "想看数",
                      "count": "1",
                      "color": const Color.fromARGB(255, 143, 8, 239),
                      "onTap": () {}
                    },
                    {
                      "name": "声优",
                      "count": "1",
                      "color": const Color.fromARGB(255, 143, 8, 239),
                      "onTap": () {}
                    },
                    {
                      "name": "演职员",
                      "count": "1",
                      "color": const Color.fromARGB(255, 143, 8, 239),
                      "onTap": () {}
                    }
                  ].map((item) {
                    return GestureDetector(
                      onTap: item['onTap'] as GestureTapCallback,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: item['color'] as Color,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(item['name'] as String, style: TextStyle(color: Colors.white, fontSize: 36.sp)),
                            Text('89', style: TextStyle(color: Colors.white, fontSize: 44.sp))
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )
              ),
              
              // Padding(padding: EdgeInsets.only(top: 30.h)),
              // 一些设置
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.0), // 底部边框
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.language, color: Colors.grey.shade500), // 左边图标
                  title: const Text('语言'), // 标题
                  trailing: Text('简体中文', style: TextStyle(fontSize: 28.sp),), // 右边箭头
                  onTap: () {
                    // print('Tapped!');
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.0), // 底部边框
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.edit, color: Colors.grey.shade500), // 左边图标
                  title: const Text('修改用户信息'), // 标题
                  trailing: Icon(Icons.arrow_forward_ios, size: 32.sp), // 右边箭头
                  onTap: () {
                    // print('Tapped!');
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.0), // 底部边框
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.privacy_tip, color: Colors.grey.shade500), // 左边图标
                  title: const Text('用户隐私协议'), // 标题
                  trailing: Icon(Icons.arrow_forward_ios, size: 32.sp), // 右边箭头
                  onTap: () {
                    // print('Tapped!');
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.0), // 底部边框
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.check, color: Colors.grey.shade500), // 左边图标
                  title: const Text('检查新版本'), // 标题
                  trailing: Wrap(
                    // alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text('1.0.0', style: TextStyle(fontSize: 24.sp)),
                      Icon(Icons.arrow_upward, size: 44.sp),
                    ],
                  ),
                  onTap: () {
                    // print('Tapped!');
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1.0), // 底部边框
                  ),
                ),
                child: ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.grey.shade500), // 左边图标
                  title: const Text('关于'), // 标题
                  trailing: Icon(Icons.arrow_forward_ios, size: 32.sp), // 右边箭头
                  onTap: () {
                    // print('Tapped!');
                  },
                ),
              ),
              Container(
                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(color: Colors.grey.shade300, width: 1.0), // 底部边框
                //   ),
                // ),
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.grey.shade500), // 左边图标
                  title: const Text('退出登录'), // 标题
                  onTap: () {
                    // print('Tapped!');
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
