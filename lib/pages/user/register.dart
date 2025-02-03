import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/cropper.dart';
import 'package:otaku_movie/components/sendVerifyCode.dart';
import 'package:otaku_movie/components/space.dart';
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
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text(S.of(context).register_registerButton, style: const TextStyle(color: Colors.white)),
      ),
      body: GestureDetector(
        onTap: () {
          // 让所有输入框失去焦点
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Space(
              direction:  'column',
              bottom: 20.h,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: S.of(context).login_email_text,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (val) {
                    setState(() {
                      emailController.text = val;
                    });
                  },
                  onSubmitted: (val) {
                    setState(() {
                      emailController.text = val;
                    });
                  },
                ),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: S.of(context).register_username_text,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
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
                    enabledBorder: OutlineInputBorder(
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
                TextField(
                  controller: repeatPasswordController,
                  obscureText: _obscureText, // 控制密码是否可见
                  decoration: InputDecoration(
                    labelText: S.of(context).register_repeatPassword_text,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
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
                  },
                  onChange: (val) {
                    setState(() {
                      verifyCode = val;
                    });
                  },
                  onSend: (token) {
                    ToastService.showInfo(S.of(context).common_components_sendVerifyCode_success);
                    setState(() {
                      emailToken = token;
                    });
                  }),

                // 确认密码输入框

                // 注册按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (loading) {
                        return;
                      }
                      if (checkEmail() == false) {
                        return;
                      }
                      
                      String password = passwordController.text.trim();

                      if (password.isEmpty) {
                        return ToastService.showError(S.of(context).login_password_verify_notNull);
                      }
                      if (usernameController.text.isEmpty) {
                        return ToastService.showError(S.of(context).register_username_verify_notNull);
                      }
                      if (!isValidPassword(password)) {
                        return ToastService.showError(S.of(context).login_password_verify_isValid);
                      }
                      if (passwordController.text != repeatPasswordController.text) {
                        return ToastService.showError(S.of(context).register_passwordNotMatchRepeatPassword);
                      }

                      if (verifyCode.length != 6) {
                        return ToastService.showError(S.of(context).register_verifyCode_verify_isValid);
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
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      
                    ),
                    child: Space(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      right: 20.w,
                      children: [
                        loading ? LoadingAnimationWidget.hexagonDots(
                          color: Colors.white,
                          size: 50.w,
                        ) : Container(),
                        Text(S.of(context).register_registerButton, style: TextStyle(fontSize: 32.sp)),
                      ]
                    ), 
                  ),
                ),


                // 跳转登录提示
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).register_haveAccount),
                    TextButton(
                      onPressed: () {
                        context.pushNamed('login');
                      },
                      child: Text(S.of(context).register_loginHere),
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
