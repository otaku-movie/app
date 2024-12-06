enum SeatType {
  seat,
  aisle
}

enum AisleType {
  row,
  column
}

enum SelectSeatState {
  // 1
  available,
  // 2
  selected,
  // 3
  locked,
  // 4
  sold
}

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