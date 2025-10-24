import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/sendVerifyCode.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/user/login_response.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  String emailToken = '';
  bool _obscureText = true; // 控制密码是否可见
  String verifyCode = '';
  bool loading = false;
  
  // 错误状态管理
  String? emailError;
  String? usernameError;
  String? passwordError;
  String? repeatPasswordError;
  String? verifyCodeError;

  // 验证邮箱
  void _validateEmail() {
    String email = emailController.text.trim();
    setState(() {
      if (email.isEmpty) {
        emailError = S.of(context).login_email_verify_notNull;
      } else if (!isValidEmail(email)) {
        emailError = S.of(context).login_email_verify_isValid;
      } else {
        emailError = null;
      }
    });
  }

  // 验证用户名
  void _validateUsername() {
    String username = usernameController.text.trim();
    setState(() {
      if (username.isEmpty) {
        usernameError = S.of(context).register_username_verify_notNull;
      } else if (username.length < 2) {
        usernameError = '用户名至少需要2个字符';
      } else {
        usernameError = null;
      }
    });
  }

  // 验证密码
  void _validatePassword() {
    String password = passwordController.text.trim();
    setState(() {
      if (password.isEmpty) {
        passwordError = S.of(context).login_password_verify_notNull;
      } else if (!isValidPassword(password)) {
        passwordError = S.of(context).login_password_verify_isValid;
      } else {
        passwordError = null;
      }
    });
  }

  // 验证确认密码
  void _validateRepeatPassword() {
    String password = passwordController.text.trim();
    String repeatPassword = repeatPasswordController.text.trim();
    setState(() {
      if (repeatPassword.isEmpty) {
        repeatPasswordError = '请确认密码';
      } else if (password != repeatPassword) {
        repeatPasswordError = S.of(context).register_passwordNotMatchRepeatPassword;
      } else {
        repeatPasswordError = null;
      }
    });
  }

  // 验证验证码
  void _validateVerifyCode() {
    setState(() {
      if (verifyCode.isEmpty) {
        verifyCodeError = '请输入验证码';
      } else if (verifyCode.length != 6) {
        verifyCodeError = S.of(context).register_verifyCode_verify_isValid;
      } else {
        verifyCodeError = null;
      }
    });
  }

  bool checkEmail () {
    String email = emailController.text.trim();

    // 检查邮箱和密码是否为空
    if (email.isEmpty) {
      ToastService.showError(S.of(context).login_email_verify_notNull);
      return false;
    }
    // 检查邮箱和密码是否合法
    if (!isValidEmail(email)) {
      ToastService.showError(S.of(context).login_email_verify_isValid);
      return false;
    }  
    return true;
  }

  
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 点击外部不会关闭弹窗
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent, // 透明背景
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ), // 显示加载动画
          ),
        );
      },
    );
  }

  // 关闭加载弹窗
  void _hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop(); // 关闭弹窗
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: CustomAppBar(
        backgroundColor: const Color(0xFF1989FA),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.person_add,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              S.of(context).register_registerButton,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1989FA).withOpacity(0.05),
                  const Color(0xFFF7F8FA),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40.h),
                  
                  // Logo 区域
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.movie,
                            color: const Color(0xFF1989FA),
                            size: 32.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Otaku Movie',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF323233),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // 注册表单卡片
                  Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 标题
                        Text(
                          S.of(context).register_registerButton,
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF323233),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '创建您的账户，开始电影之旅',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: const Color(0xFF969799),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40.h),
                        
                        // 表单字段
                        _buildEmailField(),
                        SizedBox(height: 24.h),
                        
                        _buildUsernameField(),
                        SizedBox(height: 24.h),
                        
                        _buildPasswordField(),
                        SizedBox(height: 24.h),
                        
                        _buildRepeatPasswordField(),
                        SizedBox(height: 24.h),
                        
                        _buildVerifyCodeField(),
                        SizedBox(height: 32.h),
                        
                        _buildRegisterButton(),
                        SizedBox(height: 24.h),
                        
                        _buildLoginLink(),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            controller: emailController,
            decoration: InputDecoration(
              labelText: S.of(context).login_email_text,
              labelStyle: TextStyle(
                color: emailError != null ? Colors.red : const Color(0xFF969799),
                fontSize: 24.sp,
              ),
              prefixIcon: Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: emailError != null 
                    ? Colors.red.withOpacity(0.1)
                    : const Color(0xFF1989FA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.email_outlined,
                  color: emailError != null ? Colors.red : const Color(0xFF1989FA),
                  size: 24.sp,
                ),
              ),
              filled: true,
              fillColor: emailError != null 
                ? Colors.red.withOpacity(0.05)
                : const Color(0xFFF7F8FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: emailError != null ? Colors.red : const Color(0xFF1989FA),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            ),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontSize: 28.sp,
              color: const Color(0xFF323233),
            ),
            onChanged: (val) {
              setState(() {
                emailController.text = val;
              });
              _validateEmail();
            },
            onSubmitted: (val) {
              setState(() {
                emailController.text = val;
              });
              _validateEmail();
            },
          ),
        ),
        if (emailError != null) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                emailError!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            controller: usernameController,
            decoration: InputDecoration(
              labelText: S.of(context).register_username_text,
              labelStyle: TextStyle(
                color: usernameError != null ? Colors.red : const Color(0xFF969799),
                fontSize: 24.sp,
              ),
              prefixIcon: Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: usernameError != null 
                    ? Colors.red.withOpacity(0.1)
                    : const Color(0xFF1989FA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: usernameError != null ? Colors.red : const Color(0xFF1989FA),
                  size: 24.sp,
                ),
              ),
              filled: true,
              fillColor: usernameError != null 
                ? Colors.red.withOpacity(0.05)
                : const Color(0xFFF7F8FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: usernameError != null ? Colors.red : const Color(0xFF1989FA),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            ),
            style: TextStyle(
              fontSize: 28.sp,
              color: const Color(0xFF323233),
            ),
            onChanged: (val) {
              _validateUsername();
            },
          ),
        ),
        if (usernameError != null) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                usernameError!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            controller: passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: S.of(context).login_password_text,
              labelStyle: TextStyle(
                color: passwordError != null ? Colors.red : const Color(0xFF969799),
                fontSize: 24.sp,
              ),
              prefixIcon: Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: passwordError != null 
                    ? Colors.red.withOpacity(0.1)
                    : const Color(0xFF1989FA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.lock_outline,
                  color: passwordError != null ? Colors.red : const Color(0xFF1989FA),
                  size: 24.sp,
                ),
              ),
              suffixIcon: Container(
                margin: EdgeInsets.all(12.w),
                child: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF969799),
                    size: 24.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              filled: true,
              fillColor: passwordError != null 
                ? Colors.red.withOpacity(0.05)
                : const Color(0xFFF7F8FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: passwordError != null ? Colors.red : const Color(0xFF1989FA),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            ),
            style: TextStyle(
              fontSize: 28.sp,
              color: const Color(0xFF323233),
            ),
            onChanged: (val) {
              _validatePassword();
              _validateRepeatPassword(); // 同时验证确认密码
            },
          ),
        ),
        if (passwordError != null) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                passwordError!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildRepeatPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            controller: repeatPasswordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: S.of(context).register_repeatPassword_text,
              labelStyle: TextStyle(
                color: repeatPasswordError != null ? Colors.red : const Color(0xFF969799),
                fontSize: 24.sp,
              ),
              prefixIcon: Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: repeatPasswordError != null 
                    ? Colors.red.withOpacity(0.1)
                    : const Color(0xFF1989FA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.lock_outline,
                  color: repeatPasswordError != null ? Colors.red : const Color(0xFF1989FA),
                  size: 24.sp,
                ),
              ),
              suffixIcon: Container(
                margin: EdgeInsets.all(12.w),
                child: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF969799),
                    size: 24.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              filled: true,
              fillColor: repeatPasswordError != null 
                ? Colors.red.withOpacity(0.05)
                : const Color(0xFFF7F8FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide(
                  color: repeatPasswordError != null ? Colors.red : const Color(0xFF1989FA),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            ),
            style: TextStyle(
              fontSize: 28.sp,
              color: const Color(0xFF323233),
            ),
            onChanged: (val) {
              _validateRepeatPassword();
            },
          ),
        ),
        if (repeatPasswordError != null) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                repeatPasswordError!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildVerifyCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SendVerifyCode(
          sendText: S.of(context).register_send,
          email: emailController.text,
          beforeSend: () {
            return checkEmail();
          },
          onSubmit: (val) {
            setState(() {
              verifyCode = val;
            });
            _validateVerifyCode();
          },
          onChange: (val) {
            setState(() {
              verifyCode = val;
            });
            _validateVerifyCode();
          },
          onSend: (token) {
            ToastService.showInfo(S.of(context).common_components_sendVerifyCode_success);
            setState(() {
              emailToken = token;
            });
          },
        ),
        if (verifyCodeError != null) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                verifyCodeError!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1989FA), Color(0xFF069EF0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1989FA).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            if (loading) {
              return;
            }
            
            // 验证所有字段
            _validateEmail();
            _validateUsername();
            _validatePassword();
            _validateRepeatPassword();
            _validateVerifyCode();
            
            // 检查是否有错误
            if (emailError != null || usernameError != null || 
                passwordError != null || repeatPasswordError != null || 
                verifyCodeError != null) {
              return;
            }
            
            if (checkEmail() == false) {
              return;
            }
            
            String pwd = md5.convert(utf8.encode(passwordController.text)).toString();

            setState(() {
              loading = true;
            });
            ApiRequest().request(
              path: '/user/register',
              method: 'POST',
              data: {
                "email": emailController.text,
                "password": pwd,
                "username": usernameController.text,
                "verifyCode": verifyCode,
                "token": emailToken
              },
              fromJsonT: (json) {
                return LoginResponse.fromJson(json);
              },
            ).then((res) async {
              if (res.data != null) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                // 存储 token
                prefs.setString('token', res.data?.token ?? '');
                
                // 存储用户信息（可以将 Map 转换为 JSON 字符串存储）
                prefs.setString('userInfo', res.data.toString());
                // ignore: use_build_context_synchronously
                context.pushNamed('home');
              }
            }).whenComplete(() {
              setState(() {
                loading = false;
              });
            });
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading) ...[
                  LoadingAnimationWidget.hexagonDots(
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                ],
                Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  S.of(context).register_registerButton,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.of(context).register_haveAccount,
          style: TextStyle(
            fontSize: 24.sp,
            color: const Color(0xFF969799),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            context.pushNamed('login');
          },
          child: Text(
            S.of(context).register_loginHere,
            style: TextStyle(
              fontSize: 24.sp,
              color: const Color(0xFF1989FA),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
