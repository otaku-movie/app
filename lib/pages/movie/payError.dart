import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PayError extends StatefulWidget {
  const PayError({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<PayError> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
         title: Text('支付失败', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Center(
                
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.h,
                  children: [
                      Icon(Icons.cancel, color: Colors.red, size: 200.sp),
                       Container(
                        margin: EdgeInsets.only(top: 50.h, bottom: 50.h),
                        child: Text('您的订单似乎遇到了一些问题，请稍后重试。', style: TextStyle(fontSize: 36.sp)),
                      ),
                      SizedBox(
                        width: 300.w,
                        height: 70.h,
                        child: MaterialButton(
                          // minWidth: double.infinity,
                          color: const Color.fromARGB(255, 2, 162, 255),
                          textColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          onPressed: () {
                            context.pushNamed('me');
                          },
                          child: Text(
                            '返回',
                            style: TextStyle(color: Colors.white, fontSize: 36.sp),
                          ),
                        ),
                      )
                      
                  ],
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}
