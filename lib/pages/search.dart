import 'dart:async';
import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/HelloMovie.dart';
import 'package:otaku_movie/components/Input.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  List<String> searchHistoryList = [];
  SharedPreferences? sharedPreferences;
  EasyRefreshController easyRefreshController = EasyRefreshController();
  int currentPage = 1;
  bool loading = false;
  bool loadFinished  = false;
  List<MovieResponse> data = [];

  @override
  void initState() {
    super.initState();
    // search();
    _initializeSharedPreferences();
  }

  Future<void> _initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      searchHistoryList = sharedPreferences?.getStringList('searchHistoryList') ?? [];
    });
  }

  search({ int page = 1 }) {
    ApiRequest().request(
      path: '/movie/list',
      method: 'POST',
      data: {
        'page': page,
        'pageSize': 10,
        'name': searchController.text
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<MovieResponse>.fromJson(
          json,
          (data) => MovieResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) {

      if (res.data?.list != null) {
        List<MovieResponse> list = res.data!.list!;
        
        if (list.isEmpty) {
          // ignore: use_build_context_synchronously
          ToastService.showInfo(S.of(context).search_noData);
        }
        setState(() {
          if (list.isNotEmpty && !loadFinished) {
            data.addAll(list); // 追加数据
          } 
          if (page == 1) {
            data = list;
          }
          currentPage = page;
          loadFinished = list.isEmpty; // 更新加载完成标志
          
        });

        easyRefreshController.finishLoad(
          list.isEmpty ? IndicatorResult.noMore : IndicatorResult.success,
          true
        );
      }
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
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
      sharedPreferences?.setStringList('searchHistoryList', []);

      setState(() {
        searchHistoryList = [];
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
    Widget searchHistoryWidget = Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...searchHistoryList.isEmpty ? [] : [
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
                  children: searchHistoryList.map((item) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          searchController.text = item;
                          loading = true;
                        });
                        // 关闭键盘弹窗
                        FocusScope.of(context).requestFocus(FocusNode());
                        search();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50.w)
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 30.w),
                        child: Text(item, style: TextStyle(fontSize: 26.sp)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ]
          ],
        ),
      );
    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Row(
          children: [
            Expanded(
              child: Input(
                controller: searchController,
                height: 55.h,
                horizontalPadding: 35.w,
                placeholder: S.of(context).search_placeholder,
                placeholderStyle: TextStyle(color: Colors.grey.shade500, fontSize: 28.sp),
                textStyle: const TextStyle(color: Colors.black),
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(50),
                suffixIcon: searchController.text.isEmpty 
                    ? Icon(Icons.search_outlined, color: Colors.grey.shade500)
                    : IconButton(
                      onPressed: () {
                        setState(() {
                          searchController.text = '';
                          data = [];
                        });
                        // 关闭键盘弹窗
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      // enableFeedback: false,
                      icon: Icon(
                        Icons.clear, 
                        color: Colors.grey.shade500
                      )
                ),
                cursorColor: Colors.grey.shade500,
                onChange: (val) {
                  setState(() {
                    searchController.text = val;
                  });
                },
                onSubmit: (val) {
                  if (sharedPreferences != null && val != '') {
                     searchHistoryList.insert(0, val);
                      int size = 20;
                      List<String> top20 = searchHistoryList.sublist(0, searchHistoryList.length < size ? searchHistoryList.length : size);

                      sharedPreferences!.setStringList('searchHistoryList', top20);

                    setState(() {
                      searchHistoryList = top20;
                      searchController.text = val;
                      loading = true;
                    });
                    search();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      body: data.isEmpty ? SingleChildScrollView(
        child: searchHistoryWidget
      ) : EasyRefresh(
        controller: easyRefreshController,
        header: customHeader(context),
        footer: customFooter(context),
        onRefresh: () {
          search();
        },
        onLoad: () {
          search(page: currentPage + 1);
        },
        child: AppErrorWidget(
          loading: loading,
          error: data.isEmpty,
          child: ListView.builder(
            shrinkWrap: true, // 根据内容自动调整高度
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              MovieResponse item = data[index];
              return _buildMovieItem(context, item, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMovieItem(BuildContext context, MovieResponse item, index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Color(0xFFE6E6E6)),
        ),
      ),
      child: Space(
        direction: "row",
        right: 20.w,
        children: [
          GestureDetector(
            onTap: () {
              context.pushNamed('movieDetail',
                pathParameters: {
                "id": '${item.id}'
              });
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CustomExtendedImage(
                      item.cover ?? '',
                      width: 240.w,
                      height: 280.h,
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: HelloMovie(
                    guideData: item.helloMovie, 
                    type: HelloMovieGuide.audio,
                    width: 80.w,
                  )
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: HelloMovie(
                    guideData: item.helloMovie, 
                    type: HelloMovieGuide.sub,
                    width: 80.w,
                  )
                ),
              ],
            ),
          ),
          SizedBox(
            height: 275.h,
            child: Space(
              direction: "column",
              bottom: 10.h,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMovieDetails(item),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      'showTimeList', 
                      pathParameters: {
                        "id": '${item.id}'
                      }, 
                      queryParameters: {
                        'movieName': item.name
                      }
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 35.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF069EF0),
                      borderRadius: BorderRadius.circular(50)
                    
                    ),
                    child: Text(
                        S.of(context).movieList_buy,
                        style: TextStyle(color: Colors.white, fontSize: 30.sp),
                      )
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieDetails(MovieResponse item) {
    return Expanded(
      // width: 350.w,
      child: Space(
        direction: "column",
        children: [
          GestureDetector(
            onTap: () {
              context.pushNamed('movieDetail',
                pathParameters: {
                "id": '${item.id}'
              });
            },
            child: Text(item.name ?? '', style: TextStyle(fontSize: 36.sp)),
          ),
          // Text("监督：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
          // Text("声优：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
          Text('${S.of(context).search_level}：${item.levelName}', style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
        ],
      ),
    );
  }
}
