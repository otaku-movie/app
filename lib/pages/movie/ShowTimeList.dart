import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/pages/MovieList.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie_list.dart';
import 'package:otaku_movie/response/response.dart';
import '../../components/Input.dart';
import '../../generated/l10n.dart';
import '../../controller/LanguageController.dart';
import 'package:get/get.dart'; // Ensure this import is present
import 'package:extended_image/extended_image.dart';

class ShowTimeList extends StatefulWidget {
  const ShowTimeList({super.key});

  @override
  State<ShowTimeList> createState() => _PageState();
}

class _PageState extends State<ShowTimeList> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int tabLength = 7;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabLength, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
  }

  Future<void> _onLoad() async {
  }

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.find();

    List<Widget> getWeek() {
      List<String> weekList = ['一', '二', '三', '四', '五', '六', '日'];

      // 获取今天的日期
      DateTime now = DateTime.now();
      int today = now.weekday; // 星期一为1，星期天为7

      // 计算本周的星期和日期
      List<Widget> thisWeek = [];

      for (int i = 0; i < 7; i++) {
        // 以今天为起点，计算对应的日期
        DateTime date = now.add(Duration(days: i)); // 从今天开始计算
        int dayIndex = (today - 1 + i) % 7; // 计算对应的星期索引

        // bool isToday = date.day == now.day && date.month == now.month && date.year == now.year;

        // TextStyle style = TextStyle(
        //   color: _tabController.index ? Colors.white : Colors.black, // 根据是否是今天调整颜色
        // );

        thisWeek.add(
          Column(
            children: [
              Text(weekList[dayIndex], ), // 星期
              Text('${date.month}/${date.day}'), // 日期格式为 "月/日"
            ],
          ),
        );
      }

      return thisWeek;
    }


    return DefaultTabController(
      initialIndex: 0,
      length: tabLength,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("東宝シネマズ　新宿", style: TextStyle(fontSize: 33.sp)),
          bottom: TabBar(
            controller: _tabController,
            tabs: getWeek(),
            indicatorColor: Colors.blue,
            labelColor: Colors.white,
            labelPadding: EdgeInsets.only(bottom: 15.h),
          ),
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 44.sp),
        ),
        body: EasyRefresh.builder(
          header: const ClassicHeader(),
          footer: const ClassicFooter(),
          onRefresh: _onRefresh,
          onLoad: _onLoad,
          childBuilder: (context, physics) {
            return TabBarView(
              controller: _tabController,
              // physics: const NeverScrollableScrollPhysics(),
              children: List.generate(tabLength, (index) {
                return ListView.builder(
                  physics: physics, // 使用 EasyRefresh 提供的 physics
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child:Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: Color(0XFFe6e6e6),
                          ),
                        ),
                      ),
                      child: Wrap(
                        runSpacing: 4.h,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Wrap(
                                spacing: 4.w,
                                children: [
                                  Text('東宝シネマズ　新宿', style: TextStyle(fontSize: 36.sp)),
                                  const Icon(Icons.star, color: Color(0xFFebb21b)),
                                ],
                              ),
                              Wrap(
                                spacing: 4.w,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text('3.7km', style: TextStyle(fontSize: 28.sp,  color: Colors.grey.shade600)),
                                  Icon(Icons.arrow_forward_ios, size: 36.sp, color: Colors.grey.shade600),
                                ],
                              ),
                              
                              // Text('3.7km', style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                          
                          Text('東京都新宿区歌舞伎町 1-19-1　新宿東宝ビル３階', style: TextStyle(color: Colors.grey.shade400)),
                        ],
                      ),
                    ),
                      onTap: () {
                      context.go('/movie/showTimeList/showTimeDetail');
                    });
                  },
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
