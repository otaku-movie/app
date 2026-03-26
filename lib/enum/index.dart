enum SeatType {
  seat,
  aisle
}

enum AisleType {
  row,
  column
}
enum SelectSeatState {
  available(name: 'available', code: 1),
  selected(name: 'selected', code: 2),
  locked(name: 'locked', code: 3),
  sold(name: 'sold', code: 4);

  const SelectSeatState({required this.name, required this.code});

  final String name;
  final int code;
}

// enum SelectSeatState {
//   available(name: 'available', code: 1),


//   available = 1,  // 对应 1
//   selected = 2,   // 对应 2
//   locked = 3,     // 对应 3
//   sold = 4,       // 对应 4
// }

/// 后端订单状态码（与接口 orderState 字段一致）
class OrderStateCode {
  OrderStateCode._();
  static const int created = 1;
  static const int succeed = 2;
  static const int failed = 3;
  static const int canceledOrder = 4;
  static const int timeout = 5;
}

enum OrderState {
  // 订单已创建 1
  created,
  // 订单完成 2
  succeed,
  // 订单失败 3
  failed,
  // 取消订单 4
  canceledOrder,
  // 订单超时 5
  timeout;
}