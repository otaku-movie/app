import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/generated/l10n.dart';

class SendVerifyCode extends StatefulWidget {
  int? time;
  String sendText;
  VoidCallback onSend;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onSubmit;
  final void Function()? onTap;

  SendVerifyCode({
    super.key,
    required this.sendText,
    required this.onSend,
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

  late Timer _timer; // 定时器，用来倒计时
  int _countdown = 0; // 倒计时时间，单位秒
  int defaultTime = 0;
  bool send = false;

  @override
  void initState() {
    super.initState();
    _countdown = widget.time!;
    defaultTime = widget.time!;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // 模拟发送验证码并开始倒计时
  void sendVerificationCode() {
    // 在发送验证码之前进行验证
    _verifyCode();
  }

  // 验证用户输入的验证码
  void _verifyCode() {
    
    setState(() {
      send = true;
    });
    // 调用发送验证码后的回调
    widget.onSend();

      // 开始倒计时
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });
      if (_countdown == 0) {
        _timer.cancel(); // 停止倒计时
        setState(() {
          _countdown = defaultTime; // 重置倒计时
          send = false;
        });
      }
    });  
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: verificationCodeController,
            decoration: InputDecoration(
              labelText: S.of(context).login_verificationCode,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.confirmation_number),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
            ),
            keyboardType: TextInputType.number,
            style: const TextStyle(height: 1),
             onTap: widget.onTap,
            onChanged: widget.onChange,
            onSubmitted: widget.onSubmit,
          ),
        ),
        SizedBox(width: 20.w),
        GestureDetector(
          onTap: send ? null : sendVerificationCode,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            decoration: send ? BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.04),
              border: Border.all(color: const Color(0XFFd9d9d9)),
              borderRadius: BorderRadius.circular(4),
            ) :  BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(4),
            ),
            constraints: BoxConstraints(
              minWidth: 150.w, // 最小宽度
            ),
            child: Center(
              child: send ? Text(
                '${_countdown}s',
                style: TextStyle(
                    color: const Color.fromRGBO(0, 0, 0, 0.25),
                    fontSize: 32.sp),
              ) : Text(
                widget.sendText,
                style: TextStyle(color: Colors.white, fontSize: 32.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
