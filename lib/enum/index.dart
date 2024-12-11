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

enum OrderState {
  // 订单已创建 1
  created,
  // 订单完成 2
  succeed,
  // 订单失败 4
  failed,
  // 取消订单 4
  canceledOrder,
  // 订单超时 5
  timeout;
}