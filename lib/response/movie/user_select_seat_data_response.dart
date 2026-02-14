import 'package:json_annotation/json_annotation.dart';

part 'user_select_seat_data_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class UserSelectSeatDataResponse {
  
  final int? movieShowTimeId;
  
  final int? movieId;
  
  final String? movieName;
  
  final String? moviePoster;
  
  final String? date;
  
  final String? startTime;
  
  final String? endTime;
  
  final String? specName;
  
  /// 放映类型（2D/3D），用于 Dict 组件字典 dimensionType
  final int? dimensionType;

  /// 是否支持ムビチケ等前売り券
  final bool? allowPresale;

  /// 定价模式：1=系统活动 2=固定价格
  final int? pricingMode;

  /// 固定价格模式下的单价（pricing_mode=2）
  final num? fixedAmount;
  
  final int? cinemaId;
  
  final String? cinemaName;
  
  final int? theaterHallId;
  
  final String? theaterHallName;
  
  /// 规格加价列表（如 IMAX、Dolby 等）
  final List<SpecPrice>? specPriceList;
  
  /// 放映类型名称（2D/3D）
  final String? displayTypeName;
  
  /// 放映类型加价（2D/3D 的加价，如 3D 加 300）
  final int? displayTypeSurcharge;
  
  final List<Seat>? seat;

  UserSelectSeatDataResponse({
    this.movieShowTimeId,
    this.movieId,
    this.movieName,
    this.moviePoster,
    this.date,
    this.startTime,
    this.endTime,
    this.specName,
    this.dimensionType,
    this.allowPresale,
    this.pricingMode,
    this.fixedAmount,
    this.cinemaId,
    this.cinemaName,
    this.theaterHallId,
    this.theaterHallName,
    this.specPriceList,
    this.displayTypeName,
    this.displayTypeSurcharge,
    this.seat,
  });

  factory UserSelectSeatDataResponse.fromJson(Map<String, dynamic> json) => _$UserSelectSeatDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserSelectSeatDataResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class Seat {
  
  final int? x;
  
  final int? y;
  
  final int? seatId;
  
  final String? seatName;
  
  final int? areaPrice;
  
  final String? areaName;
  
  int? movieTicketTypeId;

  Seat({
    this.x,
    this.y,
    this.seatId,
    this.seatName,
    this.areaPrice,
    this.areaName,
    this.movieTicketTypeId,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);
}

/// 规格价格
@JsonSerializable(fieldRename: FieldRename.none)
class SpecPrice {
  /// 规格名称（如 IMAX、Dolby）
  final String? name;
  
  /// 加价（单位：日元）
  final int? plusPrice;

  SpecPrice({
    this.name,
    this.plusPrice,
  });

  factory SpecPrice.fromJson(Map<String, dynamic> json) => _$SpecPriceFromJson(json);

  Map<String, dynamic> toJson() => _$SpecPriceToJson(this);
}
