import 'package:json_annotation/json_annotation.dart';

part 'show_time.g.dart';


@JsonSerializable()
class ShowTimeResponse {
    @JsonKey(name: "date")
    final String? date;
    @JsonKey(name: "data")
    final List<Cinema>? data;

    ShowTimeResponse({
        this.date,
        this.data,
    });

    factory ShowTimeResponse.fromJson(Map<String, dynamic> json) => _$ShowTimeResponseFromJson(json);

    Map<String, dynamic> toJson() => _$ShowTimeResponseToJson(this);
}

@JsonSerializable()
class Cinema {
    @JsonKey(name: "cinema_id")
    final int? cinemaId;
    @JsonKey(name: "cinema_name")
    final String? cinemaName;
    @JsonKey(name: "cinema_address")
    final String? cinemaAddress;
    @JsonKey(name: "time")
    final List<Time>? time;

    Cinema({
        this.cinemaId,
        this.cinemaName,
        this.cinemaAddress,
        this.time,
    });

    factory Cinema.fromJson(Map<String, dynamic> json) => _$CinemaFromJson(json);

    Map<String, dynamic> toJson() => _$CinemaToJson(this);
}

@JsonSerializable()
class Time {
    @JsonKey(name: "start_time")
    final DateTime? startTime;
    @JsonKey(name: "end_time")
    final DateTime? endTime;

    Time({
        this.startTime,
        this.endTime,
    });

    factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);

    Map<String, dynamic> toJson() => _$TimeToJson(this);
}
