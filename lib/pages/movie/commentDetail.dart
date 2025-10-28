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
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/comment/comment_response.dart';

class CommentDetail extends StatefulWidget {
  final String? id;
  final String? movieId;
  const CommentDetail({super.key, this.id, this.movieId});

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
          child: ClipOval(
            child: data.commentUserAvatar != null && data.commentUserAvatar!.isNotEmpty
                ? CustomExtendedImage(
                    data.commentUserAvatar!,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 80.w,
                    height: 80.w,
                    color: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      size: 40.w,
                      color: Colors.grey.shade500,
                    ),
                  ),
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
                  Row(
                    children: [
                      // 点赞按钮
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
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: data.like! ? const Color(0xFFFF6B35).withOpacity(0.1) : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: data.like! ? const Color(0xFFFF6B35).withOpacity(0.3) : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                data.like! ? Icons.thumb_up : Icons.thumb_up_outlined,
                                color: data.like! ? const Color(0xFFFF6B35) : Colors.grey.shade500,
                                size: 20.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '${data.likeCount}',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: data.like! ? const Color(0xFFFF6B35) : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // 踩按钮
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
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: data.dislike! ? Colors.red.shade50 : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: data.dislike! ? Colors.red.shade200 : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                data.dislike! ? Icons.thumb_down : Icons.thumb_down_outlined,
                                color: data.dislike! ? Colors.red.shade400 : Colors.grey.shade500,
                                size: 20.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '${data.dislikeCount ?? 0}',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: data.dislike! ? Colors.red.shade400 : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // 回复按钮
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showReply = !showReply;                            
                            replyData = data;
                          });
                           _focusNode.requestFocus();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1989FA), Color(0xFF069EF0)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(22.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.reply_rounded,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                S.of(context).movieDetail_comment_reply,
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: S.of(context).commentDetail_title,
        titleTextStyle: TextStyle(fontSize: 36.sp, color: Colors.white),
      ),
      bottomNavigationBar: !showReply || replyData == null ? null : Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // 键盘高度
        ),
        child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 回复标题
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 20.h),
              child: Text(
                '${S.of(context).commentDetail_comment_placeholder(replyData?.commentUserName ?? '')}',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 输入框
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Input(
                focusNode: _focusNode,
                controller: commentInputController,
                type: 'textarea',
                maxLines: 6,
                placeholder: S.of(context).commentDetail_comment_hint,
                placeholderStyle: TextStyle(
                  color: Colors.grey.shade500, 
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w400,
                ),
                textStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 26.sp,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
                backgroundColor: Colors.transparent,
                horizontalPadding: 0.w,
                // borderRadius: BorderRadius.circular(20.r),
                suffixIcon: commentInputController.text.isNotEmpty 
                    ? Container(
                        margin: EdgeInsets.only(right: 16.w, top: 16.h),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              commentInputController.text = '';
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      )
                    : null,
                cursorColor: const Color(0xFF1989FA),
                onChange: (value) => {
                  setState(() {
                    currentReplyLength = value.length;
                  })
                },
                onSubmit: (val) {},
              ),
            ),
            SizedBox(height: 20.h),
            // 底部操作栏
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 字数统计
                Flexible(
                  child: Text(
                    '$currentReplyLength/1000',
                    style: TextStyle(
                      color: currentReplyLength > 900 
                        ? const Color(0xFFFF6B35)
                        : Colors.grey.shade500,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // 发送按钮
                GestureDetector(
                    onTap: commentInputController.text.trim().isEmpty ? null : () {
                    String parentReplyId = replyData is Reply && replyData?.parentReplyId != null 
                      ? '${replyData?.parentReplyId}-${replyData?.id}' 
                      : '${replyData?.id ?? ''}';

                    ApiRequest().request(
                      path: '/movie/reply/save',
                      method: 'POST',
                      data: {
                        "movieId": int.parse(widget.movieId ?? ''),
                        "movieCommentId": int.parse(widget.id ?? ''),
                        "content": commentInputController.text,
                        "parentReplyId": parentReplyId,
                        "replyUserId": replyData?.commentUserId
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
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      gradient: commentInputController.text.trim().isEmpty
                        ? null
                        : const LinearGradient(
                            colors: [Color(0xFF1989FA), Color(0xFF069EF0)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                      color: commentInputController.text.trim().isEmpty
                        ? Colors.grey.shade200
                        : null,
                      borderRadius: BorderRadius.circular(25.r),
                      border: commentInputController.text.trim().isEmpty
                        ? Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          )
                        : null,
                      boxShadow: commentInputController.text.trim().isEmpty
                        ? null
                        : [
                            BoxShadow(
                              color: const Color(0xFF1989FA).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                    ),
                    child: Text(
                      S.of(context).commentDetail_comment_button,
                      style: TextStyle(
                        color: commentInputController.text.trim().isEmpty
                          ? Colors.grey.shade500
                          : Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
          // padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: ListView(
            children: [
              // 主评论
              Container(
                margin: EdgeInsets.only(bottom: 24.h),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: buildComment(data),
              ),
              
              // 回复标题区域
              if (replyCount > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1989FA).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.comment_outlined,
                              color: const Color(0xFF1989FA),
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            S.of(context).commentDetail_replyComment,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          S.of(context).commentDetail_totalReplyMessage(replyCount),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // 回复列表
              ...replyList.map((reply) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: buildComment(reply, type: 'reply'),
                );
              }).toList(),
            ],
          ),
        ),
      ),
      )
    ),
    );

  }
}
