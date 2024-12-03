import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';

class SelectMovieTicketType extends StatefulWidget {
  const SelectMovieTicketType({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SelectMovieTicketPageState createState() => _SelectMovieTicketPageState();
}

class _SelectMovieTicketPageState extends State<SelectMovieTicketType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
         title: Text('选择电影票类型', style: TextStyle(color: Colors.white)),
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
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: ExtendedImage.asset(
                              'assets/image/raligun.webp',
                              width: 240.w,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 285.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "鬼灭之刃 无线城篇",
                                      style: TextStyle(
                                        fontSize: 36.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      "11月16日（土）10：00~14：00 IMAX",
                                      style: TextStyle(
                                        fontSize: 28.sp,
                                        color: Colors.black45,
                                      ),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                                Text(
                                  "東宝シネマズ　新宿（スクリーン8）",
                                  style: TextStyle(fontSize: 26.sp),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.all(10),
                        child: Wrap(
                          runSpacing: 10,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('座位号：C8'),
                                Text('A区'),
                              ],
                            ),
                            MaterialButton(
                              minWidth: double.infinity,
                              color: Colors.blue,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                              onPressed: () {},
                              child: Text(
                                '请选择电影票类型',
                                style: TextStyle(color: Colors.white, fontSize: 32.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade100, width: 1)),
            ),
            child: MaterialButton(
              minWidth: double.infinity,
              color: Colors.blue,
              textColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              onPressed: () {
                context.go('/movie/confirmOrder');
              },
              child: Text(
                '确认订单',
                style: TextStyle(color: Colors.white, fontSize: 32.sp),
              ),
            )
          ),
        ],
      ),

      // body: SingleChildScrollView(
      //   child: Container(
      //     // width: double.infinity,
      //     padding: const EdgeInsets.all(10),
      //     child: Column(
      //       children: [
      //         Stack(
      //           children: [
      //             Positioned(
      //               bottom: 0,
      //               left: 0,
      //               child: Container(

      //                   decoration: BoxDecoration(
      //                   border: Border.all(color: Colors.red),
      //                 ),
      //                 child: Row(
      //                   children: [
      //                     Text('合计：7500')
      //                   ],
      //                 ),
      //               ),
      //             )
      //           ],
      //         ),
      //         Row(
      //           children: [
      //             Container(
      //               margin: EdgeInsets.only(right: 20.w),
      //               child: ClipRRect(
      //                 borderRadius: BorderRadius.circular(4),
      //                 child: ExtendedImage.asset(
      //                   'assets/image/raligun.webp',
      //                   width: 240.w,
      //                 ),
      //               ),
      //             ),
      //             Expanded(
      //               child: SizedBox(
      //                 height: 285.h,
      //                 // decoration: BoxDecoration(
      //                 //   border: Border.all(color: Colors.red),
      //                 // ),
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text(
      //                           "鬼灭之刃 无线城篇",
      //                           style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.bold),
      //                         ),
      //                         SizedBox(height: 8.h), // 增加间距
      //                         Text(
      //                           "11月16日（土）10：00~14：00 IMAX",
      //                           style: TextStyle(fontSize: 28.sp, color: Colors.black45),
      //                           softWrap: true,
      //                           overflow: TextOverflow.visible,
      //                         ),
      //                       ],
      //                     ),
      //                     Text(
      //                       "東宝シネマズ　新宿（スクリーン8）",
      //                       style: TextStyle(fontSize: 26.sp),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //         // Container(
      //         //   margin: EdgeInsets.symmetric(vertical: 20.h),
      //         //   child: Text('选择电影票的类型', style: TextStyle(fontSize: 32.sp)),
      //         // ),
      //         Padding(padding: EdgeInsets.only(top: 50.h)),
      //         ClipRRect(
      //           borderRadius: BorderRadius.circular(4),
      //           child: Container(
      //             width: double.infinity,
      //             color: Colors.grey.shade200,
      //             padding: const EdgeInsets.all(10),
      //               child: Wrap(
      //                 runSpacing: 10,
      //                 children: [
      //                   const Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Text('座位号：C8'),
      //                       Text('A区')
      //                     ],
      //                   ),
      //                   MaterialButton(
      //                     minWidth: double.infinity,
      //                     color: Colors.blue,
      //                     shape: const RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.all(
      //                             Radius.circular(50))),
      //                     onPressed: () {
      //                     },
      //                     child: Text(
      //                         '请选择电影票类型',
      //                         style: TextStyle(
      //                             color: Colors.white,
      //                             fontSize: 32.sp)),
      //                   )
      //                 ],
      //               ),
      //         ),
      //         ),
              
              
      //       ],
      //     )


      //   ),
      // ),
    );
  }
}
