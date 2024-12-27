import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/rate.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otaku_movie/components/Input.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/utils/toast.dart';


// ignore: must_be_immutable
class WriteComment extends StatefulWidget {
  String? id;
  String? movieName;

  WriteComment({super.key, this.id, this.movieName});

  @override
  // ignore: library_private_types_in_public_api
  _WriteCommentPageState createState() => _WriteCommentPageState();
}

class _WriteCommentPageState extends State<WriteComment> {
  TextEditingController _controller = TextEditingController();

  double _rating = 0.0;

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
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Space(
          direction: 'column',
          bottom: 4.h,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Text(S.of(context).writeComment_title, style: TextStyle(color: Colors.white, fontSize: 32.sp)),
          Text(widget.movieName ?? '', style: TextStyle(color: Colors.white54, fontSize: 24.sp))
        ]),
        actions: [
          TextButton(
            onPressed: () {
              if (_controller.text.isEmpty) {
                ToastService.showInfo(S.of(context).writeComment_verify_notNull);
                return;
              }
              if (_rating == 0) {
                ToastService.showInfo(S.of(context).writeComment_verify_notRate);
                return;
              }
              showLoadingDialog(context);
              ApiRequest().request(
                path: '/movie/comment/save',
                method: 'POST',
                data: {
                  'movieId': int.parse(widget.id!),
                  'content': _controller.text,
                  'rate': _rating,
                },
                fromJsonT: (json) {
                  return json;
                },
              ).then((res) {
                if (res.data != null) {
                  // ignore: use_build_context_synchronously
                  GoRouter.of(context).pop();
                }
              }).whenComplete(() {
                // ignore: use_build_context_synchronously
                hideLoadingDialog(context);
              });
            }, 
            child: Text(S.of(context).writeComment_release, style: TextStyle(
              color:  _controller.text.isEmpty ? Colors.white38 : Colors.white, fontSize: 32.sp
            ))
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.w),
          alignment: Alignment.center,
          child: Space(
            direction: 'column',
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Space(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  right: 20.w,
                  children: [
                    Rate(
                      maxRating: 10.0, // 最大评分10分
                      count: 10, // 5颗星
                      starSize: 58.w, // 星星大小
                      fontSize: 36.sp,
                      filledColor: Colors.yellow.shade700, // 已填充的颜色
                      unfilledColor: Colors.grey.shade300, // 未填充的颜色
                      readOnly: false, // 可以评分
                      onRatingUpdate: (rating) {
                        print("当前评分：$rating");
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    SizedBox(
                      width: 110.w,  // 固定文字容器宽度
                      child: Text(
                        '$_rating分',
                        style: TextStyle(
                          fontSize: 36.sp, 
                          color: Colors.yellow.shade800
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xffe5e5e5),
                        width: 1.w
                      )
                    )
                  ),
                  child: Input(
                    controller: _controller,
                    type: 'textarea',
                    placeholder: S.of(context).writeComment_hint,
                    maxLines: 10,
                    onChange: (value) {
                      setState(() {
                        _controller.text = value;
                      });
                    },
                    onSubmit: (val) {
                      setState(() {
                        _controller.text = val;
                      });
                    },
                  ),
                )      
              
            ]
          ),
        )
      ),
    );
  }
}