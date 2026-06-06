/// 埋点事件名与参数键常量。
///
/// 约定（Firebase Analytics 限制）：
///   - 事件名 / 参数名：≤ 40 字符，只用 [a-z0-9_]，不能以数字开头；
///   - 单事件参数 ≤ 25 个；字符串值 ≤ 100 字符；
///   - 不要埋 PII（手机号 / 邮箱 / 卡号等）。
class Ev {
  // —— App 生命周期 / 账号 ——
  static const appOpen = 'app_open';
  static const splashShown = 'splash_shown';
  static const loginStart = 'login_start';
  static const loginSuccess = 'login_success';
  static const loginFail = 'login_fail';
  static const registerStart = 'register_start';
  static const registerSuccess = 'register_success';
  static const registerFail = 'register_fail';
  static const forgotPasswordSubmit = 'forgot_password_submit';
  static const logout = 'logout';

  // —— 浏览 / 发现 ——
  static const homeView = 'home_view';
  static const tabSwitch = 'tab_switch';
  static const movieListView = 'movie_list_view';
  static const nowShowingView = 'now_showing_view';
  static const comingSoonView = 'coming_soon_view';
  static const movieDetailView = 'movie_detail_view';
  static const movieDetailAction = 'movie_detail_action';
  static const cinemaListView = 'cinema_list_view';
  static const cinemaDetailView = 'cinema_detail_view';
  static const cinemaFavoriteToggle = 'cinema_favorite_toggle';
  static const search = 'search';
  static const searchResultClick = 'search_result_click';

  // —— ⭐ 购票转化漏斗（P0）——
  static const showtimeListView = 'showtime_list_view';
  static const showtimeDetailView = 'showtime_detail_view';
  static const showtimeClick = 'showtime_click';
  static const selectTicketView = 'select_ticket_view';
  static const ticketConfirm = 'ticket_confirm';
  static const selectSeatEnter = 'select_seat_enter';
  static const seatConfirm = 'seat_confirm';
  static const seatSelectFail = 'seat_select_fail';
  static const confirmOrderView = 'confirm_order_view';
  static const checkoutStart = 'checkout_start';
  static const paymentMethodView = 'payment_method_view';
  static const addCardView = 'add_card_view';
  static const addCardSuccess = 'add_card_success';
  static const addCardFail = 'add_card_fail';
  static const payStart = 'pay_start';
  static const paySuccess = 'pay_success';
  static const payFail = 'pay_fail';

  // —— 预售 / 特典 ——
  static const presaleDetailView = 'presale_detail_view';
  static const movieBenefitsView = 'movie_benefits_view';
  static const benefitCinemaView = 'benefit_cinema_view';

  // —— 订单 / 票 ——
  static const orderListView = 'order_list_view';
  static const orderDetailView = 'order_detail_view';
  static const ticketListView = 'ticket_list_view';

  // —— 评论 ——
  static const commentWriteStart = 'comment_write_start';
  static const commentSubmit = 'comment_submit';
  static const commentDetailView = 'comment_detail_view';

  // —— 错误 / 异常 ——
  static const apiError = 'api_error';
}

/// 事件参数键。
class P {
  static const movieId = 'movie_id';
  static const reReleaseId = 're_release_id';
  static const cinemaId = 'cinema_id';
  static const showtimeId = 'showtime_id';
  static const theaterHallId = 'theater_hall_id';
  static const orderNumber = 'order_number';
  static const amount = 'amount';
  static const seatCount = 'seat_count';
  static const ticketCount = 'ticket_count';
  static const date = 'date';
  static const keyword = 'keyword';
  static const resultCount = 'result_count';
  static const saleStatus = 'sale_status';
  static const reason = 'reason';
  static const tab = 'tab';
  static const type = 'type';
  static const presaleId = 'presale_id';
  static const benefitId = 'benefit_id';
  static const commentId = 'comment_id';
  static const score = 'score';
  static const orderState = 'order_state';

  // 购票漏斗串联 id（进入漏斗时生成，贯穿到支付完成）
  static const flowId = 'flow_id';

  // api_error 专用
  static const path = 'path';
  static const httpCode = 'http_code';
  static const bizCode = 'biz_code';
  static const latencyMs = 'latency_ms';
  static const method = 'method';
}
