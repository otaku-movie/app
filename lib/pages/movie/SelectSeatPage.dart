import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
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
  double seatSize = 25;
  // 座位间距
  double seatGap = 8;
  int rowCount = 25;
  int columnCount = 20;

  TheaterSeat data = TheaterSeat();
  MovieShowTimeDetailResponse _showTimeData = MovieShowTimeDetailResponse();
  List<Seat> seatData = [];
  Set<int> selectSeatSet = {};
  List<SeatItem> selectSeatList = [];

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
      path: '/theater/hall/seat/detail',
      method: 'GET',
      queryParameters: {
        'theaterHallId': widget.theaterHallId
      },
      fromJsonT: (json) {
        return TheaterSeat.fromJson(json) ;
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
    getData();
    getSeatData();
  }

 
  

 void selectSeat (SeatItem item) {
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

  @override
  Widget build(BuildContext context) {
     List<Map<String, dynamic>> seatType = [
      {
        "icon": SvgPicture.asset(
          'assets/icons/wheelChair.svg',
          width: 28.w,
          height: 28.w,
        ),
        "name": S.of(context).common_enum_seatType_wheelChair,
      },
      {
        "name": S.of(context).common_enum_seatType_disabled,
      },
      {
        "name": S.of(context).common_enum_seatType_selectable,
      },
      {
        "name": S.of(context).common_enum_seatType_locked,
      },
      {
        "name": S.of(context).common_enum_seatType_sold
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Wrap(
              direction: Axis.vertical,
              spacing: 6,
              // alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  
                  children: [
                    ...seatType.map((item) {
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          item["icon"] != null ? item['icon'] : Container(
                            width: 28.w,
                            height: 28.w,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.red, width: 1.5)
                            ),
                            child: item['icon'],
                          ),
                          Text(item['name'], style: TextStyle(fontSize: 24.sp))
                        ],
                      );
                    }),
                  ]
                ),
                Wrap(
                  spacing: 8,
                  // alignment: WrapAlignment.center,
                  children: [
                    ...(data.area ?? []).map((item) {
                      return Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            width: 28.w,
                            height: 28.w,
                            margin: const EdgeInsets.only(right: 6.0),
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.red, width: 1.5)
                            )
                          ),
                          Text('${item.name!}（${item.price}円）', style: TextStyle(fontSize: 24.sp))
                        ],
                      );
                    }),
                  ],
                ),
              ]),
            ),
            )
          ),
        ),
      body: Stack(
        children: [
           GestureDetector(
            onScaleUpdate: (details) {
              print(details);
              setState(() {
                _scaleFactor = details.scale.clamp(0.5, 3.0);
              });
            },
          child: InteractiveViewer(
              constrained: false,
              boundaryMargin:  EdgeInsets.only(top: 50.h, left: 500, right: 500,bottom: 1000.h),
              minScale: 0.1,
              maxScale: 2.6,
              transformationController: transformationController,
              child: Container(
                  child: Wrap(
                    spacing: 0.0,
                    children: [
                      Container(
                          // padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          // decoration: BoxDecoration(
                          //   color: Color.fromRGBO(0, 0, 0, 0.5),
                          //   borderRadius: BorderRadius.circular(50)
                          // ),
                        child: Wrap(
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
                                  '${row.rowName ?? ''}',
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                )
                              );
                            })
                          ]
                        )
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
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
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
                                      BoxDecoration decoration = const BoxDecoration();

                                      // 不可选的座位
                                      if (children.disabled!) {
                                        decoration = BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(6.0),
                                          border: Border.all(color: Colors.grey.shade300)
                                        );
                                      } else if (children.selectSeatState != null && children.selectSeatState == SelectSeatState.locked) {
                                        // 座位已锁定
                                        decoration = BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(6.0),
                                          border: Border.all(color: Colors.grey.shade300)
                                        );
                                      } else if (children.selectSeatState != null && children.selectSeatState == SelectSeatState.sold) {
                                        // 座位已售出
                                        decoration = BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(6.0),
                                          border: Border.all(color: Colors.grey.shade300)
                                        );
                                      } else if (children.selectSeatState != null && children.selectSeatState == SelectSeatState.available) {
                                        decoration = BoxDecoration(
                                          borderRadius: BorderRadius.circular(6.0),
                                          border: Border.all(color: const Color.fromARGB(255, 6, 130, 239), width: 1.5)
                                        );
                                      }

                                      if (selectSeatSet.contains(children.id)) {
                                         decoration = BoxDecoration(
                                          color: const Color.fromARGB(255, 228, 71, 178),
                                          borderRadius: BorderRadius.circular(6.0),
                                          border: Border.all(color: const Color.fromARGB(255, 228, 71, 178), width: 1.5)
                                        );
                                      }
                
                                      SvgPicture? wheelChair = children.wheelChair?? false ? SvgPicture.asset(
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
                                        double totalWidth = seatSize * seatGroup.length + seatGap * (seatGroup.length - 1);
                                        // groupIndex * -seatGap / 1.5
                                        Widget result = Transform.translate(
                                          offset: groupIndex == 0 ? const Offset(0, 0) : Offset(groupIndex * -seatGap / 1.5, 0),
                                          child:  GestureDetector(
                                            onTap: () {
                                              selectSeat(children);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(right: seatGap / 2),
                                              width: totalWidth / seatGroup.length, // 给座位增加边距，避免重叠
                                              height: seatSize,
                                              decoration: decoration,
                                              alignment: Alignment.center,
                                              child: wheelChair,
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
                                          child: Container(
                                            margin: EdgeInsets.only(left: 0, right: seatGap),
                                            width: seatSize,
                                            height: seatSize,
                                            decoration: decoration,
                                            alignment: Alignment.center,
                                            child: wheelChair,
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
              ])))
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
                    context.pushNamed("selectMovieTicketType");
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
          // Positioned(
          //     top: 0,
          //     left: 20,
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          //       decoration: BoxDecoration(
          //         color: Color.fromRGBO(0, 0, 0, 0.5),
          //         borderRadius: BorderRadius.circular(50)
          //       ),
          //     child: Wrap(
          //         direction: Axis.vertical,
          //         children: List.generate(30, (index) {
          //           return Container(
          //               width: seatSize, // 排号区域宽度
          //               height: seatSize,
          //               alignment: Alignment.center,
          //               // color: Colors.red,
          //               child: Text(
          //                 '${index + 1}',
          //                 style: const TextStyle(fontSize: 16, color: Colors.white),
          //               ));
          //         })),
          //   )
          // ),
        ],
      ),
     
      // ),
    );
  }
}
