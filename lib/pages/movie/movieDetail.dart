import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/rate.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<MovieDetail> {
  @override
  void initState() {
    super.initState();
    // 隐藏状态栏
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 设置状态栏背景为透明
      statusBarIconBrightness: Brightness.light, // 状态栏图标颜色为浅色
      statusBarBrightness: Brightness.dark, // 状态栏背景为深色
    ));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  List<Widget> generateComment() {
    return List.generate(10, (index) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200)
          )
        ),
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            margin: EdgeInsets.only(right: 20.w),
            child:  CircleAvatar(
              radius: 50.0, // 半径
              backgroundColor: Colors.grey.shade300,
              backgroundImage: const NetworkImage('https://example.com/image.jpg'),
            ),
          ),
          Container(
            width: 600.w,
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.red),
            // ),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 2.h,
              children: [
                 Container(
                  width: 600.w,
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('last order', style: TextStyle(
                      fontSize: 32.sp
                    ),),
                    Row(
                      children: [
                        // Icon(Icons.star),
                        Rate(
                          initialRating: 3.5, // 初始评分
                          maxRating: 5.0, // 最大评分
                          starSize: 35.w, // 星星大小
                          onRatingUpdate: (rating) {
                            print("当前评分：$rating");
                          },
                        ),
                        SizedBox(width: 10.w),
                        Text('9.8分', style: TextStyle(
                          fontSize: 40.sp,
                          color: Colors.yellow.shade700
                        ),)
                      ],
                    )
                    
                  ],
                ),
                ),
                
                Text('2分钟前', style: TextStyle(
                  color: Colors.grey.shade400
                ),),
                Container(
                  width: 600.w,
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text('这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容', maxLines: 5, overflow: TextOverflow.ellipsis,),
                ),
                // SizedBox(height: 5.h),
                Wrap(
                  spacing: 10.w,
                  children: [
                    Icon(Icons.thumb_up, color: Colors.grey.shade400, size: 36.sp),
                    Text('15888'),
                    Icon(Icons.thumb_down, color: Colors.grey.shade400, size: 36.sp),
                    Text('15888'),
                    Icon(Icons.comment, color: Colors.grey.shade400, size: 36.sp),
                    Text('回复'),
                    Icon(Icons.translate,  color: Colors.grey.shade400, size: 36.sp),
                    Text('翻译为日语')
                  ],
                ),
                Container(
                  width: 600.w,
                  padding: EdgeInsets.all(15.w),
                  margin: EdgeInsets.symmetric(vertical: 20.h),
                  decoration: BoxDecoration(
                    color: Color(0xFFe7e7e7),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AXXXX：这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容', maxLines: 10, overflow: TextOverflow.ellipsis,),
                      Text('AXXXX回复@last order：这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容这是个评论内容', maxLines: 10, overflow: TextOverflow.ellipsis,),
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child:  Text('总共100条回复', style: TextStyle(
                          color: Colors.grey.shade700
                        ),),
                      )
                     
                    ],
                  ),
                )
                
              ],
            ),
          )
          
        ],
      ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: const CustomAppBar(
      //    title: Text('鬼灭之刃 无限城篇', style: TextStyle(color: Colors.white)),
      // ),
      bottomNavigationBar: Container(
        
        padding: EdgeInsets.all(20.h), // 内边距
        decoration: BoxDecoration(
          color: Colors.white, // 背景色
            boxShadow: [
              // 第一层浅阴影
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        child: Container(
          width: double.infinity,
          height: 70.h,
          
          child: MaterialButton(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            onPressed: () {
              // 购票逻辑
            },
            child: Text(
              '购票（5555场）',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(child:  SafeArea(child: Container())),
                Image.asset('assets/image/kimetsu-movie.jpg', width: double.infinity, height: 480.h, fit: BoxFit.cover),
                // Image.asset('assets/image/raligun.webp', width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 0,
                  child:  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0,sigmaY: 10.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                          // top: MediaQuery.of(context).padding.top,
                          left: 10.w,
                          right: 10.w
                        ),
                        height: 480.h,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x00000000),
                              Color(0x90000000),
                            ],
                          ),
                        ),
                        child: Container()
                      )),
                  ),
                ),

                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        icon: SvgPicture.asset('assets/icons/back.svg', width: 48.sp),
                      ),
                      // 添加 Expanded 使标题居中，同时避免被其他内容挤压
                      // Expanded(
                      //   child: Center(
                      //     child: Text(
                      //       '鬼灭之刃 无限城篇',
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 32.sp,
                      //         overflow: TextOverflow.ellipsis, // 超出显示省略号
                      //       ),
                      //       maxLines: 1, // 限制为单行
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      // ),
                      // Container()
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: Container(),
                      ),
                    ],
                  ),
                ),
               
               Positioned(
                  top: MediaQuery.of(context).padding.top + 100.h,
                  left: 20.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20.w),
                        decoration: BoxDecoration(
                          // boxShadow: [
                          //   // 第一层浅阴影
                          //   BoxShadow(
                          //     color: Colors.white.withOpacity(0.2),
                          //     blurRadius: 15,
                          //     offset: const Offset(5, 5),
                          //   ),
                          //   // 第二层更深的阴影
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.3),
                          //     blurRadius: 30,
                          //     offset: const Offset(10, 10),
                          //   ),
                          // ],
                          borderRadius: BorderRadius.circular(10), // 圆角
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10), // 与 BoxDecoration 的圆角保持一致
                          child: ExtendedImage.asset(
                            'assets/image/kimetsu-movie.jpg',
                            width: 260.w,
                          ),
                        ),
                      ),
                      Container(
                        width: 440.w,
                        height: 300.h,
                        // margin: EdgeInsets.only(right: 20.w),
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.red)
                        // ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Space(
                              direction: 'column',
                              bottom: 5.h,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '鬼灭之刃 无限城篇无限城篇无限城篇无限城篇无限城篇无限城篇',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32.sp, // 调整文字大小以适配设备
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis, // 超出显示省略号
                                ),
                                Row(
                                  children: [
                                    Rate(
                                      initialRating: 3.5, // 初始评分
                                      maxRating: 5.0, // 最大评分
                                      starSize: 35.w, // 星星大小
                                      onRatingUpdate: (rating) {
                                        // print("当前评分：$rating");
                                      },
                                    ),
                                    SizedBox(width: 20.w),
                                    Text('9.8分', style: TextStyle(
                                      fontSize: 36.sp,
                                      color: Colors.yellow.shade700
                                    ),)
                                  ],
                                ),
                                const Text('2024年11月15日（一）上映', style: TextStyle(
                                  // fontSize: 40.sp,
                                  color: Colors.white
                                )),
                                // SizedBox(height: 10.h),                           
                                Wrap(
                                  spacing: 20.w,
                                  children: [
                                    ExtendedImage.asset('assets/image/audio-guide.png', width: 80.w),
                                    ExtendedImage.asset('assets/image/sub-guide.png', width: 80.w),
                                  ],
                                ),
                              ],
                            ),
                            Wrap(
                              // direction: Axis.vertical,
                              spacing: 20.w,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 50.w),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 234, 58, 105),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // 按内容适配宽度
                                    children: [
                                      const Icon(Icons.favorite, color: Colors.white),
                                      SizedBox(width: 10.w), // 图标和文字间距
                                      const Text(
                                        '想看',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 48.w),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 5, 189, 239),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // 按内容适配宽度
                                    children: [
                                      const Icon(Icons.remove_red_eye, color: Colors.white),
                                      // const Icon(Icons.star, color: Colors.white),
                                      SizedBox(width: 10.w), // 图标和文字间距
                                      const Text(
                                        '看过',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                           
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]
              ),
             
              Container(
                padding: EdgeInsets.only(top: 0.h, left: 20.w, right: 20.w),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h, top: 20.h, right: 0.w),
                        child:  Text('描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述描述', style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 29.sp
                      ), textAlign: TextAlign.justify,),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('基本信息', style: TextStyle(
                          // color: Colors.grey.shade700,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold
                        )),
                        // Icon(Icons.arrow_forward_ios, size: 36.sp)
                      ],
                    )
                    ),
                    Wrap(
                      runSpacing: 10.h,
                      children: [
                        Row(
                          children: [
                            Expanded( // 确保文本能够适配父级布局
                              child: Text(
                                '外文名：鬼灭之刃 无限城篇无限城篇无限城篇无限城篇无限城篇无限城篇无限城篇无限城篇',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis, // 设置溢出显示省略号
                                maxLines: 2, // 限制为单行
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                            Text('片长：119分钟', style: TextStyle(
                              fontSize: 28.sp,
                              color: Colors.grey.shade600
                            ))
                          ]),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text('上映规格：', style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.grey.shade600
                          ),),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 6,
                                children: ['IMAX', '3D', 'DOLBY CINEMA', 'DOLBY ATOMS'].map((item) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 193, 196, 202),
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(item, style: TextStyle(fontSize: 24.sp, color: Colors.white)),
                                  );
                                }).toList(),
                              )
                            ),
                          )
                          
                        ]),
                        Row(children: [
                          Text('标签：', style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.grey.shade600
                          )),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Wrap(
                                spacing: 6,
                                children: ['アニメ', '運動'].map((item) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 193, 196, 202),
                                      borderRadius: BorderRadius.circular(50)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(item, style: TextStyle(fontSize: 24.sp, color: Colors.white)),
                                  );
                                }).toList(),
                              )
                            ),
                          )
                        ]),
                        Row(children: [
                          Text('官网：', style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.grey.shade600
                          )),
                          GestureDetector(
                            onTap: () async {
                              const String url = 'https://www.bilibili.com';

                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(
                                  Uri.parse(url),
                                  mode: LaunchMode.externalApplication, // 打开外部浏览器
                                );
                              } else {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(content: Text('无法打开链接: $url')),
                                // );
                              }
                            },
                            child: Text('https://www.bilibili.com', style: TextStyle(
                              color: const Color.fromARGB(255, 5, 32, 239)
                            ),),
                          )
                        ]),
                        Row(children: [
                          Text('当前状态：未上映', style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.grey.shade600
                          ))
                        ]),
                       
                        Row(children: [
                          Text('映倫：', style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.grey.shade600
                          )),
                          Text('G（所有人都可以观看）', style: TextStyle(
                            fontSize: 28.sp
                          ))
                        ])
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h, top: 20.h),
                      child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('工作人员（100）', style: TextStyle(
                          // color: Colors.grey.shade700,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold
                        )),
                        Icon(Icons.arrow_forward_ios, size: 36.sp)
                      ],
                    )
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:  Wrap(
                        spacing: 20.w,
                        children: List.generate(10, (index) {
                          return SizedBox(
                            width: 163.w, // 设置容器宽度
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 163.w,
                                  // height: 280.h,
                                  color: Colors.grey.shade300,
                                  child: ExtendedImage.asset(
                                    'assets/image/raligun.webp',
                                    fit: BoxFit.cover, // 确保图片填满容器
                                  ),
                                ),
                                SizedBox(height: 10.w), // 为文本和图片之间添加间距
                                Text(
                                  '山本xxxx',
                                  style: TextStyle(fontSize: 30.sp),
                                  maxLines: 1, // 限制为一行
                                  overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                                ),
                                Text(
                                  '监督',
                                  style: TextStyle(fontSize: 26.sp, color: Colors.grey.shade500),
                                  maxLines: 1, // 限制为一行
                                  overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                   
                  //  Container(
                  //   decoration: BoxDecoration(
                  //     // color: Color(0xffe6e6e6),
                  //     // border: Border.all(color: Colors.red)
                  //   ),
                  //   padding: EdgeInsets.symmetric(vertical: 20.h),
                  //   child: Row(
                  //     children: [
                  //       Text('详细信息', style: TextStyle(
                  //         fontSize: 32.sp
                  //       ),),
                  //       Text('评论（1888）', style: TextStyle(
                  //         fontSize: 32.sp
                  //       )),
                  //     ].map((item) {
                  //       return  Container(
                  //         padding: EdgeInsets.symmetric(vertical: 15.w),
                  //         margin: EdgeInsets.only(right: 20.w),
                  //         decoration: const BoxDecoration(
                  //           // border: Border(
                  //           //   bottom: BorderSide(color: Colors.black)
                  //           // )
                  //         ),
                  //         child: item,
                  //       );
                  //     }).toList()
                  //   ),
                  //  ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                      child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('角色（100）', style: TextStyle(
                          // color: Colors.grey.shade700,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold
                        )),
                        Icon(Icons.arrow_forward_ios, size: 36.sp)
                      ],
                    )
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child:  Wrap(
                        spacing: 20.w,
                        children: List.generate(10, (index) {
                          return SizedBox(
                            width: 163.w, // 设置容器宽度
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 163.w,
                                  // height: 280.h,
                                  color: Colors.grey.shade300,
                                  child: ExtendedImage.asset(
                                    'assets/image/raligun.webp',
                                    fit: BoxFit.cover, // 确保图片填满容器
                                  ),
                                ),
                                SizedBox(height: 10.w), // 为文本和图片之间添加间距
                                Text(
                                  '山本xxxx',
                                  style: TextStyle(fontSize: 30.sp),
                                  maxLines: 1, // 限制为一行
                                  overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                                ),
                                Text(
                                  '监督',
                                  style: TextStyle(fontSize: 26.sp, color: Colors.grey.shade500),
                                  maxLines: 1, // 限制为一行
                                  overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.h, bottom: 10.h),
                      child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('评论（19588）', style: TextStyle(
                          // color: Colors.grey.shade700,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold
                        )),
                        // Icon(Icons.arrow_forward_ios, size: 36.sp)
                      ],
                    )
                    ),
                    ...generateComment()
                  ]
                ),
              )              
            ],
          ),
      )
    );
  }
}
