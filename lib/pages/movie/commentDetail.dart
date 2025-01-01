import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jiffy/jiffy.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/Input.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/components/rate.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/comment/comment_response.dart';

class CommentDetail extends StatefulWidget {
  String? id;
  String? movieId;
  CommentDetail({super.key, this.id, this.movieId});

  @override
  // ignore: library_private_types_in_public_api
  _CommentDetailPageState createState() => _CommentDetailPageState();
}

class _CommentDetailPageState extends State<CommentDetail> {
  TextEditingController commentInputController = TextEditingController();
  EasyRefreshController easyRefreshController = EasyRefreshController();
   final LanguageController languageController = Get.find();
  final FocusNode _focusNode = FocusNode();
  CommentResponse data = CommentResponse();
  int currentPage = 1;
  bool loading = false;
  bool error = false;
  bool loadFinished = false;
  bool showReply = false;
  List<Reply> replyList = [];
  String replyUsernName = '';
  int currentReplyLength = 0;
  int replyCount = 0;
  dynamic replyData;

  void getData() {
    ApiRequest()
        .request(
      path: '/movie/comment/detail',
      method: 'GET',
      queryParameters: {"id": int.parse(widget.id ?? '')},
      fromJsonT: (json) {
        return CommentResponse.fromJson(json as Map<String, dynamic>);
      },
    )
        .then((res) async {
      setState(() {
        data = res.data ?? CommentResponse();
      });
    });
  }

  void getReplyData({page = 1}) {
    ApiRequest()
        .request(
      path: '/movie/reply/list',
      method: 'POST',
      data: {
        "commentId": int.parse(widget.id ?? ''),
        "page": page,
        "pageSize": 10
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<Reply>.fromJson(
          json,
          (data) => Reply.fromJson(data as Map<String, dynamic>),
        );
      },
    )
        .then((res) async {
      if (res.data?.list != null) {
        List<Reply> list = res.data!.list!;

        setState(() {
          if (list.isNotEmpty && !loadFinished) {
            replyList.addAll(list); // 追加数据
          }
          if (page == 1) {
            replyList = list;
          }
          currentPage = page;
          replyCount = res.data!.total!;
          loadFinished = list.isEmpty; // 更新加载完成标志
        });

        easyRefreshController.finishLoad(
            list.isEmpty ? IndicatorResult.noMore : IndicatorResult.success,
            true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getReplyData();
    final locale = Get.find<LanguageController>().locale.value;
    Jiffy.setLocale(locale.languageCode == 'zh' ? 'zh_cn' : locale.languageCode);
  }

  @override
  void dispose() {
    commentInputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget buildComment(dynamic data, {type = 'comment'}) {
    return Container(
      padding: EdgeInsets.only(bottom: 20.h),
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration( 
        border: Border(
          bottom: BorderSide(width: 1.w, color: Colors.grey.shade200),
        ),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 80.w,
          height: 80.w,
          margin: EdgeInsets.only(right: 20.w),
          child: CircleAvatar(
            radius: 50.0, // 半径
            backgroundColor: Colors.grey.shade300,
            backgroundImage: NetworkImage(data.commentUserAvatar ?? ''),
          ),
        ),
        SizedBox(
            // width: ,
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.red),
            // ),
            child: Space(direction: 'column', children: [
              Wrap(
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
                        Text(
                          data.commentUserName ?? '',
                          style: TextStyle(fontSize: 32.sp),
                        ),
                      ],
                    ),
                  ),
                  data.createTime != null ? Text(
                    Jiffy.parse(data.createTime, pattern: 'yyyy-MM-dd HH:mm:ss').fromNow(),
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 24.sp),
                  ) : const Text(''),
                  Container(
                    width: 600.w,
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Space(
                      direction: 'column',
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: data is Reply && data.replyUserId != null 
                                ? '${S.of(context).movieDetail_comment_replyTo(data.replyUserName ?? '')}：' : '',
                                style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade400)
                              ),
                              TextSpan(
                                text: data.content ?? '',
                                style: TextStyle(fontSize: 28.sp, color: Colors.black87,height: 1.5),
                              ),
                            ]
                          ))
                    ])
                  ),
                  SizedBox(height: 5.h),
                  Space(
                    right: 20.w,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            data.like = !data.like!;
                            data.likeCount = data.like! ? data.likeCount! + 1 : data.likeCount! - 1;
                            if (data.like! && data.dislikeCount != 0) {
                              data.dislike = false;
                              data.dislikeCount = data.dislikeCount! - 1;
                            }
                          });
                          ApiRequest().request(
                            path: '/movie/$type/like',
                            method: 'POST',
                            data: {
                              "id": data.id
                            },
                            fromJsonT: (json) {
                              return json;
                            },
                          ).then((res) {
                            getData();
                            getReplyData();
                          });
                        },
                        child: Space(
                          right: 10.w,
                          children: [
                            Icon(
                              Icons.thumb_up,
                              color: data.like! ? Colors.pink.shade400 : Colors.grey.shade400, 
                              size: 36.sp
                            ),
                            Text('${data.likeCount}'),
                        ]),     
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            data.dislike = !data.dislike!;
                            data.dislikeCount = data.dislike! ? data.dislikeCount! + 1 : data.dislikeCount! - 1;
                            if (data.dislike! && data.likeCount != 0) {
                              data.like = false;
                              data.likeCount = data.likeCount! - 1;
                            }
                          });
                          ApiRequest().request(
                            path: '/movie/$type/dislike',
                            method: 'POST',
                            data: {
                              "id": data.id
                            },
                            fromJsonT: (json) {
                              return json;
                            },
                          ).then((res) {
                            getData();
                            getReplyData();
                          });
                        },
                        child: Space(
                          right: 10.w,
                          children: [
                            Icon(
                              Icons.thumb_down,
                              color: data.dislike! ? Colors.pink.shade400 : Colors.grey.shade400, 
                              size: 36.sp
                          ),
                          Text('${data.dislikeCount}'),
                        ]),     
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showReply = !showReply;                            
                            replyData = data;
                          });
                           _focusNode.requestFocus();
                        },
                        child: Space(
                          right: 10.w,
                          children: [
                            Icon(
                              Icons.comment,
                              color: Colors.grey.shade400, 
                              size: 36.sp
                            ),
                            Text(S.of(context).movieDetail_comment_reply),
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
                      //       Text(S.of(context).movieDetail_comment_translate(languageController.locale.value.languageCode), style: TextStyle(color: Colors.grey.shade700))
                      //     ]),
                      //   ]),     
                      // ),
                      //  GestureDetector(
                      //   onTap: () {
                      //   },
                      //   child: Space(
                      //     right: 10.w,
                      //     children: [
                      //       Space(
                      //       right: 10.w,
                      //       children: [
                      //         Icon(
                      //           Icons.delete,
                      //         color: Colors.grey.shade400, size: 36.sp
                      //       ),
                      //       Text(S.of(context).movieDetail_comment_delete, style: TextStyle(color: Colors.grey.shade700))
                      //     ]),
                      //   ]),     
                      // ),
                    ],
                  ),
                ],
              ),
            ]))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 关闭键盘弹窗
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          showReply = false;
        });
      },
      child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: S.of(context).commentDetail_title,
        titleTextStyle: TextStyle(fontSize: 36.sp, color: Colors.white),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // 键盘高度
        ),
        child:  !showReply ? null :  Container(
        height: 300.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(0, -2),
              blurRadius: 5,
            )
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        // color: Colors.grey.shade200,
        child: Space(
          right: 20.w,
          direction: 'column',
          bottom: 20.h,
          children: [
            Expanded(
              child: Input(
                focusNode: _focusNode,
                controller: commentInputController,
                type: 'textarea',
                maxLines: 5,
                placeholder: '${S.of(context).commentDetail_comment_placeholder(replyData.commentUserName)}：',
                placeholderStyle: TextStyle(color: Colors.grey.shade500, fontSize: 28.sp),
                textStyle: const TextStyle(color: Colors.black),
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(4),
                suffixIcon: commentInputController.text.isNotEmpty 
                    ? IconButton(
                      onPressed: () {
                        setState(() {
                          commentInputController.text = '';
                        });
                        // 关闭键盘弹窗
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      // enableFeedback: false,
                      icon: Icon(
                        Icons.clear, 
                        color: Colors.grey.shade500
                      )
                ) : null,
                cursorColor: Colors.black,
                onChange: (value) => {
                  setState(() {
                    currentReplyLength = value.length;
                  })
                },
                onSubmit: (val) {

                },
              )),
              Space(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('$currentReplyLength/1000', style: TextStyle(color: Colors.grey.shade500, fontSize: 28.sp)),
                  GestureDetector(
                    onTap: () {
                      String parentReplyId = replyData is Reply && replyData.parentReplyId != null ? '${replyData.parentReplyId}-${replyData.id}' : '${replyData.id}';

                    
                      ApiRequest().request(
                        path: '/movie/reply/save',
                        method: 'POST',
                        data: {
                          "movieId": int.parse(widget.movieId ?? ''),
                          "movieCommentId": int.parse(widget.id ?? ''),
                          "content": commentInputController.text,
                          "parentReplyId": parentReplyId,
                          "replyUserId": replyData.commentUserId
                        },
                        fromJsonT: (json) {
                          return ApiPaginationResponse<Reply>.fromJson(
                            json,
                            (data) => Reply.fromJson(data as Map<String, dynamic>),
                          );
                        },
                      ).then((res) async {
                        setState(() {
                          commentInputController.text = '';
                          showReply = false;
                        });
                        getReplyData();
                      });
                    },
                    child: Container(
                      // width: 100.w,
                      height: 45.h,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        S.of(context).commentDetail_comment_button,
                        style: TextStyle(color: Colors.white, fontSize: 28.sp),
                      ),
                    ),
                  )
                ]
              )
              
            
          ]
        ),
      ),
      ), 
      body: AppErrorWidget(
        loading: loading,
        child:  EasyRefresh(
        header: customHeader(context),
        footer: customFooter(context),
        onRefresh: () {
          getData();
        },
        controller: easyRefreshController,
        onLoad: () async {
          getReplyData(page: currentPage + 1);
        },
        child: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
          child: ListView(
            children: [
              buildComment(data),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                margin: EdgeInsets.only(bottom: 20.h),
                
                child:  replyCount == 0 ? null : Space(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).commentDetail_replyComment, 
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 28.sp)
                    ),
                    Text(
                      S.of(context).commentDetail_totalReplyMessage(replyCount), 
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 28.sp)
                    ),
                  ]
                ),
              ),
              Space(
                direction: 'column',
                crossAxisAlignment: CrossAxisAlignment.start,
                bottom: 10.h,
                children: [
                ...replyList.map((reply) {
                  return buildComment(reply, type: 'reply');
                }),
              ]),
            ],
          ),
        ),
      ),
      )
    ),
    );

  }
}
