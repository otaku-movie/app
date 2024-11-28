import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/components/rate.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/character.dart';
import 'package:otaku_movie/response/movie/movieList/comment/comment.dart';
import 'package:otaku_movie/response/movie/movieList/movie.dart';
import 'package:otaku_movie/response/movie/movie_staff.dart';
import 'package:otaku_movie/response/response.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetail extends StatefulWidget {
  final String? id;

  const MovieDetail({super.key, this.id});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<MovieDetail> {

  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;
  MovieResponse data = MovieResponse();
  List<CharacterResponse> characterData = [];
  List<MovieStaffResponse> staffListData = [];
  List<CommentResponse> commentListData = [];


  getData () {
    ApiRequest().request(
      path: '/movie/detail',
      method: 'GET',
      queryParameters: {
        "id": widget.id
      },
      fromJsonT: (json) {
        return MovieResponse.fromJson(json);
      },
    ).then((res) {
      setState(() {
        data = res.data!;
      });
    }).catchError((err) {
      // setState(() {
      //   error = true;
      // });
    }).whenComplete(() {
      // setState(() {
      //   loading = false;
      // });
    });
  }

  getCharacterData () {
    ApiRequest().request(
      path: '/movie/character',
      method: 'GET',
      queryParameters: {
        "id": int.parse(widget.id!)
      },
      fromJsonT: (json) {
        if (json is List<dynamic>) {
          return json.map((item) {
            return CharacterResponse.fromJson(item);
          }).toList();
        }
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          characterData = res.data!;
        });
      }
    });
  }

  getStaffData () {
    ApiRequest().request(
      path: '/app/movie/staff',
      method: 'GET',
      queryParameters: {
        "movieId": widget.id
      },
      fromJsonT: (json) {
        if (json is List<dynamic>) {
          return json.map((item) {
            return MovieStaffResponse.fromJson(item);
          }).toList();
        }
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          staffListData = res.data!;
        });
      }
    });
  }

  void getCommentData({page = 1}) {
    ApiRequest().request(
      path: '/movie/comment/list',
      method: 'POST',
      data: {
        "movieId": int.parse(widget.id ?? ''),
        "page": page,
        "pageSize": 20,
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<CommentResponse>.fromJson(
          json,
          (data) => CommentResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) async {
      List<CommentResponse> list = res.data?.list ?? [];

      setState(() {
        commentListData = list;
      });
    });
  }

  

  @override
  void initState() {
    super.initState();
    getData();
    getCharacterData();
    getStaffData();
    getCommentData();

    // 延迟判断滚动距离，动态更新标题状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.offset > 200 && !_showTitle) {
          setState(() {
            _showTitle = true; // 滚动超过 100，显示标题
          });
        } else if (_scrollController.offset <= 200 && _showTitle) {
          setState(() {
            _showTitle = false; // 滚动小于等于 100，隐藏标题
          });
        }
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  List<Widget> generateComment() {
    return commentListData.map((comment) {
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
              backgroundImage: NetworkImage(comment.commentUserAvatar ?? ''),
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
                    Text(comment.commentUserName ?? '', style: TextStyle(
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
                  child: Text(comment.content ?? '', maxLines: 5, overflow: TextOverflow.ellipsis),
                ),
                // SizedBox(height: 5.h),
                Wrap(
                  spacing: 10.w,
                  children: [
                    Icon(Icons.thumb_up, color: Colors.grey.shade400, size: 36.sp),
                    Text('${comment.likeCount}'),
                    Icon(Icons.thumb_down, color: Colors.grey.shade400, size: 36.sp),
                    Text('${comment.unlikeCount}'),
                    Icon(Icons.comment, color: Colors.grey.shade400, size: 36.sp),
                    Text(S.of(context).movieDetail_comment_reply),
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
          
        ]
      ),
      );
    }).toList();
  }

  bool isValidDate(String date) {
    RegExp regExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    
    return regExp.hasMatch(date);
  }

  getWeekday (String date) {
    try {
      // 尝试解析日期字符串
      DateTime parsedDate = DateTime.parse(date);
      
      // 检查是否是有效的 yyyy-MM-dd 格式
      parsedDate.toString().startsWith(date);

      List<String> weekDays = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
      ];

     return weekDays[parsedDate.weekday - 1];
    } catch (e) {
      return '';  // 解析失败，说明无效
    }
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
      body: AppErrorWidget(
        child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // 返回一个 Sliver 数组给外部可滚动组件。
          return <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              collapsedHeight: 100.h >= 56.0 ? 100.h : 56.0,
              expandedHeight: 428.h,
              backgroundColor: Colors.blue,
              title: _showTitle
                    ? Text(
                        data.name ?? '',
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              forceElevated: innerBoxIsScrolled,
              leading: IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: SvgPicture.asset('assets/icons/back.svg', width: 48.sp),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(child:  SafeArea(child: Container())),
                  ExtendedImage.network(data.cover ?? '', width: double.infinity, fit: BoxFit.cover),
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
                          child: Container(
                            height: 300.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10), // 与 BoxDecoration 的圆角保持一致
                              child: ExtendedImage.network(
                                data.cover ?? '',
                                width: 260.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ) ,
                        ),
                        SizedBox(
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
                                    data.name ?? '',
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
                                  Text(
                                    data.startDate == null
                                      ? S.of(context).movieDetail_detail_noDate  // 如果 startDate 为 null，显示 "没有日期"
                                      : isValidDate(data.startDate ?? '') 
                                          ? '${data.startDate ?? ''} (${getWeekday(data.startDate ?? '')})'  // 如果是有效日期格式，显示日期和星期几
                                          : data.startDate ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
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
              ),
              actions: [
                IconButton(
                  onPressed: () {}, 
                  icon: const Icon(Icons.share, color: Colors.white)
                )
              ],
            ),
            // buildSliverList(5), //构建一个 sliverList
          ];
        },
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [             
                Container(
                  padding: EdgeInsets.only(top: 0.h, left: 20.w, right: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h, top: 20.h, right: 0.w),
                          child:  Text(data.description ?? '', style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 29.sp
                        ), textAlign: TextAlign.justify,),
                      ),
                      
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.h),
                        child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.of(context).movieDetail_detail_basicMessage, style: TextStyle(
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
                                  '${S.of(context).movieDetail_detail_originalName}：${data.originalName ?? ''}',
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
                              Text('${S.of(context).movieDetail_detail_time}：${data.time ?? ''}', style: TextStyle(
                                fontSize: 28.sp,
                                color: Colors.grey.shade600
                              ))
                            ]),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            Text('${S.of(context).movieDetail_detail_spec}：', style: TextStyle(
                              fontSize: 28.sp,
                              color: Colors.grey.shade600
                            ),),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing: 6,
                                  children: data.spec == null ? [] : data.spec!.map((item) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 193, 196, 202),
                                        borderRadius: BorderRadius.circular(50)
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(item.name ?? '', style: TextStyle(fontSize: 24.sp, color: Colors.white)),
                                    );
                                  }).toList(),
                                )
                              ),
                            )
                            
                          ]),
                          Row(children: [
                            Text('${S.of(context).movieDetail_detail_tags}：', style: TextStyle(
                              fontSize: 28.sp,
                              color: Colors.grey.shade600
                            )),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing: 6,
                                  children: data.tags == null ? [] : data.tags!.map((item) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 193, 196, 202),
                                        borderRadius: BorderRadius.circular(50)
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(item.name ?? '', style: TextStyle(fontSize: 24.sp, color: Colors.white)),
                                    );
                                  }).toList(),
                                )
                              ),
                            )
                          ]),
                          Row(children: [
                            Text('${S.of(context).movieDetail_detail_homepage}：', style: TextStyle(
                              fontSize: 28.sp,
                              color: Colors.grey.shade600
                            )),
                            GestureDetector(
                              onTap: () async {
                                String url = data.homePage ?? '';

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
                              child: Text(data.homePage ?? '', style: const TextStyle(
                                color: Color.fromARGB(255, 5, 32, 239)
                              ),),
                            )
                          ]),
                          Row(children: [
                            Text('${S.of(context).movieDetail_detail_state}：未上映', style: TextStyle(
                              fontSize: 28.sp,
                              color: Colors.grey.shade600
                            ))
                          ]),
                          Container(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${S.of(context).movieDetail_detail_level}：', // 显示电影级别的标题
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${data.levelName}（${data.levelDescription}）', // 显示电影级别的名字和描述
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      color: Colors.black, // 你可以根据需要调整颜色
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        
                        ],
                      ),
                      ...staffListData.isEmpty ? [] : [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h, top: 20.h),
                          child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${S.of(context).movieDetail_detail_staff}（${staffListData.length}）', style: TextStyle(
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
                            children: staffListData.map((item) {
                              return SizedBox(
                                width: 163.w, // 设置容器宽度
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 163.w,
                                      height: 200.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: ExtendedImage.network(
                                        item.avatar ?? '',
                                        fit: BoxFit.cover, // 确保图片填满容器
                                      ),
                                    ),
                                    SizedBox(height: 10.w), // 为文本和图片之间添加间距
                                    Text(
                                      item.name ?? '',
                                      style: TextStyle(fontSize: 30.sp),
                                      maxLines: 1, // 限制为一行
                                      overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                                    ),
                                    Text(
                                      item.position!.map((children) => children.name ?? '').join('、'), // 拼接名字，若为空则用空字符串替代
                                      style: TextStyle(fontSize: 26.sp, color: Colors.grey.shade500),
                                      maxLines: 1, // 限制为一行
                                      overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                                    )
                                  ],
                                ),
                              );
                            }).toList()
                          ),
                        ),
                      ],
                      
                      ...characterData.isEmpty ? [] : [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h, top: 20.h),
                          child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${S.of(context).movieDetail_detail_staff}（${characterData.length}）', style: TextStyle(
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
                            children: characterData.map((item) {
                              return SizedBox(
                                width: 163.w, // 设置容器宽度
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 163.w,
                                      height: 200.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: ExtendedImage.network(
                                        item.cover ?? '',
                                        fit: BoxFit.cover, // 确保图片填满容器
                                      ),
                                    ),
                                    SizedBox(height: 10.w), // 为文本和图片之间添加间距
                                    Text(
                                      item.name ?? '',
                                      style: TextStyle(fontSize: 30.sp),
                                      maxLines: 1, // 限制为一行
                                      overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                                    ),
                                    Text(
                                      item.staff!.map((children) => children.name ?? '').join('、'), // 拼接名字，若为空则用空字符串替代
                                      style: TextStyle(fontSize: 26.sp, color: Colors.grey.shade500),
                                      maxLines: 1, // 限制为一行
                                      overflow: TextOverflow.ellipsis, // 超出部分显示省略号
                                    )
                                  ],
                                ),
                              );
                            }).toList()
                          ),
                        ),
                      ],
                      ...commentListData.isEmpty ? [] : [
                        Padding(
                          padding: EdgeInsets.only(top: 30.h, bottom: 10.h),
                          child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${S.of(context).movieDetail_detail_comment}（${commentListData.length}）', style: TextStyle(
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
                    ]
                  ),
                )              
              ],
            ),
          )
        )
      )
    );
  }
}
