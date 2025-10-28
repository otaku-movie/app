import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:otaku_movie/utils/toast.dart';
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

  /// 判断是否为预售（上映时间未到）
  bool _isPresale(String? startDate) {
    if (startDate == null || startDate.isEmpty) return false;
    
    try {
      final releaseDate = DateTime.parse(startDate);
      final now = DateTime.now();
      return releaseDate.isAfter(now);
    } catch (e) {
      return false;
    }
  }

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
          if (page == 1) {
            // 第一页：重置数据
            data = list;
          } else {
            // 非第一页：追加数据
            if (list.isNotEmpty) {
              data.addAll(list);
            }
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

  /// 删除单个搜索历史记录
  void _removeSearchHistoryItem(String item) {
    setState(() {
      searchHistoryList.remove(item);
    });
    
    // 更新本地存储
    if (sharedPreferences != null) {
      sharedPreferences!.setStringList('searchHistoryList', searchHistoryList);
    }
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
        // Set the background color of the dialog2
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
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...searchHistoryList.isEmpty ? [] : [
              // 标题栏
              Container(
                margin: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1989FA).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.history_rounded,
                            color: const Color(0xFF1989FA),
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          S.of(context).search_history,
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _showConfirmationDialog(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red.shade400,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 历史记录标签
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: searchHistoryList.map((item) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              searchController.text = item;
                              loading = true;
                            });
                            // 关闭键盘弹窗
                            FocusScope.of(context).requestFocus(FocusNode());
                            search();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: Colors.grey.shade400,
                                size: 24.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            _removeSearchHistoryItem(item);
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.grey.shade400,
                              size: 26.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ]
          ],
        ),
      );
    

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Input(
                  controller: searchController,
                  height: 52.h,
                  horizontalPadding: 40.w,
                  placeholder: S.of(context).search_placeholder,
                  placeholderStyle: TextStyle(
                    color: Colors.grey.shade400, 
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  textStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(28.r),
                  suffixIcon: searchController.text.isEmpty 
                      ? Container(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.search_rounded, 
                            color: Colors.grey.shade400,
                            size: 28.sp,
                          ),
                        )
                      : IconButton(
                        onPressed: () {
                          setState(() {
                            searchController.text = '';
                            data = [];
                          });
                          // 关闭键盘弹窗
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        icon: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded, 
                            color: Colors.grey.shade600,
                            size: 22.sp,
                          ),
                        ),
                      ),
                  cursorColor: const Color(0xFF1989FA),
                  cursorWidth: 2.0,
                  cursorHeight: 32.h,
                  cursorRadius: const Radius.circular(2.0),
                onChange: (val) {
                  setState(() {
                    searchController.text = val;
                  });
                },
                onSubmit: (val) {
                  if (sharedPreferences != null && val != '') {
                    // 移除已存在的相同搜索记录（如果有的话）
                    searchHistoryList.remove(val);
                    // 将新的搜索记录插入到最前面
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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomExtendedImage(
                      item.cover ?? '',
                      width: 240.w,
                      height: 260.h,
                      fit: BoxFit.contain
                    ),
                  ),
                ),
                // 预售标签（左上角）
                if (_isPresale(item.startDate))
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF6B35).withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        S.of(context).comingSoon_presale,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
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
            width: 420.w,
            height: 260.h,
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
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 32.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isPresale(item.startDate) 
                          ? [const Color(0xFFFF6B35), const Color(0xFFFF8A50)]  // 预售：橙色渐变
                          : [const Color(0xFF1989FA), const Color(0xFF069EF0)], // 正常：蓝色渐变
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: (_isPresale(item.startDate) 
                            ? const Color(0xFFFF6B35) 
                            : const Color(0xFF1989FA)).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                        _isPresale(item.startDate) 
                          ? S.of(context).comingSoon_presale
                          : S.of(context).movieList_buy,
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                        ),
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 电影标题 - 支持2行显示
          Flexible(
            child: GestureDetector(
              onTap: () {
                context.pushNamed('movieDetail',
                  pathParameters: {
                  "id": '${item.id}'
                });
              },
              child: Text(
                item.name ?? '', 
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // 分级标签 - 固定在底部
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '${S.of(context).search_level}：${item.levelName}', 
              style: TextStyle(
                fontSize: 22.sp, 
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
