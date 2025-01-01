import 'package:json_annotation/json_annotation.dart';

import 'package:otaku_movie/enum/index.dart';

part 'theater_seat.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class TheaterSeat {
    
    final int? maxSelectSeatCount;
    
    final List<Seat>? seat;
    
    final List<Aisle>? aisle;
    
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

@JsonSerializable(fieldRename: FieldRename.none)
class Aisle {
    
    final int? theaterHallId;
    
    final AisleType? type;
    
    final int? start;
    
    final DateTime? createTime;
    
    final DateTime? updateTime;
    
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

@JsonSerializable(fieldRename: FieldRename.none)
class AreaElement {
    
    final int? id;
    
    final int? theaterHallId;
    
    final String? name;
    
    final String? color;
    
    final int? price;
    
    final DateTime? createTime;
    
    final DateTime? updateTime;
    
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



@JsonSerializable(fieldRename: FieldRename.none)
class Seat {
    
    final SeatType? type;
    
    final int? rowAxis;
    
    final String? rowName;
    
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

@JsonSerializable(fieldRename: FieldRename.none)
class SeatItem {
    
    final SeatType? type;

    
    final int? id;
    
    final int? theaterHallId;
    
    final String? rowName;
    
    final String? seatName;
    
    final int x;
    
    final int y;
    
    final dynamic z;
    
    final bool selected;
    
    final bool? show;
    
    final bool disabled;
    
    final bool? wheelChair;
    
    final String? seatPositionGroup;
    
    final SeatArea? area;
    
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

@JsonSerializable(fieldRename: FieldRename.none)
class SeatArea {
    
    final int? id;
    
    final String? name;
    
    final int? price;
    
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
