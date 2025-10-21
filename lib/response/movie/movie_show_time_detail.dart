import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'movie_show_time_detail.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class MovieShowTimeDetailResponse {
    @JsonKey(name: "id")
    int? id;
    @JsonKey(name: "startTime")
    String? startTime;
    @JsonKey(name: "endTime")
    String? endTime;
    @JsonKey(name: "status")
    int? status;
    @JsonKey(name: "movieId")
    int? movieId;
    @JsonKey(name: "movieName")
    String? movieName;
    @JsonKey(name: "moviePoster")
    dynamic moviePoster;
    @JsonKey(name: "cinemaId")
    int? cinemaId;
    @JsonKey(name: "cinemaName")
    String? cinemaName;
    @JsonKey(name: "theaterHallId")
    int? theaterHallId;
    @JsonKey(name: "theaterHallName")
    String? theaterHallName;
    @JsonKey(name: "selectedSeatCount")
    int? selectedSeatCount;
    @JsonKey(name: "subtitleId")
    List<int>? subtitleId;
    @JsonKey(name: "movieShowTimeTagsId")
    List<int>? movieShowTimeTagsId;
    @JsonKey(name: "subtitle")
    List<Subtitle>? subtitle;
    @JsonKey(name: "movieShowTimeTags")
    List<MovieShowTimeTag>? movieShowTimeTags;
    @JsonKey(name: "specId")
    int? specId;
    @JsonKey(name: "specName")
    String? specName;
    @JsonKey(name: "open")
    bool? open;
    @JsonKey(name: "theaterHallSpec")
    String? theaterHallSpec;
    @JsonKey(name: "seatCount")
    dynamic seatCount;

    MovieShowTimeDetailResponse({
        this.id,
        this.startTime,
        this.endTime,
        this.status,
        this.movieId,
        this.movieName,
        this.moviePoster,
        this.cinemaId,
        this.cinemaName,
        this.theaterHallId,
        this.theaterHallName,
        this.selectedSeatCount,
        this.subtitleId,
        this.movieShowTimeTagsId,
        this.subtitle,
        this.movieShowTimeTags,
        this.specId,
        this.specName,
        this.open,
        this.theaterHallSpec,
        this.seatCount,
    });

    factory MovieShowTimeDetailResponse.fromJson(Map<String, dynamic> json) => _$MovieShowTimeDetailResponseFromJson(json);

    Map<String, dynamic> toJson() => _$MovieShowTimeDetailResponseToJson(this);
}

@JsonSerializable()
class MovieShowTimeTag {
    @JsonKey(name: "id")
    int? id;
    @JsonKey(name: "name")
    String? name;

    MovieShowTimeTag({
        this.id,
        this.name,
    });

    factory MovieShowTimeTag.fromJson(Map<String, dynamic> json) => _$MovieShowTimeTagFromJson(json);

    Map<String, dynamic> toJson() => _$MovieShowTimeTagToJson(this);
}

@JsonSerializable()
class Subtitle {
    @JsonKey(name: "id")
    int? id;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "code")
    String? code;

    Subtitle({
        this.id,
        this.name,
        this.code,
    });

    factory Subtitle.fromJson(Map<String, dynamic> json) => _$SubtitleFromJson(json);

    Map<String, dynamic> toJson() => _$SubtitleToJson(this);
}
