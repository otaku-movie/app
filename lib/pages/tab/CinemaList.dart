import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/cinema/cinemaList.dart';
import 'package:otaku_movie/response/movie/movieList/movie_now_showing.dart';
import 'package:otaku_movie/response/response.dart';
import '../../components/Input.dart';
import '../../generated/l10n.dart';
import '../../controller/LanguageController.dart';
import 'package:get/get.dart'; // Ensure this import is present
import 'package:extended_image/extended_image.dart';

class CinemaList extends StatefulWidget {
  const CinemaList({super.key});

  @override
  State<CinemaList> createState() => _PageState();
}

class _PageState extends State<CinemaList> with SingleTickerProviderStateMixin {
  bool loading = false;
  bool error = false;
  int currentPage = 1;

  List<CinemaListResponse> data = [];
  Placemark location = Placemark();
  

  void getData({page = 1}) {
    setState(() {
      loading = true;
    });
    ApiRequest().request(
      path: '/cinema/list',
      method: 'POST',
      data: {
        "page": page,
        "pageSize": 20,
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<CinemaListResponse>.fromJson(
          json,
          (data) => CinemaListResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) async {
      List<CinemaListResponse> list = res.data?.list ?? [];
      getLocation().then((position) async {
        List<CinemaListResponse> result = await getCinemaListWithDistance(list, position);

        setState(() {
          data = result;
        });
      });
      
      setState(() {
        data = list;
      });
    }).catchError((err) {
      setState(() {
        error = true;
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 检查定位服务是否开启
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // 检查并请求权限
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // 获取当前位置
    return await Geolocator.getCurrentPosition();
  }

  // 计算距离
  double calculateDistanceHaversine(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude) {
    const double R = 6371; // 地球半径，单位：千米

    // 将角度转换为弧度
    double lat1 = startLatitude * pi / 180;
    double lon1 = startLongitude * pi / 180;
    double lat2 = endLatitude * pi / 180;
    double lon2 = endLongitude * pi / 180;

    // 计算纬度和经度的差值
    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    // 使用 Haversine 公式计算距离
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // 计算距离（单位：千米）
    double distance = R * c;

    // 转换为米
    return distance * 1000;  // 返回距离，单位：米
  }

  Future<List<CinemaListResponse>> getCinemaListWithDistance(List<CinemaListResponse> data, Position position) async {
    // 使用 Future.wait 来并发地处理所有的异步操作
    List<Future<CinemaListResponse>> futures = data.map((item) async {
      // 使用 Geocoding 插件获取地址的经纬度
      List<Location> locations = await locationFromAddress('Shinjuku Toho Building 3F, 1-19-1 Kabukicho, Shinjuku-ku, Tokyo, Japan');

      if (locations.isNotEmpty) {
        // 获取第一个匹配的经纬度
        double latitude = locations[0].latitude;
        double longitude = locations[0].longitude;
        print('Latitude: $latitude, Longitude: $longitude');

        // 计算两点之间的距离
        double distance = calculateDistanceHaversine(
          position.latitude,
          position.longitude,
          latitude,
          longitude,
        );

        // 更新 item 的距离
        item.distance = distance;
      }

      return item; // 返回更新后的 item
    }).toList();

    // 使用 Future.wait 等待所有异步操作完成，并获取结果
    List<CinemaListResponse> result = await Future.wait(futures);

    return result;
  }


  @override
  void initState() {
    super.initState();
    getData();  // 获取其他数据

    // 获取位置
    getLocation().then((position) async {
      try {
        // 获取当前位置的详细地址
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          setState(() {
            location = placemarks[0];
          });
        }
        

        // 你可以在此更新 UI 或执行其他逻辑
      } catch (e) {
        log.e('Error getting placemark: $e');
      }
    }).catchError((error) {
      // 处理定位错误
      log.e('Location error: $error');
    });
  }

  Future<void> _onRefresh() async {
  }

  Future<void> _onLoad() async {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,

        title: Row(
          // spacing: 20.w,
          // direction: Axis.horizontal,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(location.subLocality ?? '', style: TextStyle(fontSize: 32.sp)),
            SizedBox(width: 20.w),
            Expanded(
              child: Input(
              placeholder: S.of(context).movieList_placeholder,
              placeholderStyle: const TextStyle(color: Colors.black26),
              textStyle: const TextStyle(color: Colors.white),
              height: ScreenUtil().setHeight(60),
              backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
              borderRadius: BorderRadius.circular(28),
              suffixIcon: const Icon(Icons.search_outlined,
                  color: Color.fromRGBO(255, 255, 255, 0.6)),
              cursorColor: Colors.white,
             ),
            )
          ],
        ),
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 44.sp),
      ),
      bottomNavigationBar: Container(
        width: 500.w,
        color: Colors.grey.shade200,
        padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 20.w),
        child: Space(
          right: 5.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            SizedBox(
              width: 650.w,
              child: Text(
                location.street ?? S.of(context).cinemaList_address, // 显示文本
                softWrap: true, // 自动换行
                overflow: TextOverflow.ellipsis, // 超出部分使用省略号
                style: TextStyle(fontSize: 28.sp),
              ),
            ),
          ],
        ),
      ),
      body: 
        loading ? const Center(child: Text('loading...')) : 
        error ? const Center(child: Text('error')) :
      EasyRefresh.builder(
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        childBuilder: (context, physics) {
          return ListView(
            physics: physics,
            children: List.generate(data.length, (index) {
              CinemaListResponse item = data[index];

              String formatDistance = '';

                if (item.distance != null) {
                  if (item.distance! < 1000) {
                    // 小于1公里，显示米
                    formatDistance = '${item.distance!.toStringAsFixed(0)} m';
                  } else {
                    // 大于1公里，显示公里
                    double distanceInKilometers = item.distance! / 1000;
                    formatDistance = '${distanceInKilometers.toStringAsFixed(1)} km';
                  }
                }
              
             
              return Container(
                width: double.infinity,
                 padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0, // 边框D宽度
                      color: Color(0XFFe6e6e6)),
                  ),
                ),
                child:  Space(
                  direction: "column",
                  bottom: 4.h,
                  children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 4.w,
                          children: [
                            Text('${item.name}', style: TextStyle(fontSize: 36.sp)),
                            const Icon(Icons.star, color: Color(0xFFebb21b)),
                          ],
                        ),
                        Text(formatDistance, style: TextStyle(color: Colors.grey.shade600))
                      ],
                    ),
                    
                    Text('${item.address}',style: TextStyle(color: Colors.grey.shade400)),
                    Wrap(
                      spacing: 6,
                      children: item.spec!.map((children) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(Size(0.w, 50.h)),
                            textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20.sp)),
                            side: WidgetStateProperty.all(const BorderSide(width: 2, color: Color(0xffffffff))),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // 调整圆角大小
                              ), 
                            ),
                          ),
                          onPressed: () {},
                          child: Text('${children.name}'),
                        );
                      }).toList()
                    ),
              
                    // Container(height: 10.h),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Wrap(
                    //   spacing: 20.w,
                    //   children: List.generate(3, (index) {
                    //     return SizedBox(
                    //       width: 224.w,
                    //       child: Column(
                    //         crossAxisAlignment : CrossAxisAlignment.start,
                    //           children:  [
                    //             SizedBox(
                    //               child: ClipRRect(
                    //                 borderRadius: BorderRadius.circular(4.0), // 设置圆角大小
                    //                 child: ExtendedImage.asset(
                    //                   'assets/image/raligun.webp',
                    //                   // width: 224.w,
                    //                 ),
                    //               ),
                    //             ),
                    //             Text('某科学的超电磁炮234efd', style: TextStyle(color: Colors.grey.shade400, overflow: TextOverflow.ellipsis))
                    //           ],
                    //         ),
                    //       );
                    //     })                        
                    //   ),
                    // )
                  ],
                ),
              );
            } as Widget Function(int index)),
          );
        },
      )
    );
  }
}
