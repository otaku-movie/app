import 'dart:convert';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/user/login_response.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final LanguageController languageController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String selectedLanguage = PlatformDispatcher.instance.locales.first.languageCode;

  // 控制密码是否可见
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      languageController.changeLanguage(selectedLanguage);
    });
    emailController.text = 'diy4869@gmail.com';
    passwordController.text = '123456';

  }

  @override
  void dispose() {
    super.dispose();
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

  void handleEmailPasswordLogin() {
    

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // 检查邮箱和密码是否为空
    if (email.isEmpty) {
      return ToastService.showError(S.of(context).login_email_verify_notNull);
    }
    // 检查邮箱和密码是否合法
    if (!isValidEmail(email)) {
      return ToastService.showError(S.of(context).login_email_verify_isValid);
    }  

    if (password.isEmpty) {
      return ToastService.showError(S.of(context).login_password_verify_notNull);
    }
    if (!isValidPassword(password)) {
      return ToastService.showError(S.of(context).login_password_verify_isValid);
    }
    
    String pwd = md5.convert(utf8.encode(passwordController.text)).toString();

    _showLoadingDialog(context);
    ApiRequest().request(
      path: '/user/login',
      method: 'POST',
      data: {
        "email": emailController.text,
        "password": pwd
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

        context.pushNamed('home');
      }
    
    }).catchError((err) {
      // setState(() {
      //   error = true;
      // });
    }).whenComplete(() {
      _hideLoadingDialog(context);
      // setState(() {
      //   loading = false;
      // });
    });
  }

  void handleGoogleLogin() async {
    try {
      _showLoadingDialog(context);
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _hideLoadingDialog(context);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // 调用后端API进行谷歌登录
      ApiRequest().request(
        path: '/user/googleLogin',
        method: 'POST',
        data: {
          "googleId": googleUser.id,
          "email": googleUser.email,
          "name": googleUser.displayName,
          "photoUrl": googleUser.photoUrl,
          "accessToken": googleAuth.accessToken,
        },
        fromJsonT: (json) {
          return LoginResponse.fromJson(json);
        },
      ).then((res) async {
        if (res.data != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          // 存储 token
          prefs.setString('token', res.data?.token ?? '');
          
          // 存储用户信息
          prefs.setString('userInfo', res.data.toString());

          context.pushNamed('home');
        }
      }).catchError((err) {
        ToastService.showError('谷歌登录失败，请重试');
      }).whenComplete(() {
        _hideLoadingDialog(context);
      });
      
    } catch (error) {
      _hideLoadingDialog(context);
      ToastService.showError('谷歌登录失败，请重试');
      print('Google login error: $error');
    }
  }

  void handleLineLogin() {
    print("Line login clicked");
  }

  Widget _getLanguageFlag(String languageCode) {
    String flag;
    switch (languageCode) {
      case 'zh':
        flag = '🇨🇳';
        break;
      case 'ja':
        flag = '🇯🇵';
        break;
      case 'en':
        flag = '🇺🇸';
        break;
      default:
        flag = '🌐';
    }
    
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: Colors.white.withOpacity(0.2),
      ),
      child: Center(
        child: Text(
          flag,
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
      ),
    );
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
                Icons.movie,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              S.of(context).login_loginButton, 
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  color: Colors.white,
                  size: 26.sp,
                ),
                SizedBox(width: 8.w),
                DropdownButton<String>(
                  value: selectedLanguage,
                  items: languageController.lang.map((entry) => DropdownMenuItem<String>(
                    value: entry['code'],
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _getLanguageFlag(entry['code'] as String),
                          SizedBox(width: 12.w),
                          Text(
                            entry['name'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                  dropdownColor: const Color(0xFF323233),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  underline: const SizedBox(),
                  onChanged: (value) {
                    if (value != null) {
                      languageController.changeLanguage(value);
                      selectedLanguage = value;
                    }
                  },
                ),
              ],
            ),
          ),
        ],
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
                  
                  // 登录表单卡片
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
                          S.of(context).login_loginButton,
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF323233),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          S.of(context).login_welcomeText,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: const Color(0xFF969799),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40.h),
                        
                        // 邮箱输入框
                        _buildEmailField(),
                        SizedBox(height: 24.h),
                        
                        // 密码输入框
                        _buildPasswordField(),
                        SizedBox(height: 32.h),
                        
                        // 登录按钮
                        _buildLoginButton(),
                        SizedBox(height: 24.h),
                        
                        // 分割线
                        _buildDivider(),
                        SizedBox(height: 24.h),
                        
                        // 谷歌登录按钮
                        _buildGoogleLoginButton(),
                SizedBox(height: 24.h),
                        
                        // 注册链接
                        _buildRegisterLink(),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // 忘记密码
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.pushNamed('forgotPassword');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF1989FA).withOpacity(0.1),
                              const Color(0xFF069EF0).withOpacity(0.1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(25.r),
                          border: Border.all(
                            color: const Color(0xFF1989FA).withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1989FA).withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_reset,
                              color: const Color(0xFF1989FA),
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              S.of(context).login_forgotPassword,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: const Color(0xFF1989FA),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
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
    return Container(
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
            color: const Color(0xFF969799),
            fontSize: 24.sp,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1989FA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.email_outlined,
              color: const Color(0xFF1989FA),
              size: 28.sp,
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
                  keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 28.sp,
          color: const Color(0xFF323233),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
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
            color: const Color(0xFF969799),
            fontSize: 24.sp,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12.w),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1989FA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.lock_outline,
              color: const Color(0xFF1989FA),
              size: 28.sp,
            ),
          ),
          suffixIcon: Container(
            margin: EdgeInsets.all(12.w),
            child: IconButton(
                      icon: Icon(
                _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF969799),
                size: 28.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
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
        style: TextStyle(
          fontSize: 28.sp,
          color: const Color(0xFF323233),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
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
          onTap: handleEmailPasswordLogin,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.login,
                  color: Colors.white,
                  size: 32.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  S.of(context).login_loginButton,
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

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.h,
            color: const Color(0xFFE6E6E6),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            S.of(context).login_or,
            style: TextStyle(
              fontSize: 24.sp,
              color: const Color(0xFF969799),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1.h,
            color: const Color(0xFFE6E6E6),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleLoginButton() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE6E6E6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: handleGoogleLogin,
          child: Center(
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Stack(
                      children: [
                        // 谷歌Logo背景
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4285F4), // 蓝色
                                Color(0xFF34A853), // 绿色
                                Color(0xFFFBBC05), // 黄色
                                Color(0xFFEA4335), // 红色
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        // 白色G字母
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              'G',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  S.of(context).login_googleLogin,
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: const Color(0xFF323233),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.of(context).login_noAccount,
          style: TextStyle(
            fontSize: 24.sp,
            color: const Color(0xFF969799),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            context.pushNamed('register');
          },
          child: Text(
            S.of(context).register_registerButton,
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
