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

class PayError extends StatefulWidget {
  const PayError({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<PayError> {
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
         title: Text('支付失败', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Center(
                
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.h,
                  children: [
                      Icon(Icons.cancel, color: Colors.red, size: 200.sp),
                       Container(
                        margin: EdgeInsets.only(top: 50.h, bottom: 50.h),
                        child: Text('您的订单似乎遇到了一些问题，请稍后重试。', style: TextStyle(fontSize: 36.sp)),
                      ),
                      SizedBox(
                        width: 300.w,
                        height: 70.h,
                        child: MaterialButton(
                          // minWidth: double.infinity,
                          color: const Color.fromARGB(255, 2, 162, 255),
                          textColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          onPressed: () {
                            context.pushNamed('me');
                          },
                          child: Text(
                            '返回',
                            style: TextStyle(color: Colors.white, fontSize: 36.sp),
                          ),
                        ),
                      )
                      
                  ],
                )
              ),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Container(
              //       margin: EdgeInsets.only(right: 20.w),
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(4),
              //         child: ExtendedImage.asset(
              //           'assets/image/raligun.webp',
              //           width: 300.w,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Container(
              //         // height: 985.h,
              //         // decoration: BoxDecoration(
              //         //   border: Border.all()
              //         // ),
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
                          
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
                              
              //                 Row(
              //                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Flexible(
              //                       child: Text(
              //                       "鬼灭之刃 无线城篇",
              //                       style: TextStyle(
              //                         fontSize: 28.sp,
              //                       ),
              //                       overflow: TextOverflow.ellipsis
              //                     ),
              //                     )
                                  
              //                   ],
              //                 ),
                              
              //                 SizedBox(height: 8.h),
              //                 Text(
              //                   "11月16日（土）10：00 ~ 14：00 IMAX",
              //                   style: TextStyle(
              //                     fontSize: 32.sp,
              //                     fontWeight: FontWeight.bold
              //                   )
              //                 ),
                              
              //               ],
              //             ),
              //             Text(
              //               "東宝シネマズ　新宿（スクリーン8）",
              //               style: TextStyle(fontSize: 24.sp, color: Colors.grey.shade600),
              //             ),
              //             Wrap(
              //                 spacing: 8.w,
              //                 children: ['C-12', 'C-22 ', 'C-23 ', 'C-23','C-23 （学生）','C-23 （学生）'].map((item) {
              //                   return Container(
              //                     // width: double.,
              //                     height: 45.h,
              //                     margin: EdgeInsets.only(top: 14.h),
              //                     // padding: EdgeInsets.only(bottom: 10.h),
              //                     // child: Text(item),
              //                     child: ElevatedButton(
              //                       style: ButtonStyle(
              //                         minimumSize: WidgetStateProperty.all(Size(0, 50.h)),
              //                         textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20.sp)),
              //                         side: WidgetStateProperty.all(const BorderSide(width: 2, color: Color(0xffffffff))),
              //                         padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0)),
              //                         shape: WidgetStateProperty.all(
              //                           RoundedRectangleBorder(
              //                             borderRadius: BorderRadius.circular(20.0), // 调整圆角大小
              //                           ), 
              //                         ),
              //                       ),
              //                       onPressed: () {},
              //                       child: Text(item),
              //                     ),
              //                   );
              //                 }).toList(),

              //             // SingleChildScrollView(
              //             //   scrollDirection: Axis.horizontal,
              //             //   child: 
              //             //   ),
              //             ),
                          
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Center(
              //   child: Wrap(
              //     direction: Axis.vertical,
              //     // alignment: WrapAlignment.center,
              //     spacing: 10.h,
              //     crossAxisAlignment: WrapCrossAlignment.center,
              //     children: [
              //       Container(
              //         width: 450.w,
              //         margin: EdgeInsets.only(top: 50.h),
              //         child: PrettyQrView.data(
              //           data: 'https://www.bilibili.com',
              //           decoration: const PrettyQrDecoration(
              //             shape: PrettyQrSmoothSymbol(
              //               roundFactor: 0
              //             ),
              //             // image: PrettyQrDecorationImage(
              //             //   image: AssetImage('image/audio-guide.png'),
              //             // ),
              //           ),
              //         )
              //       ),
              //       Text('6张电影票', style: TextStyle(fontSize: 32.sp, color: Colors.grey.shade500)),
              //       Container(
              //         width: 600.w,
              //         height: 80.h,
              //         // padding: Edge,
              //         margin: EdgeInsets.only(top: 30.h),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(4),
              //           border: Border.all(color: Colors.grey.shade300)
              //         ),
              //         child: Center(child: Text('取票码：1234567890', style: TextStyle(fontSize: 40.sp))) 
              //       ),
              //     ],
              //   )
              // )
            ],
          ),
        ),
      )
    );
  }
}
