import 'package:json_annotation/json_annotation.dart';

part 'cinema_movie_show_time_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class CinemaMovieShowTimeDetailResponse {
    
    final int? cinemaId;
    
    final String? cinemaName;
    
    final String? cinemaAddress;
    
    final String? cinemaTel;
    
    final List<CinemaMovieShowTimeDetailResponseDatum>? data;

    CinemaMovieShowTimeDetailResponse({
        this.cinemaId,
        this.cinemaName,
        this.cinemaAddress,
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

    TheaterHallShowTime({
        this.id,
        this.theaterHallId,
        this.theaterHallName,
        this.startTime,
        this.endTime,
        this.specName
    });

    factory TheaterHallShowTime.fromJson(Map<String, dynamic> json) => _$TheaterHallShowTimeFromJson(json);

    Map<String, dynamic> toJson() => _$TheaterHallShowTimeToJson(this);
}
