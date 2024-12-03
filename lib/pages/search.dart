import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/Input.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<Search> {
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
      appBar: CustomAppBar(
         title: GestureDetector(
          onTap: () {
            context.pushNamed('search');
          },
          child:  Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 244, 243, 243)),
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade100,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('搜索全部电影', style: TextStyle(
                  fontSize: 28.sp,
                  color: Colors.grey.shade500
                )),
                // Input(
                //   disabled: true,
                //   placeholder: S.of(context).movieList_search_placeholder,
                //   placeholderStyle: TextStyle(color: Colors.grey.shade200),
                //   textStyle: const TextStyle(color: Colors.white),
                //   height: ScreenUtil().setHeight(60),
                //   backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
                //   borderRadius: BorderRadius.circular(50),
                //   suffixIcon: const Icon(Icons.search_outlined,
                //       color: Color.fromRGBO(255, 255, 255, 0.6)),
                //   cursorColor: Colors.white,
                // ),
                Icon(Icons.search_outlined,
                color: Colors.grey.shade500)
              ],
            ),
          ),
        )
      ),
          // title: Input(
          //   disabled: true,
          //   placeholder: S.of(context).movieList_search_placeholder,
          //   placeholderStyle: TextStyle(color: Colors.grey.shade200),
          //   textStyle: const TextStyle(color: Colors.white),
          //   height: ScreenUtil().setHeight(60),
          //   backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
          //   borderRadius: BorderRadius.circular(50),
          //   suffixIcon: const Icon(Icons.search_outlined,
          //       color: Color.fromRGBO(255, 255, 255, 0.6)),
          //   cursorColor: Colors.white,
          // ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
            ],
          ),
        ),
      )
    );
  }
}
