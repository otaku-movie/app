import 'package:json_annotation/json_annotation.dart';

part 'show_time.g.dart';


@JsonSerializable(fieldRename: FieldRename.none)
class ShowTimeResponse {
    
    final String? date;
    
    final List<Cinema>? data;

    ShowTimeResponse({
        this.date,
        this.data,
    });

    factory ShowTimeResponse.fromJson(Map<String, dynamic> json) => _$ShowTimeResponseFromJson(json);

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
    
    double? distance;

    Cinema({
        this.cinemaId,
        this.cinemaName,
        this.cinemaAddress,
        this.showTimes,
        this.cinemaLatitude,
        this.cinemaLongitude,
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
    @JsonKey(name: "specName")
    String? specName;
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

    ShowTime({
        this.id,
        this.theaterHallId,
        this.theaterHallName,
        this.startTime,
        this.endTime,
        this.specName,
        this.totalSeats,
        this.selectedSeats,
        this.availableSeats,
        this.subtitleId,
        this.showTimeTagId,
        this.subtitle,
        this.showTimeTags,
    });

    factory ShowTime.fromJson(Map<String, dynamic> json) => _$ShowTimeFromJson(json);

    Map<String, dynamic> toJson() => _$ShowTimeToJson(this);
}