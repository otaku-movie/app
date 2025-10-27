import 'package:json_annotation/json_annotation.dart';

part 'cinema_movie_show_time_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CinemaMovieShowTimeDetailResponse {
    
    final int? cinemaId;
    
    final String? cinemaName;
    
    final String? cinemaFullAddress;
    
    final String? cinemaTel;
    
    final List<CinemaMovieShowTimeDetailResponseDatum>? data;

    CinemaMovieShowTimeDetailResponse({
        this.cinemaId,
        this.cinemaName,
        this.cinemaFullAddress,
        this.cinemaTel,
        this.data,
    });

    factory CinemaMovieShowTimeDetailResponse.fromJson(Map<String, dynamic> json) => _$CinemaMovieShowTimeDetailResponseFromJson(json);

    Map<String?, dynamic> toJson() => _$CinemaMovieShowTimeDetailResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class CinemaMovieShowTimeDetailResponseDatum {
    
    final String? date;
    
    final List<TheaterHallShowTime>? data;

    CinemaMovieShowTimeDetailResponseDatum({
        this.date,
        this.data,
    });

    factory CinemaMovieShowTimeDetailResponseDatum.fromJson(Map<String, dynamic> json) => _$CinemaMovieShowTimeDetailResponseDatumFromJson(json);

    Map<String?, dynamic> toJson() => _$CinemaMovieShowTimeDetailResponseDatumToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class TheaterHallShowTime {
    
    final int? id;
    
    final int? theaterHallId;
    
    final String? theaterHallName;
    
    final String? startTime;
    
    final String? endTime;

    final String? specName;

    final List<ShowTimeTag>? movieShowTimeTags;
    
    final List<ShowTimeTag>? showTimeTags;

    final List<ShowTimeSubtitle>? subtitle;

    // 添加座位状态相关字段
    final int? seatStatus; // 座位状态：0-充足，1-紧张，2-售罄
    final int? availableSeats; // 可用座位数
    final int? totalSeats; // 总座位数

    TheaterHallShowTime({
        this.id,
        this.theaterHallId,
        this.theaterHallName,
        this.startTime,
        this.endTime,
        this.specName,
        this.movieShowTimeTags,
        this.showTimeTags,
        this.subtitle,
        this.seatStatus,
        this.availableSeats,
        this.totalSeats,
    });

    factory TheaterHallShowTime.fromJson(Map<String, dynamic> json) => _$TheaterHallShowTimeFromJson(json);

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

    factory ShowTimeTag.fromJson(Map<String, dynamic> json) => _$ShowTimeTagFromJson(json);

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

    factory ShowTimeSubtitle.fromJson(Map<String, dynamic> json) => _$ShowTimeSubtitleFromJson(json);

    Map<String, dynamic> toJson() => _$ShowTimeSubtitleToJson(this);
}
