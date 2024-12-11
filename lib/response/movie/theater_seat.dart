import 'package:json_annotation/json_annotation.dart';

import 'package:otaku_movie/enum/index.dart';

part 'theater_seat.g.dart';

@JsonSerializable()
class TheaterSeat {
    @JsonKey(name: "maxSelectSeatCount")
    final int? maxSelectSeatCount;
    @JsonKey(name: "seat")
    final List<Seat>? seat;
    @JsonKey(name: "aisle")
    final List<Aisle>? aisle;
    @JsonKey(name: "area")
    final List<AreaElement>? area;

    TheaterSeat({
        this.maxSelectSeatCount,
        this.seat,
        this.aisle,
        this.area,
    });

    factory TheaterSeat.fromJson(Map<String, dynamic> json) => _$TheaterSeatFromJson(json);

    Map<String, dynamic> toJson() => _$TheaterSeatToJson(this);
}

@JsonSerializable()
class Aisle {
    @JsonKey(name: "theaterHallId")
    final int? theaterHallId;
    @JsonKey(name: "type")
    final AisleType? type;
    @JsonKey(name: "start")
    final int? start;
    @JsonKey(name: "createTime")
    final DateTime? createTime;
    @JsonKey(name: "updateTime")
    final DateTime? updateTime;
    @JsonKey(name: "deleted")
    final int? deleted;

    Aisle({
        this.theaterHallId,
        this.type,
        this.start,
        this.createTime,
        this.updateTime,
        this.deleted,
    });

    factory Aisle.fromJson(Map<String, dynamic> json) => _$AisleFromJson(json);

    Map<String, dynamic> toJson() => _$AisleToJson(this);
}

@JsonSerializable()
class AreaElement {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "theaterHallId")
    final int? theaterHallId;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "color")
    final String? color;
    @JsonKey(name: "price")
    final int? price;
    @JsonKey(name: "createTime")
    final DateTime? createTime;
    @JsonKey(name: "updateTime")
    final DateTime? updateTime;
    @JsonKey(name: "deleted")
    final int? deleted;

    AreaElement({
        this.id,
        this.theaterHallId,
        this.name,
        this.color,
        this.price,
        this.createTime,
        this.updateTime,
        this.deleted,
    });

    factory AreaElement.fromJson(Map<String, dynamic> json) => _$AreaElementFromJson(json);

    Map<String, dynamic> toJson() => _$AreaElementToJson(this);
}



@JsonSerializable()
class Seat {
    @JsonKey(name: "type")
    final SeatType? type;
    @JsonKey(name: "rowAxis")
    final int? rowAxis;
    @JsonKey(name: "rowName")
    final String? rowName;
    @JsonKey(name: "children")
    final List<SeatItem>? children;

    Seat({
        this.rowAxis,
        this.rowName,
        this.children, 
        this.type,
    });

    factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

    Map<String, dynamic> toJson() => _$SeatToJson(this);
}

@JsonSerializable()
class SeatItem {
    @JsonKey(name: "type")
    final SeatType? type;

    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "theater_hall_id")
    final int? theaterHallId;
    @JsonKey(name: "row_name")
    final String? rowName;
    @JsonKey(name: "seat_name")
    final String? seatName;
    @JsonKey(name: "x")
    final int x;
    @JsonKey(name: "y")
    final int y;
    @JsonKey(name: "z")
    final dynamic z;
    @JsonKey(name: "selected")
    final bool selected;
    @JsonKey(name: "show")
    final bool? show;
    @JsonKey(name: "disabled")
    final bool disabled;
    @JsonKey(name: "wheel_chair")
    final bool? wheelChair;
    @JsonKey(name: "seat_position_group")
    final String? seatPositionGroup;
    @JsonKey(name: "area")
    final SeatArea? area;
    @JsonKey(name: "select_seat_state")
    final int? selectSeatState;

    SeatItem({
        this.type,
        this.id,
        this.theaterHallId,
        this.rowName,
        this.seatName,
        this.x = 0,
        this.y = 0,
        this.z,
        this.selected = false,
        this.show,
        this.disabled = false,
        this.wheelChair,
        this.seatPositionGroup,
        this.area,
        this.selectSeatState = 1,
    });

    factory SeatItem.fromJson(Map<String, dynamic> json) => _$SeatItemFromJson(json);

    Map<String, dynamic> toJson() => _$SeatItemToJson(this);
}

@JsonSerializable()
class SeatArea {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "price")
    final int? price;
    @JsonKey(name: "color")
    final String? color;

    SeatArea({
        this.id,
        this.name,
        this.price,
        this.color,
    });

    factory SeatArea.fromJson(Map<String, dynamic> json) => _$SeatAreaFromJson(json);

    Map<String, dynamic> toJson() => _$SeatAreaToJson(this);
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
