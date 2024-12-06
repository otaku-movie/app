import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/sendVerifyCode.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/log/index.dart';
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

  void handleGoogleLogin() {
    print("Google login clicked");
  }

  void handleLineLogin() {
    print("Line login clicked");
  }

  @override
  Widget build(BuildContext context) {
    // _showLoadingDialog(context);

    return Scaffold(
      
      appBar: CustomAppBar(
        // backgroundColor: Colors.blue,
        title: Row(
          children: [
            Image.asset('assets/image/kimetsu-movie.jpg', height: 30), 
            SizedBox(width: 20.w),
            Text(S.of(context).login_loginButton, style: const TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          DropdownButton<String>(
            value: selectedLanguage,
            items: languageController.lang.map((entry) => DropdownMenuItem<String>(
              value: entry['code'],
              child: Text(entry['name'] as String, style: const TextStyle(color: Colors.white) ),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                languageController.changeLanguage(value);
                selectedLanguage = value;
              }
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h), 
                Center(
                  child: Image.asset(
                    'assets/image/kimetsu-movie.jpg', 
                    height: 120, 
                  ),
                ),
                SizedBox(height: 24.h),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: S.of(context).login_email_text,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: passwordController,
                  obscureText: _obscureText, // 控制密码是否可见
                  decoration: InputDecoration(
                    labelText: S.of(context).login_password_text,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 34.h),
                ElevatedButton(
                  onPressed: handleEmailPasswordLogin,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(S.of(context).login_loginButton, style: const TextStyle(color: Colors.blue)),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).login_noAccount),
                    TextButton(
                      onPressed: () {
                        context.pushNamed('register');
                      },
                      child: Text(S.of(context).register_registerButton, style: const TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
