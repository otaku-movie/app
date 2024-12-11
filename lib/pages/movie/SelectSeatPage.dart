import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_utils/intl_utils.dart';
import 'package:logger/logger.dart';
import 'package:otaku_movie/components/CinemaScreen.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/enum/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/pages/movie/confirmOrder.dart';
import 'package:otaku_movie/response/movie/movie_show_time_detail.dart';
// import 'package:go_router/go_router.dart';
// import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/movie/theater_seat.dart';
import 'package:otaku_movie/response/response.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/utils/toast.dart';

import '../../api/index.dart';

class SelectSeatPage extends StatefulWidget {
  String? id;
  String? theaterHallId;
  
  SelectSeatPage({super.key, this.id, this.theaterHallId});

  @override
  // ignore: library_private_types_in_public_api
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SelectSeatPage> {
  double _scaleFactor = 1.0;
  TransformationController  transformationController = TransformationController();

  // 座位大小
  double seatSize = 40.w;
  // 座位间距
  double seatGap = 16.w;
  // double borderWidth = 1.5w;
  int rowCount = 0;
  int columnCount = 0;

  TheaterSeat data = TheaterSeat();
  MovieShowTimeDetailResponse _showTimeData = MovieShowTimeDetailResponse();
  List<Seat> seatData = [];
  Set<int> selectSeatSet = {};
  List<SeatItem> selectSeatList = [];

  // int code = SelectSeatState.available.code;

  void getData() {
    ApiRequest().request(
      path: '/app/movie_show_time/detail',
      method: 'GET',
      queryParameters: {
        'id': widget.id
      },
      fromJsonT: (json) {
        return MovieShowTimeDetailResponse.fromJson(json) ;
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          _showTimeData = res.data!;
        });
      }
    });
  }

  void getSeatData() {
    ApiRequest().request(
      path: '/movie_show_time/select_seat/list',
      method: 'GET',
      queryParameters: {
        'theaterHallId': widget.theaterHallId,
        'movieShowTimeId': widget.id
      },
      fromJsonT: (json) {
        return TheaterSeat.fromJson(json);
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          seatData = res.data!.seat!;
          data = res.data!;
          rowCount = res.data!.seat?.length ?? 0;
          columnCount = res.data!.seat != null ? data.seat![0].children?.length ?? 0 : 0;
        });
        insertAisle();
      }
    });
  }

  insertAisle () {
    data.aisle?.forEach((item) {
      switch (item.type) {
        case AisleType.row:
          int index = seatData.indexWhere((children) {
            return children.rowAxis == item.start;
          });

          if (index != -1) {
            seatData.insert(index, Seat(
              type: SeatType.aisle,
              children: []
            ));
          }
          
        break;
        case AisleType.column:
          for (var row in seatData) {
            int index = row.children!.indexWhere((children) {
              return children.y == item.start;
            });

             
            if (index != -1) {
              row.children?.insert(index, SeatItem(
                type: SeatType.aisle
              ));
            }
          }
        break;
        case null:
        break;
      }
    });
    log.i(seatData);
  }

  @override
  void initState() {
    super.initState();
    transformationController = TransformationController();
    getData();
    getSeatData();
  }

  @override
  void dispose() {
    super.dispose();
    transformationController.dispose();
  }

  // 获取缩放比例
  double getCurrentScale() {
    return transformationController.value.getMaxScaleOnAxis();
  }

  void selectSeat (SeatItem item) {
    if (
      item.selectSeatState == SelectSeatState.locked.code ||
      item.selectSeatState == SelectSeatState.sold.code ||
      item.disabled!
    ) {
      return;
    }

    if (selectSeatSet.length >= data.maxSelectSeatCount!) {
      return ToastService.showWarning(S.of(context).selectSeat_maxSelectSeatWarn(data.maxSelectSeatCount!));
    }
    if (item.seatPositionGroup != null) {
      item.seatPositionGroup!.split('-').forEach((el) {
        List<String> position = el.split(',');
        int x = int.parse(position[0]);
        int y = int.parse(position[1]);

        
        // 获取行的index，需要考虑空排
        int row = seatData.indexWhere((el) => el.rowAxis == x);

        if (row != -1) {
          SeatItem seat = seatData[row].children!.firstWhere((el) => el.y == y);
          int indexWhere = selectSeatList.indexWhere((el) => el.id == seat.id);

        if (indexWhere == -1) {
            selectSeatList.add(seat);
          } else {
            selectSeatList.removeWhere((el) => el.id == seat.id);
          }
        }
      });

      setState(() {
        selectSeatList = selectSeatList;
        selectSeatSet = selectSeatList.map((el) => el.id!).toSet();
      });
    } else {
      int indexWhere = selectSeatList.indexWhere((el) => el.id == item.id);

      if (indexWhere == -1) {
        selectSeatList.add(item);
      } else {
        selectSeatList.removeWhere((el) => el.id == item.id);
      }

      setState(() {
        selectSeatList = selectSeatList;
        selectSeatSet = selectSeatList.map((el) => el.id!).toSet();
      });
    }
  }
  
  Widget buildSeat (SeatItem seat, {
    double? width, // 宽度可为空
    double? height, // 高度可为空
    EdgeInsetsGeometry? margin,
    Widget? child
  }) {
    final locked = SelectSeatState.locked.code;
    final sold = SelectSeatState.sold.code;

    
    Widget result = generatorSeatState(
      'available', 
      margin: margin, 
      width: width, 
      height: height,
      child: child
    );

    // 不可选的座位
    if (seat.disabled!) {
      result = generatorSeatState(
        'disabled', 
        margin: margin, 
        width: width, 
        height: height,
        child: child
      );
    }
    
    if (seat.selectSeatState != null) {
       if (seat.selectSeatState == locked) {
        result = generatorSeatState(
        'locked', 
        margin: margin, 
        width: width, 
        height: height,
        child: child
      );
      } else if (seat.selectSeatState == sold) {
        // 座位已售出
        result = generatorSeatState(
        'sold', 
        margin: margin, 
        width: width, 
        height: height,
        child: child
      );
      }
    }
    if (selectSeatSet.contains(seat.id)) {
      result = generatorSeatState(
        'selected', 
        margin: margin, 
        width: width, 
        height: height,
        child: child
      );
    }

    return result;
 }
 
  Widget generatorSeatState(
    String key, {
    double? width, // 宽度可为空
    double? height, // 高度可为空
    double? radius, // 圆角可为空
    EdgeInsetsGeometry? margin,
    Widget? child
  }) {
    // 在函数内部设置默认值
    double finalWidth = width ?? 32.w; // 如果未传入 width，使用 ScreenUtil 的默认值
    double finalHeight = height ?? 32.w; // 同理，默认高度
    double finalRadius = radius ?? 6.w; // 默认圆角

    Widget buildContainer({
      EdgeInsetsGeometry? margin,
      Color? color, 
      Color? borderColor, 
      Widget? child
    }) {
      return Container(
        width: finalWidth,
        height: finalHeight,
        margin: margin,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(finalRadius),
          border: Border.all(color: borderColor ?? Colors.transparent, width: 1.5),
        ),
        child: child,
      );
    }
    Widget coupleSeat = Row(
      children: [
        buildContainer(
          color: Colors.white,
          borderColor: const Color.fromARGB(255, 6, 130, 239)
        ),
        Transform.translate(
          offset: const Offset(-1.5, 0),
          child: buildContainer(
            color: Colors.white,
            borderColor: const Color.fromARGB(255, 6, 130, 239),
            child: child,
          ),
        )
        
      ],
    );

    Widget wheelChair = SvgPicture.asset(
      'assets/icons/wheelChair.svg',
      width: finalWidth,
      height: finalHeight,
      
    );

    Widget disabled = buildContainer(
      color: Colors.grey.shade100,
      borderColor: Colors.grey.shade300,
      margin: margin,
      child: child,
    );

    Widget selected = buildContainer(
      color: const Color.fromARGB(255, 71, 152, 228),
      borderColor: const Color.fromARGB(255, 71, 152, 228),
      child: Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: finalWidth * 0.8, // 图标大小按宽度比例
        ),
      ),
      margin: margin,
      
    );

    Widget locked = buildContainer(
      borderColor: const Color.fromARGB(255, 255, 0, 247),
      margin: margin,
      child: child,
    );

    Widget sold = buildContainer(
      borderColor: Colors.red[400],
      margin: margin,
      child: child,
    );
    Widget available = buildContainer(
      borderColor: const Color.fromARGB(255, 6, 130, 239),
      margin: margin,
      child: child,
    );

    Map<String, Widget> map = {
      'coupleSeat': coupleSeat,
      'wheelChair': wheelChair,
      'disabled': disabled,
      'selected': selected,
      'locked': locked,
      'sold': sold,
      'available': available
    };

    return map[key] ?? Container(); // 如果传入的 key 无效，返回空容器
  }

 
  @override
  Widget build(BuildContext context) {
     List<Map<String, dynamic>> seatType = [
      {
        "widget": generatorSeatState('wheelChair'),
       'name': S.of(context).common_enum_seatType_wheelChair,
      },
      {
        "widget": generatorSeatState('coupleSeat'),
       'name': S.of(context).common_enum_seatType_coupleSeat,
      },
      {
       'name': S.of(context).common_enum_seatType_disabled,
        'widget': generatorSeatState('disabled'),
      },
      // {
      //  'name': S.of(context).common_enum_seatType_selected,
      //  'widget':  generatorSeatState('selected')
      // },
      {
       'name': S.of(context).common_enum_seatType_locked,
       'widget':  generatorSeatState('locked')
      },
      {
       'name': S.of(context).common_enum_seatType_sold,
       'widget':  generatorSeatState('sold')
      }
    ];
    Map<String, List<SeatItem>> seatGroups = {};

    for (var row in seatData) {
      row.children?.forEach((seat) {
        if (seat.seatPositionGroup != null) {
          // 按 seat_position_group 将座位分组
          if (seatGroups[seat.seatPositionGroup] == null) {
            seatGroups[seat.seatPositionGroup as String] = [];
          }
          seatGroups[seat.seatPositionGroup]?.add(seat);
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: CustomAppBar(
        title: Text(
          _showTimeData.cinemaName ?? '', 
          style: TextStyle(color: Colors.white, fontSize: 36.sp)
        ),
      ),
      body: Stack(
        children: [
          
          Positioned(
            
            child:  GestureDetector(
            onScaleUpdate: (details) {
              setState(() {
                _scaleFactor = details.scale.clamp(0.5, 3.0);
              });
            },
            child: InteractiveViewer(
              constrained: false,
              boundaryMargin:  EdgeInsets.only(top: 200.h, left: 500, right: 500,bottom: 1000.h),
              minScale: 0.1,
              maxScale: 2.6,
              transformationController: transformationController,
              child: Container(
                child: Space(
                  direction: 'column',
                    // spacing: 0.0,
                    children: [
                      // Container(
                      //     width: MediaQuery.of(context).size.width * 0.8, // 宽度为屏幕宽度的 80%
                      //     height: 80.h, // 固定高度
                      //     margin: EdgeInsets.only(bottom: 20.h),
                      //     child: CustomPaint(
                      //       painter: CinemaScreenPainter(),
                      //     ),
                      // ),
                      Space(
                        children: [
                           Wrap(
                             direction: Axis.vertical,
                             children: [
                               Container(
                                 width: seatSize,
                                 height: seatSize,
                                 alignment: Alignment.center,
                                 // margin: EdgeInsets.all(seatGap),
                                
                               ),
                              // 排号
                              ...seatData.map((row)  {
                                return Container(
                                  width: seatSize,
                                  height: seatSize,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(seatGap),
                                  child: Text(
                                    row.rowName ?? '',
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  )
                                );
                              })
                             ]
                           ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            direction: Axis.horizontal,
                            children: List.generate(columnCount, (index) {
                              return Container(
                                  width: seatSize, // 排号区域宽度
                                  height: seatSize,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(right: seatGap),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(fontSize: 24.sp, color: Colors.black),
                                  ));
                            })),
                            ...seatData.map((row) {
                              if (row.type == SeatType.aisle) {
                                // 如果是过道，返回一个空白行
                                return Container(
                                  height: seatSize,
                                  margin: EdgeInsets.all(seatGap)
                                );
                              } else {
                                // 否则返回一个普通的 Row，包含座位
                                int groupIndex = 0;

                                return Container(
                                  margin: EdgeInsets.only(bottom: seatGap, top: seatGap),
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: row.children!.map((children) {

                                    // 如果是过道，或者座位本身不显示就为空白
                                    if (children.type == SeatType.aisle || !children.show!) {
                                      return Container(
                                        margin: EdgeInsets.only(right: seatGap),
                                        width: seatSize,
                                        height: seatSize,
                                        color: Colors.transparent
                                      );
                                    } else {
                                      EdgeInsetsGeometry margin = EdgeInsets.only(left: 0, right: seatGap);
                                      SvgPicture? wheelChair = children.wheelChair ?? false ? SvgPicture.asset(
                                        'assets/icons/wheelChair.svg',
                                        width: seatSize,
                                        height: seatSize,
                                      ) : null;

                                      if (children.seatPositionGroup != null) {
                                        // 获取当前座位组
                                        List<SeatItem> seatGroup = seatGroups[children.seatPositionGroup]!;

                                        // 排序座位组
                                        seatGroup.sort((a, b) => a.y.compareTo(b.y as num)); // 按 y 坐标升序排列

                                        // 计算座位组内的宽度
                                        double totalWidth = (seatSize * seatGroup.length) + seatGap * (seatGroup.length - 1);
                                        double groupWidth = totalWidth / seatGroup.length;
                                        
                                        Widget result = Transform.translate(
                                          // offset: Offset(0, 0),
                                          offset: groupIndex == 0 ? const Offset(0, 0) : Offset(-seatGap - 1.5 * groupIndex, 0),
                                          child:  GestureDetector(
                                            onTap: () {
                                              selectSeat(children);
                                            },
                                            child: buildSeat(
                                              children,
                                              margin:  EdgeInsets.only(right: groupIndex == 0 ? seatGap : 0),
                                              width: groupWidth,
                                              height: seatSize,
                                              child: wheelChair
                                            ),
                                          ),
                                        );

                                        groupIndex++;
                                        if (seatGroup.last == children) {
                                          // 不在组内
                                          groupIndex = 0;
                                        }

                                        return result;
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
                                            selectSeat(children);
                                          },
                                          child: buildSeat(
                                            children,
                                            margin: margin, 
                                            width: seatSize, 
                                            height: seatSize
                                          ),
                                        );
                                        // return
                                      }

                                    }
                                  }).toList(),
                                ),
                                );
                              }
                            })
                        ],
                      )
                        ],
                      )
                     
              ])))
          ),
          ),
        
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 12.w,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: SingleChildScrollView(
                // 垂直方向滚动
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      // 水平方向滚动
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            ...seatType.map((item) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  item['widget'],
                                  SizedBox(width: 8.w),
                                  Text(item['name'], style: TextStyle(fontSize: 24.sp)),
                                ],
                              );
                            }),
                          ],
                        ),
                      )
                    ),
                    SizedBox(height: 16.w), // 添加间距
                    SingleChildScrollView(
                      // 水平方向滚动
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Wrap(
                          spacing: 8.w,
                          alignment: WrapAlignment.center,
                          children: [
                            ...(data.area ?? []).map((item) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 28.w,
                                    height: 28.w,
                                    margin: const EdgeInsets.only(right: 6.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.red, width: 1.5),
                                    ),
                                  ),
                                  Text(
                                    '${item.name!}（${item.price}円）',
                                    style: TextStyle(fontSize: 24.sp),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      )
                    ),
                    
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 10,
            child: Wrap(
              runSpacing: 30.h,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: const Offset(0.0, 3.0), //阴影y轴偏移量
                          blurRadius: 2, //阴影模糊程度
                          spreadRadius: 2 //阴影扩散程度
                          )
                    ],

                  ),
                  child: Wrap(
                    runSpacing: 10.h,
                    children: [
                      Text(_showTimeData.movieName ?? '', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                     
                          Text('${_showTimeData.date ?? ''}（${getDay(_showTimeData.date ?? '', context)}）${_showTimeData.startTime} ~ ${_showTimeData.endTime}'),
                          // Text('2D'),
                        ],
                      ),
                      
                      Wrap(
                        spacing: 20.w,
                        runSpacing: 15.h,
                        children: selectSeatList.map((item) {
                          return GestureDetector(
                            onTap: () {
                              if (item.seatPositionGroup != null) {
                                // 情侣座
                                item.seatPositionGroup!.split('-').forEach((el) {
                                  List<String> position = el.split(',');
                                  int x = int.parse(position[0]);
                                  int y = int.parse(position[1]);

                                  
                                  // 获取行的index，需要考虑空排
                                  int row = seatData.indexWhere((el) => el.rowAxis == x);

                                  if (row != -1) {
                                    SeatItem seat = seatData[row].children!.firstWhere((el) => el.y == y);

                                    selectSeatList.removeWhere((el) => el.id == seat.id);
                                  }
                                });
                              } else {
                                // 不同座位
                                selectSeatList.removeWhere((el) => el.id == item.id);
                              }

                              setState(() {
                                  selectSeatList = selectSeatList;
                                  selectSeatSet = selectSeatList.map((el) => el.id!).toSet();
                                });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.w, horizontal: 18.w),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(100)),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10.w,
                                children: [
                                  Text('${item.seatName}', style: TextStyle(fontSize: 24.sp)),
                                  Icon(Icons.close, color: Colors.grey.shade400, size: 20)
                                ],
                              )
                            )
                          );
                        }).toList()),
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 70.h,
                  color: Colors.blue,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(100))),
                  onPressed: () {
                    if (selectSeatList.isEmpty) {
                      ToastService.showWarning(S.of(context).selectSeat_notSelectSeatWarn);
                      return;
                    }
                    ApiRequest().request(
                      path: '/movie_show_time/select_seat/save',
                      method: 'POST',
                      data: {
                        'movieShowTimeId': _showTimeData.id,
                        "theaterHallId":_showTimeData.theaterHallId,
                        'seatPosition': selectSeatList.map((item) {
                          return {
                            "x": item.x,
                            "y": item.y,
                            "seatId": item.id
                          };
                        }).toList()
                      },
                      fromJsonT: (json) {},
                    ).then((res) {
                      context.pushNamed("selectMovieTicketType", queryParameters: {
                        'movieShowTimeId': '${_showTimeData.id}',
                        'cinemaId': '${_showTimeData.cinemaId}'
                      });
                    });

                  },
                  child: Text(
                      S.of(context).selectSeat_confirmSelectSeat,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp)),
                )
              ],
            )
          )
        ],
      ),
     
      // ),
    );
  }
}
