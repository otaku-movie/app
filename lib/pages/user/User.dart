import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/user/user_detail_response.dart';
import 'package:otaku_movie/utils/index.dart';
import '../../components/CustomAppBar.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _PageState();
}

class _PageState extends State<UserInfo> {
  final LanguageController languageController = Get.find();
  UserDetailResponse data = UserDetailResponse();
  
  String langName = '';
  String token = '';
  
  void updateLangName () {
    Map<String, String> lang = languageController.lang.firstWhere(
      (el) => el['code'] == languageController.locale.value.languageCode,
      orElse: () => {'code': 'ja', 'name': '日本語'});

    setState(() {
      langName = '${lang['name']}';
    });
  }
  void _showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: languageController.lang.map((el) {
            return ListTile(
              title: Center(
                child: Text('${el['name']}'),
              ),
              onTap: () {
                Navigator.pop(context);
                languageController.changeLanguage(el['code'] as String);
                updateLangName();
                // Implement your action here
              },
            );
          }).toList()
        );
      },
    );
  }
  getData () {
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
    updateLangName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text(S.of(context).user_title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24.sp),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.w), // 统一的内边距
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // 用户信息部分，使用 Card 组件
              Card(
                margin: EdgeInsets.only(bottom: 16.h),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      // 用户头像
                      CircleAvatar(
                        radius: 60.w, // 根据屏幕调整头像大小
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: NetworkImage('${Config.imageBaseUrl}${data.cover}'),
                      ),
                      SizedBox(width: 20.w),
                      // 用户信息文本
                      Expanded(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(data.name ?? '', style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
                                
                              ],
                            ),
                          
                          SizedBox(height: 8.h),
                          Text(data.email ?? '', style: TextStyle(color: Colors.grey.shade500, fontSize: 24.sp)),
                          
                        ],
                      ),
                      )
                      
                    ],
                  ),
                ),
              ),
              // 统计信息部分的网格布局
              // Padding(
              //   padding: EdgeInsets.only(bottom: 16.h),
              //   // child:
              //   child: GridView.count(
              //     crossAxisCount: 1,
              //     crossAxisSpacing: 16.w,
              //     mainAxisSpacing: 16.h,
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     children: [
              //       _buildStatCard(S.of(context).user_data_orderCount, '${data.orderCount ?? 0}', Colors.purple, () {
              //         context.pushNamed('orderList');
              //       })
              //       // _buildStatCard(S.of(context).user_data_staffCount, '${data ?? 0}', Colors.green, () {}),
              //     ],
              //   ),
              // ),
              _buildListTile(
              title: S.of(context).user_registerTime,
              trailing: data.createTime ?? '',
              onTap: () {},
              showArrow: false
            ),
             _buildListTile(
              icon: null,
              title: S.of(context).user_data_orderCount,
              trailing: '${data.orderCount ?? 0}',
              // showArrow: false,
              onTap: () {
                _showActionSheet(context);
              },
            ),           
            _buildListTile(
              icon: Icons.language,
              title: S.of(context).user_language,
              trailing: langName,
              onTap: () {
                _showActionSheet(context);
              },
            ),
            _buildListTile(
              icon: Icons.edit,
              title: S.of(context).user_editProfile,
              onTap: () {
                context.pushNamed('userProfile', queryParameters: {
                  'id': data.id.toString(),
                });
              },
            ),
            _buildListTile(
              icon: Icons.privacy_tip,
              title: S.of(context).user_privateAgreement,
              onTap: () {
                launchURL('https://www.google.com');
              },
            ),
            _buildListTile(
              icon: Icons.check,
              title: S.of(context).user_checkUpdate,
              trailing: '1.0.0',
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.info_outline,
              title: S.of(context).user_about,
              onTap: () {
                context.pushNamed('about');
              },
            ),
            _buildListTile(
              icon: Icons.logout,
              title: S.of(context).user_logout,
              onTap: () {},
            ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildListTile({
    IconData? icon,
    required dynamic title,
    dynamic trailing,
    required GestureTapCallback onTap,
    bool showArrow = true, // ✅ 控制是否显示箭头
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1.0)),
      ),
      child: ListTile(
        leading: icon != null
            ? Icon(icon, color: Colors.grey.shade500)
            : const SizedBox(width: 24), // ✅ 占位保持对齐
        title: title is String
            ? Text(title, style: TextStyle(fontSize: 24.sp))
            : title as Widget,
        trailing: trailing != null
            ? trailing is String
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(trailing, style: TextStyle(fontSize: 22.sp)),
                      if (showArrow) ...[
                        SizedBox(width: 8.w),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ],
                  )
                : trailing as Widget
            : (showArrow
                ? const Icon(Icons.arrow_forward_ios, size: 16)
                : null),
        onTap: onTap,
      ),
    );
  }

}
