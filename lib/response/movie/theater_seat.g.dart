// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theater_seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TheaterSeat _$TheaterSeatFromJson(Map<String, dynamic> json) => TheaterSeat(
      maxSelectSeatCount: (json['maxSelectSeatCount'] as num?)?.toInt(),
      seat: (json['seat'] as List<dynamic>?)
          ?.map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList(),
      aisle: (json['aisle'] as List<dynamic>?)
          ?.map((e) => Aisle.fromJson(e as Map<String, dynamic>))
          .toList(),
      area: (json['area'] as List<dynamic>?)
          ?.map((e) => AreaElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TheaterSeatToJson(TheaterSeat instance) =>
    <String, dynamic>{
      'maxSelectSeatCount': instance.maxSelectSeatCount,
      'seat': instance.seat?.map((e) => e.toJson()).toList(),
      'aisle': instance.aisle?.map((e) => e.toJson()).toList(),
      'area': instance.area?.map((e) => e.toJson()).toList(),
    };

Aisle _$AisleFromJson(Map<String, dynamic> json) => Aisle(
      theaterHallId: (json['theaterHallId'] as num?)?.toInt(),
      type: $enumDecodeNullable(_$AisleTypeEnumMap, json['type']),
      start: (json['start'] as num?)?.toInt(),
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
      deleted: (json['deleted'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AisleToJson(Aisle instance) => <String, dynamic>{
      'theaterHallId': instance.theaterHallId,
      'type': _$AisleTypeEnumMap[instance.type],
      'start': instance.start,
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
      'deleted': instance.deleted,
    };

const _$AisleTypeEnumMap = {
  AisleType.row: 'row',
  AisleType.column: 'column',
};

AreaElement _$AreaElementFromJson(Map<String, dynamic> json) => AreaElement(
      id: (json['id'] as num?)?.toInt(),
      theaterHallId: (json['theaterHallId'] as num?)?.toInt(),
      name: json['name'] as String?,
      color: json['color'] as String?,
      price: (json['price'] as num?)?.toInt(),
      createTime: json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      updateTime: json['updateTime'] == null
          ? null
          : DateTime.parse(json['updateTime'] as String),
      deleted: (json['deleted'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AreaElementToJson(AreaElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'theaterHallId': instance.theaterHallId,
      'name': instance.name,
      'color': instance.color,
      'price': instance.price,
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
      'deleted': instance.deleted,
    };

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      rowAxis: (json['rowAxis'] as num?)?.toInt(),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => SeatItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: $enumDecodeNullable(_$SeatTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'type': _$SeatTypeEnumMap[instance.type],
      'rowAxis': instance.rowAxis,
      'children': instance.children?.map((e) => e.toJson()).toList(),
    };

const _$SeatTypeEnumMap = {
  SeatType.seat: 'seat',
  SeatType.aisle: 'aisle',
};

SeatItem _$SeatItemFromJson(Map<String, dynamic> json) => SeatItem(
      type: $enumDecodeNullable(_$SeatTypeEnumMap, json['type']),
      id: (json['id'] as num?)?.toInt(),
      theaterHallId: (json['theater_hall_id'] as num?)?.toInt(),
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
      z: json['z'],
      selected: json['selected'],
      show: json['show'] as bool?,
      disabled: json['disabled'] as bool?,
      wheelChair: json['wheel_chair'] as bool?,
      seatPositionGroup: json['seat_position_group'] as String?,
      area: json['area'] == null
          ? null
          : SeatArea.fromJson(json['area'] as Map<String, dynamic>),
      selectSeatState: $enumDecodeNullable(
              _$SelectSeatStateEnumMap, json['select_seat_state']) ??
          SelectSeatState.available,
    );

Map<String, dynamic> _$SeatItemToJson(SeatItem instance) => <String, dynamic>{
      'type': _$SeatTypeEnumMap[instance.type],
      'id': instance.id,
      'theater_hall_id': instance.theaterHallId,
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
      'selected': instance.selected,
      'show': instance.show,
      'disabled': instance.disabled,
      'wheel_chair': instance.wheelChair,
      'seat_position_group': instance.seatPositionGroup,
      'area': instance.area?.toJson(),
      'select_seat_state': _$SelectSeatStateEnumMap[instance.selectSeatState],
    };

const _$SelectSeatStateEnumMap = {
  SelectSeatState.available: 'available',
  SelectSeatState.locked: 'locked',
  SelectSeatState.sold: 'sold',
};

SeatArea _$SeatAreaFromJson(Map<String, dynamic> json) => SeatArea(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      price: (json['price'] as num?)?.toInt(),
      color: json['color'] as String?,
    );

Map<String, dynamic> _$SeatAreaToJson(SeatArea instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'color': instance.color,
    };
