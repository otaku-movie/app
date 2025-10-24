import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/HelloMovie.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/dict.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/components/rate.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/hello_movie.dart';
import 'package:otaku_movie/response/movie/movieList/character.dart';
import 'package:otaku_movie/response/movie/movieList/comment/comment_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie.dart';
import 'package:otaku_movie/response/movie/movie_staff.dart';
import 'package:otaku_movie/utils/date_format_util.dart';
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
    if (!mounted) return; // 添加mounted检查
    
    ApiRequest().request(
      path: '/movie/comment/list',
      method: 'POST',
      data: {
        "movieId": int.parse(widget.id ?? ''),
        "page": page,
        "pageSize": 20
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<CommentResponse>.fromJson(
          json,
          (data) => CommentResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) async {
      if (!mounted) return; // 添加mounted检查
      
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
    _scrollController.dispose(); // 添加释放控制器
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  List<Widget> generateComment() {
    return commentListData.map((comment) {
      return GestureDetector(
        // onTap: () {
        //   context.pushNamed(
        //     'commentDetail',
        //     queryParameters: {
        //       "id": '${comment.id}'
        //     }
        //   );
        // },
        child: Container(
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
                  // padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.commentUserName ?? '', style: TextStyle(
                      fontSize: 32.sp
                    )),

                    comment.rate == null || comment.rate!.isZero ? Container() :  Row(
                      children: [
                        Rate(
                          maxRating: 10.0, // 最大评分
                          starSize: 38.w, // 星星大小
                          readOnly: true,
                          point: comment.rate ?? 0
                        ),
                        SizedBox(
                          width: 110.w,  // 固定文字容器宽度
                          child: Text(
                            '${comment.rate ?? ''}${S.of(context).common_unit_point}',
                            style: TextStyle(
                              fontSize: 32.sp, 
                              color: Colors.yellow.shade800
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                    
                  ],
                ),
                ),
                
                comment.createTime != null ? Text(
                    Jiffy.parse(comment.createTime ?? '', pattern: 'yyyy-MM-dd HH:mm:ss').fromNow(),
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 24.sp),
                  ) : const Text(''),
                Container(
                  width: 600.w,
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text(comment.content ?? '', maxLines: 5, overflow: TextOverflow.ellipsis),
                ),
                // SizedBox(height: 5.h),
                 Space(
                    right: 20.w,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            comment.like = !comment.like!;
                            comment.likeCount = comment.like! ? comment.likeCount! + 1 : comment.likeCount! - 1;
                            if (comment.like! && comment.dislikeCount != 0) {
                              comment.dislike = false;
                              comment.dislikeCount = comment.dislikeCount! - 1;
                            }
                          });
                          ApiRequest().request(
                            path: '/movie/comment/like',
                            method: 'POST',
                            data: {
                              "id": comment.id
                            },
                            fromJsonT: (json) {
                              return json;
                            },
                          ).then((res) {
                            getCommentData();
                          });
                        },
                        child: Space(
                          right: 10.w,
                          children: [
                            Icon(
                              Icons.thumb_up,
                              color: comment.like! ? Colors.pink.shade400 : Colors.grey.shade400, 
                              size: 36.sp
                            ),
                            Text('${comment.likeCount}'),
                        ]),     
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            comment.dislike = !comment.dislike!;
                            comment.dislikeCount = comment.dislike! ? comment.dislikeCount! + 1 : comment.dislikeCount! - 1;
                            if (comment.dislike! && comment.likeCount != 0) {
                              comment.like = false;
                              comment.likeCount = comment.likeCount! - 1;
                            }
                          });
                          ApiRequest().request(
                            path: '/movie/comment/dislike',
                            method: 'POST',
                            data: {
                              "id": comment.id
                            },
                            fromJsonT: (json) {
                              return json;
                            },
                          ).then((res) {
                            getCommentData();
                          });
                        },
                        child: Space(
                          right: 10.w,
                          children: [
                            Icon(
                            Icons.thumb_down,
                            color: comment.dislike! ? Colors.pink.shade400 : Colors.grey.shade400, size: 36.sp
                          ),
                          Text('${comment.dislikeCount ?? 0}'),
                        ]),     
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed('commentDetail', queryParameters: {
                            "id": '${comment.id}',
                            'movieId': widget.id
                          });
                          // setState(() {
                          //   showReply = !showReply;
                          //   replyId = data.id;
                            
                          //   replyUsernName = type == 'comment' ? data.commentUserName ?? '' : data.replyUserName ?? '';

                          // });
                          //  _focusNode.requestFocus();
                        },
                        child: Space(
                          right: 10.w,
                          children: [
                            Icon(
                              Icons.comment,
                              color: Colors.grey.shade400, 
                              size: 36.sp
                            ),
                            Text(S.of(context).movieDetail_detail_totalReplyMessage(comment.replyCount ?? 0), style: TextStyle(color: Colors.grey.shade700)),
                        ]),     
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //   },
                      //   child: Space(
                      //     right: 10.w,
                      //     children: [
                      //       Space(
                      //       right: 10.w,
                      //       children: [
                      //         Icon(
                      //           Icons.translate,
                      //         color: Colors.grey.shade400, size: 36.sp
                      //       ),
                      //       Text('翻译为日语', style: TextStyle(color: Colors.grey.shade700))
                      //     ]),
                      //   ]),     
                      // ),
                    ],
                  ),
                // comment.reply == null || comment.reply!.isEmpty ? Container() : GestureDetector(
                //   onTap: () {
                //     context.pushNamed(
                //       'commentDetail',
                //       queryParameters: {
                //         "id": '${comment.id}'
                //       }
                //     );
                //   },
                //   child: Container(
                //   width: 600.w,
                //   padding: EdgeInsets.all(15.w),
                //   margin: EdgeInsets.symmetric(vertical: 20.h),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFe7e7e7),
                //     borderRadius: BorderRadius.circular(8)
                //   ),
                //   child: Space(
                //     direction: 'column',
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     bottom: 10.h,
                //     children: [
                //       ...comment.reply!.map((reply) {
                //         return Text(
                //           '${reply.commentUserName}回复@${reply.replyUserName}：${reply.content}', 
                //           maxLines: 5, 
                //           overflow: TextOverflow.ellipsis
                //         );
                //       }),
                //       (comment.replyCount ?? 0) > 3 ?  Space(
                //         children: [
                //           Padding(
                //             padding: EdgeInsets.only(top: 10.h),
                //             child:  Text(
                //               S.of(context).movieDetail_detail_totalReplyMessage(comment.replyCount ?? 0), style: TextStyle(
                //                 color: Colors.grey.shade700
                //               )
                //             ),
                //           )
                //         ]
                //       ) : Container()
                //     ]
                //   ),
                // ),
                // ) 
                
              ],
            ),
          )
          
        ]
        )
      ),
      );
    }).toList();
  }


  String _formatDuration(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return S.of(context).movieDetail_detail_duration_unknown;
    }
    
    try {
      int minutes = int.parse(timeString);
      
      if (minutes < 60) {
        return '${minutes}${S.of(context).movieDetail_detail_duration_minutes}';
      } else {
        int hours = minutes ~/ 60;
        int remainingMinutes = minutes % 60;
        
        if (remainingMinutes == 0) {
          return '${hours}${S.of(context).movieDetail_detail_duration_hours}';
        } else {
          return S.of(context).movieDetail_detail_duration_hoursMinutes(hours, remainingMinutes);
        }
      }
    } catch (e) {
      return S.of(context).movieDetail_detail_duration_unknown;
    }
  }

  Widget _buildInfoRow(String label, String value, {Widget? customValue}) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 160.w,
            child: Text(
              '$label：',
              style: TextStyle(
                fontSize: 28.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          if (customValue != null)
            customValue
          else
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 28.sp,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildHelloMovieGuide(List<HelloMovieResponse>? helloMovie) {
    if (helloMovie == null || helloMovie.isEmpty) {
      return Container();
    }

    HelloMovieResponse? audio = data.helloMovie?.firstWhere(
      (guide) => guide.code == HelloMovieGuide.audio.code, 
      orElse: () => HelloMovieResponse()
    );
    HelloMovieResponse? sub = data.helloMovie?.firstWhere(
      (guide) => guide.code == HelloMovieGuide.sub.code, 
      orElse: () => HelloMovieResponse()
    );

    // 检查是否有有效数据
    bool hasAudio = audio?.date != null && audio!.date!.isNotEmpty;
    bool hasSub = sub?.date != null && sub!.date!.isNotEmpty;

    if (!hasAudio && !hasSub) {
      return Container();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // 音轨信息
          if (hasAudio)
            Container(
              margin: EdgeInsets.only(right: 12.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HelloMovie(
                    guideData: data.helloMovie, 
                    type: HelloMovieGuide.audio,
                    width: 50.w,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    DateFormatUtil.formatDate(audio?.date, context),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          
          // 字幕信息
          if (hasSub)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HelloMovie(
                    guideData: data.helloMovie, 
                    type: HelloMovieGuide.sub,
                    width: 50.w,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    DateFormatUtil.formatDate(sub?.date, context),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: const CustomAppBar(
      //    title: Text('鬼灭之刃 无限城篇', style: TextStyle(color: Colors.white)),
      // ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              context.pushNamed(
                'showTimeList', 
                pathParameters: {
                  "id": '${widget.id}'
                }, 
                queryParameters: {
                  'movieName': data.name
                });
            },
            child: Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1989FA), Color(0xFF069EF0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1989FA).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25.r),
                  onTap: () {
                    context.pushNamed(
                      'showTimeList', 
                      pathParameters: {
                        "id": '${widget.id}'
                      },
                      queryParameters: {
                        'movieName': data.name
                      }
                    );
                  },
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie_outlined,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          S.of(context).movieDetail_button_buy,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
              expandedHeight: 415.h,
              backgroundColor: Colors.blue,
              title: _showTitle
                    ? Text(
                        data.name ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 34.sp),
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
                  CustomExtendedImage(data.cover ?? '', width: double.infinity, fit: BoxFit.cover),
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
                              child: CustomExtendedImage(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 电影名称
                                  Text(
                                    data.name ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 34.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12.h),
                                  
                                  // 标签行：分级 + 评分
                                  Row(
                                    children: [
                                      // 分级信息
                                      if (data.levelName != null)
                                        Container(
                                          margin: EdgeInsets.only(right: 8.w),
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(16.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.shield_outlined,
                                                color: Colors.white,
                                                size: 18.sp,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                data.levelName ?? '',
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      
                                      // 评分
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(16.r),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow.shade700,
                                              size: 20.sp,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              '${data.rate ?? 0}',
                                              style: TextStyle(
                                                fontSize: 26.sp,
                                                color: Colors.yellow.shade700,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              '${S.of(context).common_unit_point}',
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  
                                  // 上映日期
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: Colors.white70,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 6.w),
                                      Text(
                                        data.startDate == null
                                          ? S.of(context).movieDetail_detail_noDate
                                          : DateFormatUtil.formatDate(data.startDate, context),
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),

                                  // HelloMovie 指南
                                  buildHelloMovieGuide(data.helloMovie),
                                ],
                              ),
                              // Space(
                              //   // direction: Axis.vertical,
                              //   // spacing: 20.w,
                              //   right: 20.w,
                              //   children: [
                              //     Container(
                              //       padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 50.w),
                              //       decoration: BoxDecoration(
                              //         color: const Color.fromARGB(255, 234, 58, 105),
                              //         borderRadius: BorderRadius.circular(50),
                              //       ),
                              //       child: Row(
                              //         mainAxisSize: MainAxisSize.min, // 按内容适配宽度
                              //         children: [
                              //           const Icon(Icons.favorite, color: Colors.white),
                              //           SizedBox(width: 10.w), // 图标和文字间距
                              //           const Text(
                              //             '想看',
                              //             style: TextStyle(color: Colors.white),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //     Container(
                              //       padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 48.w),
                              //       decoration: BoxDecoration(
                              //         color: const Color.fromARGB(255, 5, 189, 239),
                              //         borderRadius: BorderRadius.circular(50),
                              //       ),
                              //       child: Row(
                              //         mainAxisSize: MainAxisSize.min, // 按内容适配宽度
                              //         children: [
                              //           const Icon(Icons.remove_red_eye, color: Colors.white),
                              //           // const Icon(Icons.star, color: Colors.white),
                              //           SizedBox(width: 10.w), // 图标和文字间距
                              //           const Text(
                              //             '看过',
                              //             style: TextStyle(color: Colors.white),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // )
                            
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
                          fontSize: 26.sp
                        ), textAlign: TextAlign.justify,),
                      ),
                      
                      Container(
                        margin: EdgeInsets.only(bottom: 20.h, top: 20.h),
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8FA),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFF1989FA).withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1989FA).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: const Color(0xFF1989FA),
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              S.of(context).movieDetail_detail_basicMessage,
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF323233),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 原名
                          _buildInfoRow(
                            S.of(context).movieDetail_detail_originalName,
                            data.originalName ?? '',
                          ),
                          // 时长
                          _buildInfoRow(
                            S.of(context).movieDetail_detail_time,
                            _formatDuration(data.time?.toString()),
                          ),
                          // 上映规格
                          if (data.spec != null && data.spec!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 160.w,
                                    child: Text(
                                      '${S.of(context).movieDetail_detail_spec}：',
                                      style: TextStyle(
                                        fontSize: 28.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: data.spec!.map((item) {
                                          return Container(
                                            margin: EdgeInsets.only(right: 8.w),
                                            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF1989FA), Color(0xFF069EF0)],
                                              ),
                                              borderRadius: BorderRadius.circular(20.r),
                                            ),
                                            child: Text(
                                              item.name ?? '', 
                                              style: TextStyle(
                                                fontSize: 22.sp, 
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // 标签
                          if (data.tags != null && data.tags!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 160.w,
                                    child: Text(
                                      '${S.of(context).movieDetail_detail_tags}：',
                                      style: TextStyle(
                                        fontSize: 28.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: data.tags!.map((item) {
                                          return Container(
                                            margin: EdgeInsets.only(right: 8.w),
                                            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF7F8FA),
                                              borderRadius: BorderRadius.circular(20.r),
                                              border: Border.all(
                                                color: const Color(0xFF1989FA).withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              item.name ?? '', 
                                              style: TextStyle(
                                                fontSize: 22.sp, 
                                                color: const Color(0xFF1989FA),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // 官网
                          if (data.homePage != null && data.homePage!.isNotEmpty)
                            GestureDetector(
                              onTap: () async {
                                String url = data.homePage ?? '';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 160.w,
                                      child: Text(
                                        '${S.of(context).movieDetail_detail_homepage}：',
                                        style: TextStyle(
                                          fontSize: 28.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        data.homePage ?? '',
                                        style: TextStyle(
                                          fontSize: 28.sp,
                                          color: const Color(0xFF1989FA),
                                          decoration: TextDecoration.underline,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      Icons.open_in_new,
                                      color: const Color(0xFF1989FA),
                                      size: 18.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // 上映状态
                          _buildInfoRow(
                            S.of(context).movieDetail_detail_state,
                            '',
                            customValue: Dict(
                              name: 'releaseStatus',
                              code: data.status,
                            ),
                          ),
                          // 分级
                          if (data.levelName != null)
                            _buildInfoRow(
                              S.of(context).movieDetail_detail_level,
                              '${data.levelName}${data.levelDescription != null && data.levelDescription!.isNotEmpty ? '（${data.levelDescription}）' : ''}',
                            ),
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
                                      child: CustomExtendedImage(
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
                            Text('${S.of(context).movieDetail_detail_character}（${characterData.length}）', style: TextStyle(
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
                                      child: CustomExtendedImage(
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
                            Text('${S.of(context).movieDetail_detail_comment}（${data.commentCount ?? 0}）', style: TextStyle(
                              // color: Colors.grey.shade700,
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold
                            )),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed('writeComment', queryParameters: {
                                  'id': widget.id,
                                  'movieName': data.name,
                                  'rated': '${data.rated}'
                                });
                              },
                              child: Space(
                                right: 5.w,
                                children: [
                                Icon( Icons.edit, size: 36.sp, color: Colors.grey.shade500),
                                Text(S.of(context).movieDetail_writeComment, style: TextStyle(
                                  color: Colors.grey.shade500
                                )),
                              ])
                            )
                           
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
