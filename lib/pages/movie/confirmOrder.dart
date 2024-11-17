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

class ConfirmOrder extends StatefulWidget {
  const ConfirmOrder({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<ConfirmOrder> {
  List<Map<String, dynamic>> pay  = [
    {
      "path": 'assets/icons/pay/paypay.svg',
      "name": 'paypay'
    },
    {
      "path": 'assets/icons/pay/amazon pay.svg',
      "name": 'amazon pay'
    }
  ];
  
  int countDown = 15 * 60;
  int allTime = 15 * 60;
  Timer? _timer;


  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown <= 0) {
        _timer?.cancel();  // 取消计时器
      }
      
      setState(() {
        countDown--;
      });

    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
         title: Text('确认订单', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: ExtendedImage.asset(
                              'assets/image/raligun.webp',
                              width: 200.w,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 285.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "鬼灭之刃 无线城篇",
                                          style: TextStyle(
                                            fontSize: 28.sp,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, size: 36.sp, color: Colors.red),
                                            Text(
                                              formatNumberToTime(countDown),
                                              style: TextStyle(
                                                fontSize: 28.sp,
                                                color: Colors.red
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 8.h),
                                    Text(
                                      "11月16日（土）10：00~14：00 IMAX",
                                      style: TextStyle(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.bold
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                    
                                  ],
                                ),
                                Text(
                                  "東宝シネマズ　新宿（スクリーン8）",
                                  style: TextStyle(fontSize: 24.sp, color: Colors.grey.shade600),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    spacing: 6,
                                    children: ['C-1（一般）', 'C-2 （一般）', 'C-3 （一般）'].map((item) {
                                      return ElevatedButton(
                                        style: ButtonStyle(
                                          minimumSize: WidgetStateProperty.all(Size(0, 50.h)),
                                          textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20.sp)),
                                          side: WidgetStateProperty.all(const BorderSide(width: 2, color: Color(0xffffffff))),
                                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0)),
                                          shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0), // 调整圆角大小
                                            ), 
                                          ),
                                        ),
                                        
                                        onPressed: () {},
                                        child: Text(item),
                                      );
                                    }).toList(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
                      child: const Text('选择支付方式', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    
                    ...pay.map((item) {
                      return  Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200)
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(item['path'], height: 28),
                            const Icon(Icons.radio_button_checked, color: Colors.blue)
                          ],
                        ) 
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade100, width: 1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('合计：', style: TextStyle(fontSize: 28.sp)),
                    Text('7500円', style: TextStyle(color: Colors.red, fontSize: 48.sp)),
                    // Text('円', style: TextStyle(color: Colors.red, fontSize: 32.sp))
                  ],
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  width: 250.w,                  
                  child: MaterialButton(
                    color: const Color.fromARGB(255, 2, 162, 255),
                    textColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    onPressed: () {
                      context.go('/movie/order/success');
                    },
                    child: Text(
                      '确认订单',
                      style: TextStyle(color: Colors.white, fontSize: 32.sp),
                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
