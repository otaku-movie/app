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
            TextButton(
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
              child: Text(S.of(context).userProfile_save, style: TextStyle(color: Colors.white, fontSize: 30.sp))
            ) : 
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  isEdit = true;
                  usernameController.text = data.name ?? '';
                });
                // Navigator.pushNamed(context, '/user/edit');
              },
            ),
        ],
      ),
      body: Container(
        child: Space(
          direction: 'column',
          children: [
            
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 10.h
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.w,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).userProfile_avatar),

                  Cropper(
                    child: CircleAvatar(
                      radius: 50.w,
                      backgroundColor: Colors.grey.shade300,
                      // ignore: unnecessary_null_comparison
                      backgroundImage: data.cover != null && data.cover!.isEmpty &&  _file != null ? MemoryImage(_file) : NetworkImage(data.cover ?? ''),
                    ),
                    onCropSuccess: (file) {
                      if (mounted) {
                        setState(() {
                          _file = file;
                        });

                        FormData formData =  FormData.fromMap({
                          'file': MultipartFile.fromBytes(
                            _file,
                            filename: "upload.png", // 服务器需要的文件名
                            // contentType: MediaType("image", "png"),
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
                          print('url: ${res.data?.url}');
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
                      print('file: $file');
                    },
                  ),
                ]
              ),
            ),
            Container(
              height: 80.h,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 10.h
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.w,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).userProfile_username),
                  isEdit ? Input(
                      controller: usernameController,
                      width: 400.w,
                      horizontalPadding: 20.w,
                      placeholder: S.of(context).userProfile_edit_username_placeholder,
                      borderRadius: BorderRadius.circular(6.0),
                      border: BorderSide(color: Colors.grey.shade300),
                      cursorColor: Colors.black,
                      suffixIcon: usernameController.text.isEmpty ? null : GestureDetector(
                        child: Icon(Icons.clear, color: Colors.grey.shade400),
                        onTap: () => {
                         setState(() {
                          usernameController.text = '';
                        })
                        },
                      ) ,
                      textStyle: TextStyle(fontSize: 28.sp),
                      onChange: (val) {
                        setState(() {
                          usernameController.text = val;
                        });
                      },
                      onSubmit: (value) {
                        if (usernameController.text.isEmpty) {
                          return ToastService.showError(S.of(context).register_username_verify_notNull);
                        }
                      },
                    ) : Text(data.name ?? '', style: const TextStyle(color: Colors.black45))
                ]
              ),
            ),
            Container(
              height: 80.h,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 10.h
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.w,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).userProfile_email),
                 
                  Text(data.email ?? '', style: const TextStyle(color: Colors.black45))
                ]
              ),
            ),
            
            Container(
              height: 80.h,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 20.h
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.w,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).userProfile_registerTime),
                  Text(data.createTime ?? '', style: const TextStyle(color: Colors.black45),),
                ]
              ),
            ),
          ],
        ),
      )
    )
    );
  }
}