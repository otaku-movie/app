# Git Commit 变更总结

**说明**：仅包含**有实际内容变更**的文件（`git diff --name-only`）。仅换行符变更的文件不列入。**所有变更一个 commit 提交。**

## 变更统计
- **有内容变更的文件**: 73 个（以 `git diff --name-only` 为准）
- **未计入**: 仅换行符变更的文件（如 myApp、LanguageController、FilterBar、CustomAppBar、date_format_util 等）

## 本次有内容变更的文件清单
运行 `git diff --name-only` 查看完整列表。概览：
- `lib/api/index.dart`
- `lib/components/`: HelloMovie, customExtendedImage, rate, sendVerifyCode
- `lib/controller/`: SeatSelectionController
- `lib/enum/index.dart`，`lib/log/index.dart`
- `lib/generated/`: l10n.dart, intl/messages_*.dart
- `lib/l10n/`: intl_*.arb, app_localizations*.dart, translations.json
- `lib/pages/`: Home, about, cinema/cinemaDetail, movie/*, order/*, payment/*, tab/*, user/*
- `lib/response/`: cinema/cinemaList, hello_movie, movie/*, order/*, payment/*, ticket/*, response.dart
- `lib/router/router.dart`
- `lib/utils/`: index, seat_cancel_manager

---

## 按模块分类的变更详情（供 commit 正文参考）

### API
- `lib/api/index.dart`：Accept-Language 等

### 页面
- **NowShowing**：loading/error/空状态、重试
- **movieDetail**：loading/error、AppErrorWidget、重试
- **ShowTimeList**：时间范围筛选、30 小时制、交互与布局、规格+2D/3D 合并等
- **ShowTimeDetail**：版本信息样式
- **SelectSeatPage**：选座返回逻辑、未支付订单弹窗 UI
- **SelectMovieTicket**：返回逻辑、规格+2D/3D 合并、价格展示等
- **confirmOrder**：规格+2D/3D 合并等
- **paySuccess**：查看我的票跳转 ticketList、规格+2D/3D 合并
- **payError**：AppErrorWidget、UI 优化、返回/右滑回选座、l10n
- **orderDetail**：id→orderNumber、规格+2D/3D 合并
- **orderList**：跳转传 orderNumber
- **Ticket**：跳转传 orderNumber、规格+dimensionType 合并
- 其他 pages：Home, about, cinemaDetail, commentDetail, writeComment, payment/*, user/*, tab/* 等

### 组件 / 控制器 / 工具
- HelloMovie, customExtendedImage, rate, sendVerifyCode
- SeatSelectionController
- utils/index, seat_cancel_manager（orderNumber、cancel 等）

### 响应模型
- show_time, theater_seat, user_select_seat_data_response
- order_detail_response（orderNumber、failureReason 等）
- ticket_detail_response（orderNumber）
- payment/credit_card_response, response.dart
- cinema/cinemaList, hello_movie, movieList/movie

### 路由
- router：订单详情 orderNumber 等

### 国际化
- intl_*.arb, translations.json, app_localizations*, generated（payError、orderDetail 等文案与业务一起）

---

## 建议：所有变更一个 commit

**涉及文件**：所有有内容变更的文件（`git diff --name-only` 列出的全部）

**Commit 信息示例**：

```
refactor: 订单选座支付与场次展示等重构

- 订单：orderId→orderNumber，订单详情/列表/我的票/路由/取消订单统一
- 选座/选票：新增用户已选座位，如果右滑动离开选座界面，就直接取消选座
- 支付失败：AppErrorWidget、UI 优化、返回/右滑的时候跳转到选座
- 场次/规格：新增2d/3d展示和条件筛选
- 支付成功：支付成功后跳转到我的票界面
```

---

## 提交命令

```bash
# 只 add 有内容变更的文件（与 git diff --name-only 一致）
git add $(git diff --name-only)

# 或先检查再 add
git diff --name-only
git add lib/api/index.dart lib/components/HelloMovie.dart lib/components/customExtendedImage.dart lib/components/rate.dart lib/components/sendVerifyCode.dart lib/controller/SeatSelectionController.dart lib/enum/index.dart lib/generated/intl/messages_en.dart lib/generated/intl/messages_ja.dart lib/generated/intl/messages_zh.dart lib/generated/l10n.dart lib/l10n/app_localizations.dart lib/l10n/app_localizations_en.dart lib/l10n/app_localizations_ja.dart lib/l10n/app_localizations_zh.dart lib/l10n/intl_en.arb lib/l10n/intl_ja.arb lib/l10n/intl_zh.arb lib/l10n/translations.json lib/log/index.dart lib/pages/about.dart lib/pages/cinema/cinemaDetail.dart lib/pages/Home.dart lib/pages/movie/commentDetail.dart lib/pages/movie/confirmOrder.dart lib/pages/movie/movieDetail.dart lib/pages/movie/payError.dart lib/pages/movie/paySuccess.dart lib/pages/movie/SelectMovieTicket.dart lib/pages/movie/SelectSeatPage.dart lib/pages/movie/ShowTimeDetail.dart lib/pages/movie/ShowTimeList.dart lib/pages/movie/writeComment.dart lib/pages/order/orderDetail.dart lib/pages/order/orderList.dart lib/pages/payment/AddCreditCard.dart lib/pages/payment/SelectCreditCard.dart lib/pages/search.dart lib/pages/tab/CinemaList.dart lib/pages/tab/comingSoon.dart lib/pages/tab/MovieList.dart lib/pages/tab/NowShowing.dart lib/pages/tab/Ticket.dart lib/pages/user/forgotPassword.dart lib/pages/user/login.dart lib/pages/user/profile.dart lib/pages/user/register.dart lib/pages/user/User.dart lib/response/cinema/cinemaList.dart lib/response/hello_movie.dart lib/response/movie/movieList/movie.dart lib/response/movie/show_time.dart lib/response/movie/show_time.g.dart lib/response/movie/theater_seat.dart lib/response/movie/theater_seat.g.dart lib/response/movie/user_select_seat_data_response.dart lib/response/movie/user_select_seat_data_response.g.dart lib/response/order/order_detail_response.dart lib/response/order/order_detail_response.g.dart lib/response/payment/credit_card_response.dart lib/response/payment/credit_card_response.g.dart lib/response/response.dart lib/response/ticket/ticket_detail_response.dart lib/response/ticket/ticket_detail_response.g.dart lib/router/router.dart lib/utils/index.dart lib/utils/seat_cancel_manager.dart

git commit -m "refactor: 订单选座支付与场次展示等重构

- 订单：orderId→orderNumber，订单详情/列表/我的票/路由/取消订单统一
- 选座/选票：新增用户已选座位，如果右滑动离开选座界面，就直接取消选座
- 支付失败：AppErrorWidget、UI 优化、返回/右滑的时候跳转到选座
- 场次/规格：新增2d/3d展示和条件筛选
- 支付成功：支付成功后跳转到我的票界面"
```

（若使用 `git add $(git diff --name-only)` 需在 bash 环境；Windows 下可先 `git diff --name-only > files.txt` 再按列表 add。）
