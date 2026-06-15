import 'package:json_annotation/json_annotation.dart';

part 'show_time.g.dart';

/// 单日「上映影院数 / 场次数」摘要（来自后端 `summary` 字段）。
/// 由 controller 在分页切片前用全量数据计算，前端用它显示顶部摘要条，
/// 保证无论加载到第几页都展示准确总数。
class ShowTimeSummary {
  final String? date;
  final int? cinemaCount;
  final int? showTimeCount;

  ShowTimeSummary({this.date, this.cinemaCount, this.showTimeCount});

  factory ShowTimeSummary.fromJson(Map<String, dynamic> json) =>
      ShowTimeSummary(
        date: json['date'] as String?,
        cinemaCount: (json['cinemaCount'] as num?)?.toInt(),
        showTimeCount: (json['showTimeCount'] as num?)?.toInt(),
      );
}

/// `/app/movie/showTime` 接口的新响应包装：分页后的场次列表 + 全量 perDate 摘要。
/// 兼容旧响应：旧版接口直接返回 `List`，此处 `summary` 为空。
class ShowTimeListResult {
  final List<ShowTimeResponse> data;
  final List<ShowTimeSummary> summary;

  ShowTimeListResult({required this.data, required this.summary});

  factory ShowTimeListResult.empty() =>
      ShowTimeListResult(data: const [], summary: const []);
}

@JsonSerializable(fieldRename: FieldRename.none)
class ShowTimeResponse {
  final String? date;

  final List<Cinema>? data;

  ShowTimeResponse({
    this.date,
    this.data,
  });

  factory ShowTimeResponse.fromJson(Map<String, dynamic> json) =>
      _$ShowTimeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ShowTimeResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class Cinema {
  final int? cinemaId;

  final String? cinemaName;

  final String? cinemaAddress;

  final List<ShowTime>? showTimes;

  @JsonKey(name: "cinemaLatitude")
  final double? cinemaLatitude;

  @JsonKey(name: "cinemaLongitude")
  final double? cinemaLongitude;

  /// 当前用户是否已收藏该影院（可本地 toggle）
  bool? favorite;

  double? distance;

  Cinema({
    this.cinemaId,
    this.cinemaName,
    this.cinemaAddress,
    this.showTimes,
    this.cinemaLatitude,
    this.cinemaLongitude,
    this.favorite,
    this.distance,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) => _$CinemaFromJson(json);

  Map<String, dynamic> toJson() => _$CinemaToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class ShowTime {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "theaterHallId")
  int? theaterHallId;
  @JsonKey(name: "theaterHallName")
  String? theaterHallName;
  @JsonKey(name: "startTime")
  DateTime? startTime;
  @JsonKey(name: "endTime")
  DateTime? endTime;
  @JsonKey(name: "specNames")
  List<String>? specNames;
  @JsonKey(name: "totalSeats")
  int? totalSeats;
  @JsonKey(name: "selectedSeats")
  int? selectedSeats;
  @JsonKey(name: "availableSeats")
  int? availableSeats;
  @JsonKey(name: "subtitleId")
  dynamic subtitleId;
  @JsonKey(name: "showTimeTagId")
  dynamic showTimeTagId;
  @JsonKey(name: "subtitle")
  dynamic subtitle;
  @JsonKey(name: "showTimeTags")
  dynamic showTimeTags;
  @JsonKey(name: "movieVersionId")
  int? movieVersionId;
  @JsonKey(name: "versionCode")
  int? versionCode;

  /// 放映类型：2D/3D，对应 dict_item.id
  @JsonKey(name: "dimensionType")
  int? dimensionType;

  /// 是否开放售票：true-可售，false-已禁用
  @JsonKey(name: "open")
  bool? open;

  /// 该场次是否有入场者特典（设计 3.2）
  @JsonKey(name: "hasBenefits")
  bool? hasBenefits;

  /// 网友反馈：该场次/影院特典今日已领完（后端根据反馈数据反哺）
  @JsonKey(name: "benefitFeedbackSoldOut")
  bool? benefitFeedbackSoldOut;

  /// 关联重映计划ID（为空表示普通上映场次）
  @JsonKey(name: "reReleaseId")
  int? reReleaseId;

  /// 重映特殊版本说明（可空）
  @JsonKey(name: "reReleaseVersionInfo")
  String? reReleaseVersionInfo;

  /// 影院官方购票页 URL。为空时前端提示用户去影院官网购票。
  @JsonKey(name: "reservationUrl")
  String? reservationUrl;

  /// 爬虫透传的售票/座位状态：on_sale / few / sold_out / pre_sale / sale_ended / closed / unknown。
  /// 当 [totalSeats]==0（外部预约场次）时，前端基于此字段渲染座位状态图标。
  @JsonKey(name: "saleStatus")
  String? saleStatus;

  /// 字幕语言名称列表（如 ['English']、['日本語', '简体中文']）。
  /// 非空时表示这是"字幕版"场次——原音 + 该语种字幕，与"吹替版"区分；
  /// 列表卡片应展示对应 chip + tooltip 让用户一眼分辨。
  @JsonKey(name: "subtitleNames")
  List<String>? subtitleNames;

  /// 特殊场次名/活动名（来自标题装饰，普通场次为空）。
  @JsonKey(name: "eventTitle")
  String? eventTitle;

  ShowTime({
    this.id,
    this.theaterHallId,
    this.theaterHallName,
    this.startTime,
    this.endTime,
    this.specNames,
    this.totalSeats,
    this.selectedSeats,
    this.availableSeats,
    this.subtitleId,
    this.showTimeTagId,
    this.subtitle,
    this.showTimeTags,
    this.movieVersionId,
    this.versionCode,
    this.dimensionType,
    this.open,
    this.hasBenefits,
    this.benefitFeedbackSoldOut,
    this.reReleaseId,
    this.reReleaseVersionInfo,
    this.reservationUrl,
    this.saleStatus,
    this.subtitleNames,
    this.eventTitle,
  });

  factory ShowTime.fromJson(Map<String, dynamic> json) =>
      _$ShowTimeFromJson(json);

  Map<String, dynamic> toJson() => _$ShowTimeToJson(this);
}
