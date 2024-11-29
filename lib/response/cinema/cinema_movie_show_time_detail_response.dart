import 'package:json_annotation/json_annotation.dart';

part 'cinema_movie_show_time_detail_response.g.dart';

@JsonSerializable()
class CinemaMovieShowTimeDetailResponse {
    @JsonKey(name: "cinema_id")
    final int? cinemaId;
    @JsonKey(name: "cinema_name")
    final String? cinemaName;
    @JsonKey(name: "cinema_address")
    final String? cinemaAddress;
    @JsonKey(name: "cinema_tel")
    final String? cinemaTel;
    @JsonKey(name: "data")
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

@JsonSerializable()
class CinemaMovieShowTimeDetailResponseDatum {
    @JsonKey(name: "date")
    final String? date;
    @JsonKey(name: "data")
    final List<TheaterHallShowTime>? data;

    CinemaMovieShowTimeDetailResponseDatum({
        this.date,
        this.data,
    });

    factory CinemaMovieShowTimeDetailResponseDatum.fromJson(Map<String, dynamic> json) => _$CinemaMovieShowTimeDetailResponseDatumFromJson(json);

    Map<String?, dynamic> toJson() => _$CinemaMovieShowTimeDetailResponseDatumToJson(this);
}

@JsonSerializable()
class TheaterHallShowTime {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "theater_hall_id")
    final int? theaterHallId;
    @JsonKey(name: "theater_hall_name")
    final String? theaterHallName;
    @JsonKey(name: "start_time")
    final String? startTime;
    @JsonKey(name: "end_time")
    final String? endTime;

    TheaterHallShowTime({
        this.id,
        this.theaterHallId,
        this.theaterHallName,
        this.startTime,
        this.endTime,
    });

    factory TheaterHallShowTime.fromJson(Map<String, dynamic> json) => _$TheaterHallShowTimeFromJson(json);

    Map<String, dynamic> toJson() => _$TheaterHallShowTimeToJson(this);
}
