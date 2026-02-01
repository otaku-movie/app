import 'package:json_annotation/json_annotation.dart';

part 'order_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class OrderDetailResponse {
    
    final int? id;
    
    /// 订单号（用于请求详情、取消等接口）
    final String? orderNumber;
    
    final int? orderTotal;
    
    final int? orderState;
    
    final String? payMethod;
    
    final int? payNumber;
    
    final int? payState;
    
    final int? payTotal;
    
    final String? orderTime;
    
    final String? payTime;
    
    final String? date;
    
    final String? startTime;
    
    final String? endTime;
    
    final int? status;
    
    final int? movieId;
    
    final String? movieName;
    
    final String? moviePoster;
    
    final dynamic cinemaId;
    
    final String? cinemaName;

    final String? cinemaFullAddress;
    final String? theaterHallName;
    
    /// 规格名称（单个，兼容旧接口）
    final String? specName;
    
    /// 规格名称列表（多个）
    final List<String>? specNames;
    
    /// 放映类型：1=2D，2=3D
    final int? dimensionType;
    
    /// 支付截止时间（订单创建时间 + 支付超时时间），用于前端倒计时显示。格式如 yyyy-MM-dd HH:mm:ss 或 ISO8601
    final String? payDeadline;

    /// 订单失败/取消/超时原因，仅失败/取消/超时时有值
    final String? failureReason;

    final List<Seat>? seat;

    OrderDetailResponse({
        this.id,
        this.orderNumber,
        this.orderTotal,
        this.orderState,
        this.payMethod,
        this.payNumber,
        this.payState,
        this.payTotal,
        this.orderTime,
        this.payTime,
        this.date,
        this.startTime,
        this.endTime,
        this.status,
        this.movieId,
        this.movieName,
        this.moviePoster,
        this.cinemaId,
        this.cinemaName,
        this.cinemaFullAddress,
        this.theaterHallName,
        this.specName,
        this.specNames,
        this.dimensionType,
        this.payDeadline,
        this.failureReason,
        this.seat,
    });

    factory OrderDetailResponse.fromJson(Map<String, dynamic> json) => _$OrderDetailResponseFromJson(json);

    Map<String, dynamic> toJson() => _$OrderDetailResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class Seat {
    
    final int? seatX;
    
    final int? seatY;
    
    final String? seatName;
    
    final String? movieTicketTypeName;

    Seat({
        this.seatX,
        this.seatY,
        this.seatName,
        this.movieTicketTypeName,
    });

    factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

    Map<String, dynamic> toJson() => _$SeatToJson(this);
}
