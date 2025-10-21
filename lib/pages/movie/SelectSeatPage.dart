import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otaku_movie/components/CinemaScreen.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/enum/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/response/movie/movie_show_time_detail.dart';
import 'package:otaku_movie/response/movie/theater_seat.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/utils/toast.dart';

import '../../api/index.dart';

class SelectSeatPage extends StatefulWidget {
  final String? id;
  final String? theaterHallId;
  
  SelectSeatPage({super.key, this.id, this.theaterHallId});

  @override
  // ignore: library_private_types_in_public_api
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SelectSeatPage> {
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
      path: '/movie_show_time/detail',
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
      item.disabled
    ) {
      return;
    }

    if (selectSeatSet.length >= (data.maxSelectSeatCount ?? 0)) {
      return ToastService.showWarning(S.of(context).selectSeat_maxSelectSeatWarn(data.maxSelectSeatCount ?? 0));
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

    // 默认状态
    Widget result = generatorSeatState(
      'available', 
      margin: margin, 
      width: width, 
      height: height,
      child: child
    );

    // 优先级1: 不可选的座位
    if (seat.disabled) {
      result = generatorSeatState(
        'disabled', 
        margin: margin, 
        width: width, 
        height: height,
        child: child
      );
    }
    
    // 优先级2: 座位状态 (sold/locked 优先级高于区域)
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
    
    // 优先级3: 已选中的座位
    if (selectSeatSet.contains(seat.id)) {
      // 如果有区域颜色，使用区域颜色的选中状态
      if (seat.area != null && seat.area!.color != null) {
        result = _buildSeatWithAreaColorSelected(seat, width, height, margin, child);
      } else {
        // 使用默认的选中状态
        result = generatorSeatState(
          'selected', 
          margin: margin, 
          width: width, 
          height: height,
          child: child
        );
      }
    }
    
    // 优先级4: 区域颜色 (只有在没有更高优先级状态时才应用)
    if (seat.area != null && seat.area!.color != null && 
        seat.selectSeatState != locked && seat.selectSeatState != sold &&
        !selectSeatSet.contains(seat.id) && !seat.disabled) {
      // 使用区域颜色渲染座位
      result = _buildSeatWithAreaColor(seat, width, height, margin, child);
    }

    return result;
 }

  // 使用区域颜色渲染座位
  Widget _buildSeatWithAreaColor(SeatItem seat, double? width, double? height, 
      EdgeInsetsGeometry? margin, Widget? child) {
    double finalWidth = width ?? 32.w;
    double finalHeight = height ?? 32.w;
    double finalRadius = 10.w;
    
    Color areaColor = parseColor(seat.area!.color);
    
    return Container(
      width: finalWidth,
      height: finalHeight,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(finalRadius),
        border: Border.all(color: areaColor, width: 1.5),
      ),
      child: child,
    );
  }

  // 使用区域颜色渲染选中状态的座位
  Widget _buildSeatWithAreaColorSelected(SeatItem seat, double? width, double? height, 
      EdgeInsetsGeometry? margin, Widget? child) {
    double finalWidth = width ?? 32.w;
    double finalHeight = height ?? 32.w;
    double finalRadius = 10.w;
    
    Color areaColor = parseColor(seat.area!.color);
    
    return Container(
      width: finalWidth,
      height: finalHeight,
      margin: margin,
      decoration: BoxDecoration(
        color: areaColor, // 使用区域颜色作为背景色
        borderRadius: BorderRadius.circular(finalRadius),
        border: Border.all(color: areaColor, width: 1.5),
      ),
      child: Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: finalWidth * 0.6, // 图标大小按宽度比例
        ),
      ),
    );
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
    double finalRadius = radius ?? 10.w; // 默认圆角

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
          border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
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
      borderColor: Color.fromARGB(255, 0, 135, 252),
      margin: margin,
      child: child,
      color: Colors.white,
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
      // {
      //  'name': S.of(context).common_enum_seatType_disabled,
      //   'widget': generatorSeatState('disabled'),
      // },
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
      backgroundColor: Colors.grey.shade100,
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
              // Scale factor is handled by InteractiveViewer
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
                       Center(
                         child: Container(
                           width: columnCount > 0 ? (seatSize + seatGap) * columnCount : 200.w, // 根据座位列数计算宽度
                           height: 80.h, // 固定高度
                           margin: EdgeInsets.only(top:100.h, bottom: 150.h),
                           child: CinemaScreen(
                             width: columnCount > 0 ? (seatSize + seatGap) * columnCount : 200.w,
                             height: 80.h,
                             hallName: _showTimeData.theaterHallName ?? "",
                           ),
                         ),
                       ),
                      
                      // 生成座位行号
                      Space(
                        children: [
                           Wrap(
                             direction: Axis.vertical,
                             children: [
                               Container(
                                 width: seatSize,
                                 height: seatSize,
                                 alignment: Alignment.center,
                               ),
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
                          // 生成座位列号
                          Wrap(
                            direction: Axis.horizontal,
                            children: buildSeatColumnName()
                          ),
                          // 生成座位
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
                                      border: Border.all(color: parseColor(item.color), width: 1),
                                    ),
                                  ),
                                  Text(
                                    '${item.name}（${item.price}${S.of(context).common_unit_jpy}）',
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
            bottom: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 电影信息卡片
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 电影标题
                      Text(
                        _showTimeData.movieName ?? '',
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),
                      
                      // 时间信息 - 年月日和时间在同一行
                      Row(
                        children: [
                          Text(
                            '${formatTime(timeString: _showTimeData.startTime, format: S.of(context).cinemaList_selectSeat_dateFormat)}（${getDay(formatTime(timeString: _showTimeData.startTime, format: 'yyyy-MM-dd'), context)}）',
                            style: TextStyle(
                              fontSize: 28.sp,
                              color: Colors.grey.shade600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            formatTime(timeString: _showTimeData.startTime, format: 'HH:mm'),
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            ' ~ ',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey.shade500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            formatTime(timeString: _showTimeData.endTime, format: 'HH:mm'),
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      
                      // 标签组
                      Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: [
                          // 影厅规格标签
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.movie,
                                  size: 22.sp,
                                  color: Colors.blue.shade600,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  _showTimeData.specName ?? '',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade700,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // 影厅名称标签
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 22.sp,
                                  color: Colors.green.shade600,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  _showTimeData.theaterHallName ?? '',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // 字幕标签
                          ...(_showTimeData.subtitle?.map((item) => 
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.subtitles,
                                    size: 22.sp,
                                    color: Colors.orange.shade600,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    item.name ?? '',
                                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.orange.shade700, fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                            )
                          ).toList() ?? []),
                          
                          // 电影场次标签 - 动态渲染
                          ...(_showTimeData.movieShowTimeTags?.map((tag) => 
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.purple.shade400,
                                    Colors.purple.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_activity,
                                    size: 22.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    tag.name ?? '',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ).toList() ?? []),
                        ],
                      ),
                      
                      // 已选座位
                      if (selectSeatList.isNotEmpty) ...[
                        SizedBox(height: 16.h),
                        Text(
                          S.of(context).cinemaList_selectSeat_selectedSeats,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 18.w,
                          runSpacing: 8.h,
                          children: selectSeatList.map((seat) {
                            return GestureDetector(
                              onTap: () {
                              setState(() {
                                  selectSeatList.removeWhere((s) => s.id == seat.id);
                                });
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(color: Colors.blue.shade200),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                children: [
                                    Text(
                                      seat.seatName ?? '',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue.shade700,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Icon(
                                      Icons.close,
                                      size: 22.sp,
                                      color: Colors.blue.shade400,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
                
                SizedBox(height: 25.h),
                
                // 确认按钮
                Container(
                  width: double.infinity,
                  height: 72.h,
                  decoration: BoxDecoration(
                    gradient: selectSeatList.isNotEmpty
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF007BFF),
                              Color(0xFF0056CC),
                            ],
                          )
                        : null,
                    color: selectSeatList.isEmpty ? Colors.grey.shade300 : null,
                    borderRadius: BorderRadius.circular(36.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(36.r),
                      onTap: selectSeatList.isNotEmpty ? _confirmSelection : null,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (selectSeatList.isNotEmpty) ...[
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                              SizedBox(width: 12.w),
                            ],
                            Text(
                              selectSeatList.isEmpty
                                  ? S.of(context).cinemaList_selectSeat_pleaseSelectSeats
                                  : S.of(context).cinemaList_selectSeat_confirmSelection(selectSeatList.length),
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w600,
                                color: selectSeatList.isEmpty
                                    ? Colors.grey.shade500
                                    : Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  
  List<Widget> buildSeatColumnName() {
    int index = 0;

    if (seatData.isEmpty) {
      return [];
    }
    
    List<SeatItem> firstRow = seatData[0].children!;
    List<Widget> result = [];

    for (var item in firstRow) {
      if (item.type != SeatType.aisle) {
        index++;
      }
      result.add(
          Container(
            width: seatSize, // 排号区域宽度
            height: seatSize,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: seatGap),
            child: item.type == SeatType.aisle ? null : Text(
              '$index',
              style: TextStyle(fontSize: 24.sp, color: Colors.black),
            )
          )
        );
    }

    return result;
  }

  void _confirmSelection() {
    if (selectSeatList.isEmpty) return;
    
    // 这里可以添加确认选座的逻辑
    ToastService.showToast(S.of(context).cinemaList_selectSeat_seatsSelected(selectSeatList.length));
    
    // 可以导航到确认页面
    // context.push('/confirmOrder', extra: {
    //   'selectSeatList': selectSeatList,
    //   'showTimeData': _showTimeData,
    // });
  }
}