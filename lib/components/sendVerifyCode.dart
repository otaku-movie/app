import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/verify_code_response.dart';

typedef BoolCallback = bool Function();

class SendVerifyCode extends StatefulWidget {
  int? time;
  String sendText;
  String? email;
  ValueChanged<String> onSend;
  BoolCallback beforeSend; 
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onSubmit;
  final void Function()? onTap;

  SendVerifyCode({
    super.key,
    required this.sendText,
    required this.onSend,
    required this.beforeSend,
    this.email,
    this.onChange,
    this.onSubmit,
    this.onTap,
    this.time = 15,
    
  });

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<SendVerifyCode> {
  final TextEditingController verificationCodeController = TextEditingController();

  Timer? _timer; // 定时器，用来倒计时
  int _countdown = 0; // 倒计时时间，单位秒
  int defaultTime = 0;
  bool send = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _countdown = widget.time!;
    defaultTime = widget.time!;
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel(); 
  }
  
  // 模拟发送验证码并开始倒计时
  void sendVerificationCode() {
    // 在发送验证码之前进行验证
    if (widget.beforeSend() == true) {
      _verifyCode();
    }
  }

  // 验证用户输入的验证码
  void _verifyCode() {
    setState(() {
      loading = true;
    }); 
   
    // 调用发送验证码后的回调
    ApiRequest().request(
      path: '/verify/sendCode',
      method: 'POST',
      data: {
        "email": widget.email,
      },
      fromJsonT: (json) {
        return VerifyCodeResponse.fromJson(json);
      },
    ).then((res) async {
       widget.onSend(res.data?.token ?? '');

       setState(() {
        send = true;
      });
        // 开始倒计时
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _countdown--;
        });
        if (_countdown == 0) {
          _timer?.cancel(); // 停止倒计时
          setState(() {
            _countdown = defaultTime; // 重置倒计时
            send = false;
          });
        }
      });  
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
   
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: verificationCodeController,
              decoration: InputDecoration(
                labelText: S.of(context).login_verificationCode,
                labelStyle: TextStyle(
                  color: const Color(0xFF969799),
                  fontSize: 24.sp,
                ),
                prefixIcon: Container(
                  margin: EdgeInsets.all(12.w),
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1989FA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.security_outlined,
                    color: const Color(0xFF1989FA),
                    size: 24.sp,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFF7F8FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(
                    color: Color(0xFF1989FA),
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 28.sp,
                color: const Color(0xFF323233),
                height: 1.2,
              ),
              onTap: widget.onTap,
              onChanged: widget.onChange,
              onSubmitted: widget.onSubmit,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        
        GestureDetector(
          onTap: send ? null : sendVerificationCode,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            decoration: BoxDecoration(
              gradient: send ? null : const LinearGradient(
                colors: [Color(0xFF1989FA), Color(0xFF069EF0)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              color: send ? const Color(0xFFF7F8FA) : null,
              borderRadius: BorderRadius.circular(16.r),
              border: send ? Border.all(
                color: const Color(0xFFE5E5E5),
                width: 1,
              ) : null,
              boxShadow: send ? null : [
                BoxShadow(
                  color: const Color(0xFF1989FA).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            constraints: BoxConstraints(
              minWidth: 140.w,
              minHeight: 60.h,
            ),
            child: Center(
              child: send ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: const Color(0xFF969799),
                    size: 20.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${_countdown}s',
                    style: TextStyle(
                      color: const Color(0xFF969799),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ) : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (loading) ...[
                    SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                  Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    widget.sendText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
