import 'dart:async';
import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<Search> {
  List<String> searchHistory = [];
  SharedPreferences? sharedPreferences;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = sharedPreferences?.getStringList('searchHistory') ?? [];
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

 Future<void> _showConfirmationDialog(BuildContext context) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: ThemeData(
          dialogBackgroundColor: Colors.white
        ),
        child: CupertinoAlertDialog(
        // Set the background color of the dialog
        //  White background
        title: Text(
          S.of(context).search_removeHistoryConfirm_title,
          style: const TextStyle(color: Colors.black), // Title text color
        ),
        content: Text(
          '\n${S.of(context).search_removeHistoryConfirm_content}',
          style: const TextStyle(color: Colors.black), // Content text color
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(false);  // User pressed No
            },
            child: Text(
              S.of(context).search_removeHistoryConfirm_cancel,
              style: const TextStyle(color: Colors.grey), // Cancel button text color (gray)
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(true);  // User pressed Yes
            },
            child: Text(
              S.of(context).search_removeHistoryConfirm_confirm,
              style: const TextStyle(color: Colors.blue), // Confirm button text color (blue)
            ),
          ),
        ],
      ),
      );
      
    },
  );

  // Handle the user's response
  if (confirmed != null && confirmed) {
    // User confirmed the action
    sharedPreferences?.setStringList('searchHistory', []);

    setState(() {
      searchHistory = [];
    });
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Action Confirmed')),
    );
  } else {
    // User canceled the action
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Action Canceled')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Row(
          children: [
            Expanded(
              child: Input(
                height: 55.h,
                horizontalPadding: 35.w,
                placeholder: S.of(context).search_placeholder,
                placeholderStyle: TextStyle(color: Colors.grey.shade500, fontSize: 28.sp),
                textStyle: const TextStyle(color: Colors.black),
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(50),
                suffixIcon: Icon(Icons.search_outlined, color: Colors.grey.shade500),
                cursorColor: Colors.grey.shade500,
                onSubmit: (val) {
                  if (sharedPreferences != null && val != '') {
                     searchHistory.insert(0, val);
                      int size = 20;
                      List<String> top20 = searchHistory.sublist(0, searchHistory.length < size ? searchHistory.length : size);

                      sharedPreferences!.setStringList('searchHistory', top20);

                    setState(() {
                     searchHistory = top20;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...searchHistory.isEmpty ? [] : [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(S.of(context).search_history),
                    IconButton(
                      onPressed: () {
                        _showConfirmationDialog(context);
                      }, 
                      icon: Icon(Icons.delete, color: Colors.red.shade500, size:  40.w)
                    )
                    
                ]),
                
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.h),
                  child: Wrap(
                    spacing: 30.w,
                    runSpacing: 25.w,
                    children: searchHistory.map((item) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50.w)
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 30.w),
                        child: Text(item, style: TextStyle(fontSize: 26.sp)),
                      );
                    }).toList(),
                  ),
                ),
              ]
              
            ],
          ),
        ),
      ),
    );
  }
}
