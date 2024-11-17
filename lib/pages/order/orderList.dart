import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<OrderList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
         title: Text('订单列表', style: TextStyle(color: Colors.white)),
      ),
      body: EasyRefresh(
        header: const ClassicHeader(),
        footer: const ClassicFooter(),
        // onRefresh: _onRefresh,
        // onLoad: _onLoad,
        child: ListView.builder(
          // physics: physics,
          shrinkWrap: true,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300)
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('订单号：123456789123456789', style: TextStyle(fontSize: 28.sp)),
                        const Text('订单已完成')
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: ExtendedImage.asset(
                            'assets/image/raligun.webp',
                            width: 250.w,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 295.h,
                          // decoration: BoxDecoration(
                          //   border: Border.all()
                          // ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                        "鬼灭之刃 无线城篇",
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                        ),
                                        overflow: TextOverflow.ellipsis
                                      ),
                                      )
                                      
                                    ],
                                  ),
                                  
                                  SizedBox(height: 8.h),
                                  Text(
                                    "11月16日（土）10：00 ~ 14：00 IMAX",
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    "東宝シネマズ　新宿（スクリーン8）",
                                    style: TextStyle(fontSize: 24.sp, color: Colors.grey.shade600),
                                  ),
                                  Wrap(
                                  spacing: 8.w,
                                    children: ['C-12', 'C-22 ', 'C-23 ', 'C-23','C-23','C-23'].map((item) {
                                      return Container(
                                        // width: double.,
                                        height: 40.h,
                                        margin: EdgeInsets.only(top: 10.h),
                                        // padding: EdgeInsets.only(bottom: 10.h),
                                        // child: Text(item),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            minimumSize: WidgetStateProperty.all(Size(0, 50.h)),
                                            textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20.sp)),
                                            side: WidgetStateProperty.all(const BorderSide(width: 2, color: Color(0xffffffff))),
                                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0)),
                                            shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20.0), // 调整圆角大小
                                              ), 
                                            ),
                                          ),
                                          onPressed: () {},
                                          child: Text(item),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('7500円', style: TextStyle(color: Colors.red, fontSize: 40.sp)),
                                      // Text('円', style: TextStyle(color: Colors.red, fontSize: 32.sp))
                                    ],
                                  ),
                                  SizedBox(width: 16.w),
                                  SizedBox(
                                    width: 120.w,
                                    height: 50.h,                  
                                    child: MaterialButton(
                                      // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      color: const Color.fromARGB(255, 2, 162, 255),
                                      textColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                      ),
                                      onPressed: () {
                                        // context.goNamed('commentDetail');
                                      },
                                      child: Text(
                                        '评价',
                                        style: TextStyle(color: Colors.white, fontSize: 28.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
