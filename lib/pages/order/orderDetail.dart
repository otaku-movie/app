import 'dart:async';

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

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<OrderDetail> {
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
         title: Text('订单详情', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 50.h),
                alignment: Alignment.center,
                child: Text('距离开始放映时间还有：4天05小时10分5秒', style: TextStyle(fontSize: 32.sp, color: Colors.red)),
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
                                        // context.pushNamed('commentDetail');
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
              Center(
                child: Wrap(
                  direction: Axis.vertical,
                  // alignment: WrapAlignment.center,
                  spacing: 10.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      width: 350.w,
                      margin: EdgeInsets.only(top: 50.h),
                      child: PrettyQrView.data(
                        data: 'https://www.bilibili.com',
                        decoration: const PrettyQrDecoration(
                          shape: PrettyQrSmoothSymbol(
                            roundFactor: 0
                          ),
                          // image: PrettyQrDecorationImage(
                          //   image: AssetImage('image/audio-guide.png'),
                          // ),
                        ),
                      )
                    ),
                    Text('6张电影票', style: TextStyle(fontSize: 32.sp, color: Colors.grey.shade500)),
                    Container(
                      width: 600.w,
                      height: 80.h,
                      // padding: Edge,
                      margin: EdgeInsets.only(top: 30.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Center(child: Text('取票码：1234567890', style: TextStyle(fontSize: 40.sp))) 
                    ),
                  ],
                )
              ),
              SizedBox(height: 50.h),
              Text('订单号：XXXXXXXXXXXXX', style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600)),
              Text('订单创建时间：XXXXXXXXXXXXX', style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600)),
              Text('支付时间：XXXXXXXXXXXXX', style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600)),
              Text('邮箱：XXXXXXXXXXXXX', style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600)),
            ],
          ),
        ),
      )
    );
  }
}
