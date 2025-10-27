import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/Input.dart';
import 'package:otaku_movie/components/cropper.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/upload_response.dart';
import 'package:otaku_movie/response/user/user_detail_response.dart';
import 'package:otaku_movie/utils/toast.dart';

class UserProfile extends StatefulWidget {
  final String? id;

  const UserProfile({super.key, required this.id});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfile> {
  TextEditingController usernameController = TextEditingController();
  UserDetailResponse data = UserDetailResponse();
  Uint8List _file = Uint8List(0);
  bool isEdit = false;

  void getData() {
     ApiRequest().request(
      path: '/user/detail',
      method: 'GET',
      fromJsonT: (json) {
        return UserDetailResponse.fromJson(json);
      },
    ).then((res) async {
      if (res.data != null) {
        setState(() {
          data = res.data!;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          isEdit = false;
        });
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: S.of(context).userProfile_title,
        actions: [
          isEdit ? 
            Container(
              margin: EdgeInsets.only(right: 8.w),
              child: ElevatedButton(
                onPressed: ()  {
                  if (usernameController.text.isEmpty) {
                    return ToastService.showError(S.of(context).register_username_verify_notNull);
                  }
                  
                  ApiRequest().request(
                    path: '/user/updateUserInfo',
                    method: 'POST',
                    data: {
                      "id": data.id,
                      "email": data.email,
                      "username": usernameController.text,
                    },
                    fromJsonT: (json) {},
                  ).then((res) async {
                    if (res.code == 200) {
                      ToastService.showSuccess(res.message ?? '');
                      setState(() {
                        isEdit = false;
                      });
                      getData();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1989FA),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(
                      color: const Color(0xFF1989FA),
                      width: 1.5,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save, size: 24.sp),
                    SizedBox(width: 6.w),
                    Text(
                      S.of(context).userProfile_save,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ) : 
            Container(
              margin: EdgeInsets.only(right: 8.w),
              child: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isEdit = true;
                    usernameController.text = data.name ?? '';
                  });
                },
              ),
            ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFF1F5F9),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              
              // 头像区域
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 头像
                    Stack(
                      children: [
                        Cropper(
                          child: CircleAvatar(
                            radius: 60.w,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _file.isNotEmpty 
                                ? MemoryImage(_file) 
                                : (data.cover != null && data.cover!.isNotEmpty 
                                    ? NetworkImage(data.cover!) 
                                    : null),
                            child: (_file.isEmpty && (data.cover == null || data.cover!.isEmpty))
                                ? Icon(Icons.person, size: 60.sp, color: Colors.grey.shade400)
                                : null,
                          ),
                          onCropSuccess: (file) {
                            if (mounted) {
                              setState(() {
                                _file = file;
                              });

                              FormData formData = FormData.fromMap({
                                'file': MultipartFile.fromBytes(
                                  _file,
                                  filename: "upload.png",
                                ),
                              });
              
                              // 上传文件
                              ApiRequest().request(
                                path: '/upload',
                                method: 'POST',
                                data: formData,
                                fromJsonT: (json) {
                                  return UploadResponse.fromJson(json);
                                },
                                headers: {
                                  "Content-Type": "multipart/form-data",
                                }
                              ).then((res) async {
                                if (res.code == 200) {
                                  ApiRequest().request(
                                    path: '/user/updateUserInfo',
                                    method: 'POST',
                                    data: {
                                      "id": data.id,
                                      "cover": res.data?.url,
                                      "email": data.email,
                                      "username": usernameController.text,
                                    },
                                    fromJsonT: (json) {},
                                  ).then((res) async {
                                    if (res.code == 200) {
                                      ToastService.showSuccess(res.message ?? '');
                                      setState(() {
                                        isEdit = false;
                                      });
                                      getData();
                                    }
                                  });
                                }
                              });
                            }
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1989FA),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    Text(
                      S.of(context).userProfile_avatar,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20.h),
              
              
              // 用户信息卡片
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 用户名
                    _buildInfoItem(
                      icon: Icons.person_outline,
                      label: S.of(context).userProfile_username,
                      value: data.name ?? '',
                      isEditable: true,
                      child: isEdit ? Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1989FA).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: const Color(0xFF1989FA).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Input(
                                controller: usernameController,
                                horizontalPadding: 16.w,
                                placeholder: S.of(context).userProfile_edit_username_placeholder,
                                borderRadius: BorderRadius.circular(12.r),
                                border: BorderSide.none,
                                cursorColor: const Color(0xFF1989FA),
                                suffixIcon: usernameController.text.isEmpty ? null : GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    child: Icon(
                                      Icons.clear, 
                                      color: Colors.grey.shade500, 
                                      size: 18.sp
                                    ),
                                  ),
                                  onTap: () => setState(() {
                                    usernameController.text = '';
                                  }),
                                ),
                                textStyle: TextStyle(
                                  fontSize: 18.sp,
                                  color: const Color(0xFF323233),
                                  fontWeight: FontWeight.w500,
                                ),
                                onChange: (val) => setState(() {
                                  usernameController.text = val;
                                }),
                                onSubmit: (value) {
                                  if (usernameController.text.isEmpty) {
                                    return ToastService.showError(S.of(context).register_username_verify_notNull);
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16.sp,
                                  color: Colors.grey.shade500,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  S.of(context).userProfile_edit_tip,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ) : null,
                    ),
                    
                    _buildDivider(),
                    
                    // 邮箱
                    _buildInfoItem(
                      icon: Icons.email_outlined,
                      label: S.of(context).userProfile_email,
                      value: data.email ?? '',
                    ),
                    
                    _buildDivider(),
                    
                    // 注册时间
                    _buildInfoItem(
                      icon: Icons.calendar_today_outlined,
                      label: S.of(context).userProfile_registerTime,
                      value: data.createTime ?? '',
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      )
    )
    );
  }
  
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool isEditable = false,
    Widget? child,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1989FA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: const Color(0xFF1989FA),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                child ?? Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: const Color(0xFF323233),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      height: 1.h,
      color: Colors.grey.shade200,
    );
  }
}