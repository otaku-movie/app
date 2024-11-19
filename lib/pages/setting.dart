import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:otaku_movie/components/CustomNavigateTabBar.dart';
import 'package:get/get.dart';

import '../components/CustomAppBar.dart';
import '../controller/LanguageController.dart';
import '../generated/l10n.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _PageState();
}

class _PageState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text(S.of(context).hello),
        showBackButton: false,
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 44.sp),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(S.of(context).hello),
            ElevatedButton(
              onPressed: () => languageController.changeLanguage('en'),
              child: const Text('English'),
            ),
            ElevatedButton(
              onPressed: () => languageController.changeLanguage('zh'),
              child: const Text('中文'),
            ),
            ElevatedButton(
              onPressed: () => languageController.changeLanguage('ja'),
              child: const Text('日本語'),
            ),
          ],
        ),
      ),
      // body: Container(
      //   color: Colors.white,
      //   child: Column(
      //     children: [
      //       Container(
      //         padding:  EdgeInsets.symmetric(vertical: 20.sp, horizontal: 20.sp), decoration: const BoxDecoration(
      //             color: Colors.white,
      //             border: Border(
      //               bottom: BorderSide(width: 1, color: Color(0XFFEBEDF0)),
      //             ),
      //           ),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text("语言",  style: TextStyle(
      //               color: Colors.black,
      //                 fontSize: 32.sp
      //             )),
      //             Icon(Icons.arrow_forward_ios_sharp, size: 44.sp, color: Color(0XFF969799))
      //           ],
      //         )
      //       )
      //
      //     ],
      //   )
      // )
    );
  }
}
