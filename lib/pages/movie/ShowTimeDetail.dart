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
import 'package:card_swiper/card_swiper.dart';

class ShowTimeDetail extends StatefulWidget {
  const ShowTimeDetail({super.key});

  @override
  State<ShowTimeDetail> createState() => _PageState();
}

class _PageState extends State<ShowTimeDetail>
    with SingleTickerProviderStateMixin {
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

  Future<void> _onRefresh() async {}

  Future<void> _onLoad() async {}

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
              Text(
                weekList[dayIndex],
              ), // 星期
              Text('${date.month}/${date.day}'), // 日期格式为 "月/日"
            ],
          ),
        );
      }

      return thisWeek;
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("東宝シネマズ　新宿", style: TextStyle(fontSize: 33.sp)),
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 44.sp),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Row(
                //   children: [Text('東京都新宿区歌舞伎町 1-19-1　新宿東宝ビル３階')],
                // ),
                // const Text('联系方式：080-1111-1111'),
                // const Text('联系方式：080-1111-1111'),
                Center(
                    child: Column(
                  children: [
                    Container(
                      // height: 200, // 设置固定高度
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(18)
                      // ),
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0), // 设置圆角大小
                        child: ExtendedImage.asset(
                          'assets/image/raligun.webp',
                          width: 304.w,
                        ),
                      ),
                    ),
                    Text('某科学的超电磁炮', style: TextStyle(fontSize: 44.sp)),
                    Text('G 120分 | 山本泰一郎 | 御坂美琴、御坂美琴、御坂美琴',
                        style: TextStyle(
                            fontSize: 24.sp, color: Colors.grey.shade600))
                  ],
                )),
                const SizedBox(height: 20), // 增加间距
                ...List.generate(5, (index) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1.0,
                          color: Color(0XFFe6e6e6),
                        ),
                      ),
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.vertical,
                      spacing: 15.w,
                      children: [
                        Text('20:00 ~ 22:00',
                            style: TextStyle(fontSize: 28.sp)),
                        Wrap(
                            spacing: 20.w,
                            children: ['舞台挨拶', '日本語字幕'].map((item) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.w, horizontal: 20.w),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(item,
                                    style: TextStyle(fontSize: 24.sp)),
                              );
                            }).toList()),
                        Container(
                            width: MediaQuery.of(context).size.width - 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text('スクリーン8'),
                                ),
                                MaterialButton(
                                  color: const Color.fromARGB(
                                      255, 5, 136, 243), // 按钮颜色
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(50)), // 按钮圆角
                                  ),
                                  onPressed: () {
                                    context.go("/movie/selectSeat");
                                  },
                                  child: Row(
                                    mainAxisSize:
                                        MainAxisSize.min, // 让按钮根据内容自适应宽度
                                    children: [
                                      // const Icon(Icons.favorite, color: Colors.white, size: 24), // 添加的图标
                                      // const SizedBox(width: 8), // 图标和文字之间的间距
                                      Text(
                                        S.of(context).movieList_button_buy,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 32.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
        ));
  }
}
