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

@JsonSerializable(fieldRename: FieldRename.none)
class Time {
    
    final DateTime? startTime;
    
    final DateTime? endTime;

    Time({
        this.startTime,
        this.endTime,
    });

    factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);

    Map<String, dynamic> toJson() => _$TimeToJson(this);
}
