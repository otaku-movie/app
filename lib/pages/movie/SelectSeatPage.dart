import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:otaku_movie/enum/index.dart';
import 'package:otaku_movie/log/index.dart';
// import 'package:go_router/go_router.dart';
// import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/movie/theater_seat.dart';
import 'package:otaku_movie/response/response.dart';

import '../../api/index.dart';

class SelectSeatPage extends StatefulWidget {
  const SelectSeatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SelectSeatPage> {
  double _scaleFactor = 1.0;
  final Set<int> _selectedSeats = {};
  final Set<int> _coupleSeats = {2, 3, 27, 28, 52, 53}; // 示例情侣座

  void _toggleSeat(int seat) {
    setState(() {
      if (_selectedSeats.contains(seat)) {
        _selectedSeats.remove(seat);
        if (_coupleSeats.contains(seat)) {
          int coupleSeat = seat + 1;
          _selectedSeats.remove(coupleSeat);
        }
      } else {
        _selectedSeats.add(seat);
        if (_coupleSeats.contains(seat)) {
          int coupleSeat = seat + 1;
          _selectedSeats.add(coupleSeat);
        }
      }
    });
  }
  
  TransformationController  transformationController = TransformationController();

  // 座位大小
  double seatSize = 25;
  // 座位间距
  double seatGap = 4;
  int rowCount = 25;
  int columnCount = 20;

  TheaterSeat data = TheaterSeat();
  List<Seat> seatData = [];
  

  void getData() {
    ApiRequest().request(
      path: '/theater/hall/seat/detail',
      method: 'GET',
      queryParameters: {
        'theaterHallId': 34
      },
      fromJsonT: (json) {
        return TheaterSeat.fromJson(json) ;
      },
    ).then((res) {
      print('--- api response ----');
      log.i(res.data);
      

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
  }

  List<Map<String, dynamic>> seatType = [
    {
      "icon": SvgPicture.asset(
        'assets/icons/wheelChair.svg',
        width: 28.w,
        height: 28.w,
      ),
      "name": '轮椅座',
    },
    {
      "name": '已禁用'
    },
    {
      "name": '可选座'
    },
    {
      "name": '已锁定'
    },
    {
      "name": '已售出'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const SizedBox(
          width: double.infinity,
          child: Center(
            child: Text('東宝シネマズ　新宿'),
          ),
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
                    ...data.area!.map((item) {
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
                          Text('${item.name!}　${item.price}円', style: TextStyle(fontSize: 24.sp))
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
                              margin: EdgeInsets.all(seatGap),
                            ),
                            ...seatData.map((row)  {
                              return Container(
                                width: seatSize,
                                height: seatSize,
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(seatGap),
                                child: Text(
                                  '${row.rowAxis ?? ''}',
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
                                  margin: EdgeInsets.all(seatGap),
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
                                int index = 0;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: row.children!.map((children) {
                                    index++;
                                    // 如果是过道，或者座位本身不显示就为空白
                                    if (children.type == SeatType.aisle || !children.show!) {
                                      return Container(
                                        margin: EdgeInsets.all(seatGap),
                                        width: seatSize,
                                        height: seatSize,
                                        color: Colors.transparent
                                      );
                                    } else {
                                      // 如果是普通座位，提供点击事件
                                      if (children.wheelChair!) {
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            margin: EdgeInsets.all(seatGap),
                                            width: seatSize,
                                            height: seatSize,
                                            alignment: Alignment.center,
                                            child:  SvgPicture.asset(
                                              'assets/icons/wheelChair.svg',
                                              width: seatSize,
                                              height: seatSize,
                                            ),
                                          ),
                                        ); 
                                      }
                                      // 不可选的座位
                                      if (children.disabled ?? false) {
                                        return Container(
                                          margin: EdgeInsets.all(seatGap),  // 座位间的间隙
                                          width: seatSize,  // 座位的大小
                                          height: seatSize,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(6.0),
                                            border: Border.all(color: Colors.grey.shade300)
                                          ),
                                          alignment: Alignment.center,  // 内容居中
                                        );
                                      }

                                      // 座位已锁定
                                      if (children.selectSeatState != null && children.selectSeatState == SelectSeatState.locked) {
                                        return Container(
                                          margin: EdgeInsets.all(seatGap),  // 座位间的间隙
                                          width: seatSize,  // 座位的大小
                                          height: seatSize,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(6.0),
                                            border: Border.all(color: Colors.grey.shade300)
                                          ),
                                          alignment: Alignment.center,  // 内容居中
                                        );
                                      }
                                      // 座位已售出
                                      if (children.selectSeatState != null && children.selectSeatState == SelectSeatState.sold) {
                                        return Container(
                                          margin: EdgeInsets.all(seatGap),  // 座位间的间隙
                                          width: seatSize,  // 座位的大小
                                          height: seatSize,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(6.0),
                                            border: Border.all(color: Colors.grey.shade300)
                                          ),
                                          alignment: Alignment.center,  // 内容居中
                                        );
                                      }
                                      // 设置了区域

                                      // if (children.area != null) {
                                      //   return Container(
                                      //     margin: EdgeInsets.all(seatGap),  // 座位间的间隙
                                      //     width: seatSize,  // 座位的大小
                                      //     height: seatSize,
                                      //     decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.circular(4.0),
                                      //       border: Border.all(color: Colors.grey.shade300)
                                      //     ),
                                      //     alignment: Alignment.center,  // 内容居中
                                      //   );
                                      // }
                                      // 普通座位
                                      return Transform.translate(
                                        offset: Offset(index % 2 == 0 ? -9 : 0, 0),
                                          child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            margin: EdgeInsets.all(seatGap),
                                            width: seatSize,
                                            height: seatSize,
                                            decoration: BoxDecoration(
                                              // color: Colors.black,
                                              borderRadius: BorderRadius.circular(6.0),
                                              border: Border.all(color: const Color.fromARGB(255, 6, 130, 239), width: 1.5)
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      );
                                    }
                                  }).toList(),
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
                      Text('鬼灭之刃 无限城篇', style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold)),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('今天 11月4日（一）10:00 ~ 12:00'),
                          Text('2D'),
                        ],
                      ),
                      
                      Wrap(
                        spacing: 20.w,
                        runSpacing: 15.h,
                        children: ['1排2座', '1排3座', '1排4座', '1排5座', '1排6座','1排7座'].map((item) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.w, horizontal: 29.w),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(100)),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10.w,
                              children: [
                                Text(item, style: TextStyle(fontSize: 24.sp)),
                                Icon(Icons.close, color: Colors.grey.shade400, size: 20,)
                              ],
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
                    getData();
                    // context.go('/movie/ShowTimeList');
                  },
                  child: Text(
                      '确认选座',
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
