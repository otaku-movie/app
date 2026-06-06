import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/analytics/analytics.dart';
import 'package:otaku_movie/analytics/events.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/rate.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/components/Input.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/utils/toast.dart';


// ignore: must_be_immutable
class WriteComment extends StatefulWidget {
  String? id;
  String? movieName;
  bool? rated;
  double? userRate;

  WriteComment({super.key, this.id, this.movieName, this.rated = false, this.userRate});

  @override
  // ignore: library_private_types_in_public_api
  _WriteCommentPageState createState() => _WriteCommentPageState();
}

class _WriteCommentPageState extends State<WriteComment> {
  TextEditingController _controller = TextEditingController();

  double _rating = 0.0;
  bool _startLogged = false;

  @override
  void initState() {
    super.initState();
    if (widget.userRate != null && widget.userRate! > 0) {
      _rating = widget.userRate!;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 从查询参数中获取数据
    final movieId = GoRouterState.of(context).uri.queryParameters['movieId'];
    final movieName = GoRouterState.of(context).uri.queryParameters['movieName'];
    
    final finalId = widget.id ?? movieId;
    final finalMovieName = widget.movieName ?? movieName;
    if (!_startLogged) {
      _startLogged = true;
      Analytics.instance.logEvent(Ev.commentWriteStart, {
        P.movieId: finalId,
      });
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              S.of(context).writeComment_title, 
              style: TextStyle(
                color: Colors.white, 
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              finalMovieName ?? '', 
              style: TextStyle(
                color: Colors.white70, 
                fontSize: 22.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: ElevatedButton(
              onPressed: _controller.text.isEmpty ? null : () async {
                if (finalId == null || finalId.isEmpty) {
                  ToastService.showError(S.of(context).writeComment_verify_movieIdEmpty);
                  return;
                }

                showLoadingDialog(context);
                try {
                  final movieIdInt = int.tryParse(finalId) ?? 0;
                  if (_rating >= 0.1 && widget.rated != true) {
                    await ApiRequest().request(
                      path: '/movie/rate/save',
                      method: 'POST',
                      data: {
                        'movieId': movieIdInt,
                        'rate': _rating,
                      },
                      fromJsonT: (json) => json,
                    );
                  }
                  await ApiRequest().request(
                    path: '/movie/comment/save',
                    method: 'POST',
                    data: {
                      'movieId': movieIdInt,
                      'content': _controller.text,
                    },
                    fromJsonT: (json) => json,
                  );
                  Analytics.instance.logEvent(Ev.commentSubmit, {
                    P.movieId: finalId,
                    P.score: _rating,
                    P.type: 'comment',
                  });
                  if (!context.mounted) return;
                  hideLoadingDialog(context);
                  GoRouter.of(context).pop(true);
                } catch (error) {
                  if (!context.mounted) return;
                  hideLoadingDialog(context);
                  ToastService.showError(S.of(context).writeComment_publishFailed);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _controller.text.isEmpty 
                  ? Colors.white24 
                  : Colors.white,
                foregroundColor: _controller.text.isEmpty 
                  ? Colors.white54 
                  : const Color(0xFF1989FA),
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                S.of(context).writeComment_release,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              // 评分卡片（仅未评分时显示；评分只能一次，已评分不可再改）
              if (widget.rated != true)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(32.w),
                margin: EdgeInsets.only(bottom: 24.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      S.of(context).writeComment_rateTitle,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Column(
                      children: [
                        // 星星评分区域 - 固定容器
                        Container(
                          height: 60.h, // 固定高度
                          alignment: Alignment.center,
                          child: Rate(
                            maxRating: 10.0,
                            count: 10,
                            starSize: 48.w,
                            fontSize: 32.sp,
                            point: _rating,
                            filledColor: const Color(0xFFFF6B35),
                            unfilledColor: Colors.grey.shade300,
                            readOnly: false,
                            onRatingUpdate: (rating) {
                              setState(() {
                                _rating = rating;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // 分数显示区域 - 固定容器
                        Container(
                          width: 120.w, // 固定宽度
                          height: 48.h, // 固定高度
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Text(
                            '$_rating${S.of(context).common_unit_point}',
                            style: TextStyle(
                              fontSize: 32.sp, 
                              color: const Color(0xFFFF6B35),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 评论输入卡片
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).writeComment_contentTitle,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Input(
                        controller: _controller,
                        type: 'textarea',
                        placeholder: S.of(context).writeComment_hint,
                        maxLines: 8,
                        backgroundColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        horizontalPadding: 0.w,
                        textStyle: TextStyle(
                          fontSize: 26.sp,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                        cursorColor: const Color(0xFF1989FA),
                        placeholderStyle: TextStyle(
                          fontSize: 26.sp,
                          color: Colors.grey.shade500,
                        ),
                        onChange: (value) {
                          // 限制字数为1000字
                          if (value.length <= 1000) {
                            setState(() {
                              _controller.text = value;
                            });
                          } else {
                            // 如果超过1000字，截取前1000字
                            final truncatedText = value.substring(0, 1000);
                            _controller.text = truncatedText;
                            _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: truncatedText.length),
                            );
                          }
                        },
                        onSubmit: (val) {
                          if (val.length <= 1000) {
                            setState(() {
                              _controller.text = val;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // 字数统计
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            S.of(context).writeComment_shareExperience,
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          '${_controller.text.length}/1000',
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: _controller.text.length > 900 
                              ? const Color(0xFFFF6B35)
                              : Colors.grey.shade600,
                            fontWeight: _controller.text.length > 900 
                              ? FontWeight.w600 
                              : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}