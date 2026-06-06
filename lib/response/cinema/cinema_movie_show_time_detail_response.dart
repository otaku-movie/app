import 'package:json_annotation/json_annotation.dart';

part 'cinema_movie_show_time_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CinemaMovieShowTimeDetailResponse {
  final int? cinemaId;

  final String? cinemaName;

  final String? cinemaFullAddress;

  final String? cinemaTel;

  final double? cinemaLatitude;

  final double? cinemaLongitude;

  final List<CinemaMovieShowTimeDetailResponseDatum>? data;

  CinemaMovieShowTimeDetailResponse({
    this.cinemaId,
    this.cinemaName,
    this.cinemaFullAddress,
    this.cinemaTel,
    this.cinemaLatitude,
    this.cinemaLongitude,
    this.data,
  });

  factory CinemaMovieShowTimeDetailResponse.fromJson(
          Map<String, dynamic> json) =>
      _$CinemaMovieShowTimeDetailResponseFromJson(json);

  Map<String?, dynamic> toJson() =>
      _$CinemaMovieShowTimeDetailResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class CinemaMovieShowTimeDetailResponseDatum {
  final String? date;

  final List<TheaterHallShowTime>? data;

  CinemaMovieShowTimeDetailResponseDatum({
    this.date,
    this.data,
  });

  factory CinemaMovieShowTimeDetailResponseDatum.fromJson(
          Map<String, dynamic> json) =>
      _$CinemaMovieShowTimeDetailResponseDatumFromJson(json);

  Map<String?, dynamic> toJson() =>
      _$CinemaMovieShowTimeDetailResponseDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class TheaterHallShowTime {
  final int? id;

  final int? theaterHallId;

  final String? theaterHallName;

  final String? startTime;

  final String? endTime;

  final String? specName;

  /// 放映类型：2D/3D，对应 dict_item.id。
  final int? dimensionType;

  final int? versionCode;

  final List<ShowTimeTag>? movieShowTimeTags;

  final List<ShowTimeTag>? showTimeTags;

  final List<ShowTimeSubtitle>? subtitle;

  // 添加座位状态相关字段
  final int? seatStatus; // 座位状态：0-充足，1-紧张，2-售罄
  final int? availableSeats; // 可用座位数
  final int? totalSeats; // 总座位数

  /// 是否开放售票：true-可售，false-已禁用
  final bool? open;

  /// 影院官方购票页 URL。后端从 `crawl.movie_show_time.reservation_params_json`
  /// 抽取，覆盖率视品牌而定；TOHO / AEON / MOVIX / Grand Cinema Sunshine
  /// 当前可售场次接近 100%，其他品牌以源站是否暴露购票按钮为准。
  /// 当本值为空字符串/null 时，前端应回退提示用户去影院官网购票。
  final String? reservationUrl;

  /// 爬虫透传的售票/座位状态：
  /// on_sale / few / sold_out / pre_sale / sale_ended / closed / unknown。
  /// 当为 pre_sale / sale_ended / closed / unknown 时，前端会把「购票」按钮变灰、
  /// 点击仅 toast 提示，避免跳到官网遇到 ERR-2002 之类错误页。
  final String? saleStatus;

  TheaterHallShowTime({
    this.id,
    this.theaterHallId,
    this.theaterHallName,
    this.startTime,
    this.endTime,
    this.specName,
    this.dimensionType,
    this.versionCode,
    this.movieShowTimeTags,
    this.showTimeTags,
    this.subtitle,
    this.seatStatus,
    this.availableSeats,
    this.totalSeats,
    this.open,
    this.reservationUrl,
    this.saleStatus,
  });

  factory TheaterHallShowTime.fromJson(Map<String, dynamic> json) =>
      _$TheaterHallShowTimeFromJson(json);

  Map<String, dynamic> toJson() => _$TheaterHallShowTimeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class ShowTimeTag {
  final int? id;
  final String? name;

  ShowTimeTag({
    this.id,
    this.name,
  });

  factory ShowTimeTag.fromJson(Map<String, dynamic> json) =>
      _$ShowTimeTagFromJson(json);

  Map<String, dynamic> toJson() => _$ShowTimeTagToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class ShowTimeSubtitle {
  final int? id;
  final String? name;
  final String? code;

  ShowTimeSubtitle({
    this.id,
    this.name,
    this.code,
  });

  factory ShowTimeSubtitle.fromJson(Map<String, dynamic> json) =>
      _$ShowTimeSubtitleFromJson(json);

  Map<String, dynamic> toJson() => _$ShowTimeSubtitleToJson(this);
}
