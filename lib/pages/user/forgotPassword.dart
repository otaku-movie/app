import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/generated/l10n.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isCodeSent = false;
  bool _isLoading = false;

  Future<void> _sendVerificationCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 模拟发送验证码到邮箱（实际开发中调用后端API）
      await Future.delayed(Duration(seconds: 2)); // 模拟网络请求
      setState(() {
        _isCodeSent = true;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).forgotPassword_verificationCodeSent)),
      );
    }
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 模拟验证验证码并重置密码（实际开发中调用后端API）
      await Future.delayed(Duration(seconds: 2)); // 模拟网络请求
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).forgotPassword_passwordResetSuccess)),
      );

      Navigator.pop(context); // 返回登录页面
    }
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
                Icons.lock_reset,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              S.of(context).forgotPassword_title,
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
                  
                  // 忘记密码表单卡片
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 标题
                          Text(
                            S.of(context).forgotPassword_title,
                            style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF323233),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            S.of(context).forgotPassword_description,
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
                          
                          // 验证码和新密码字段（条件显示）
                          if (_isCodeSent) ...[
                            _buildVerificationCodeField(),
                            SizedBox(height: 24.h),
                            _buildNewPasswordField(),
                            SizedBox(height: 32.h),
                          ],
                          
                          // 提交按钮
                          _buildSubmitButton(),
                          SizedBox(height: 24.h),
                          
                          // 返回登录链接
                          _buildBackToLoginLink(),
                        ],
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
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: S.of(context).forgotPassword_emailAddress,
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
              Icons.email_outlined,
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
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 28.sp,
          color: const Color(0xFF323233),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).forgotPassword_emailRequired;
          }
          if (!value.contains('@')) {
            return S.of(context).forgotPassword_emailInvalid;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildVerificationCodeField() {
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
      child: TextFormField(
        controller: _verificationCodeController,
        decoration: InputDecoration(
          labelText: S.of(context).forgotPassword_verificationCode,
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
        style: TextStyle(
          fontSize: 28.sp,
          color: const Color(0xFF323233),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).forgotPassword_verificationCodeRequired;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNewPasswordField() {
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
      child: TextFormField(
        controller: _newPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: S.of(context).forgotPassword_newPassword,
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
              Icons.lock_outline,
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
        style: TextStyle(
          fontSize: 28.sp,
          color: const Color(0xFF323233),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).forgotPassword_newPasswordRequired;
          }
          if (value.length < 6) {
            return S.of(context).forgotPassword_passwordTooShort;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
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
          onTap: _isLoading
              ? null
              : _isCodeSent ? _resetPassword : _sendVerificationCode,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading) ...[
                  SizedBox(
                    width: 24.sp,
                    height: 24.sp,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Icon(
                  _isCodeSent ? Icons.lock_reset : Icons.send,
                  color: Colors.white,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  _isCodeSent ? S.of(context).forgotPassword_resetPassword : S.of(context).forgotPassword_sendVerificationCode,
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

  Widget _buildBackToLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.of(context).forgotPassword_rememberPassword,
          style: TextStyle(
            fontSize: 24.sp,
            color: const Color(0xFF969799),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Text(
            S.of(context).forgotPassword_backToLogin,
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