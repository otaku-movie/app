# DESIGN.md — Otaku Movie（App 端）

> **Otaku Movie** Flutter app 的纯文本设计系统。把本文件放在项目根目录后，任意 AI 编码 Agent / Google Stitch 都能据此生成与现有产品视觉一致的 UI。
>
> **生效范围**：`app/`（Flutter，面向 C 端用户）。`admin/`（Next.js + Ant Design）沿用 Ant Design 默认主题，**不受本文件约束**。
>
> **约定**：app 端使用 `flutter_screenutil`，设计稿基准为 **750 × 1334**。下文所有数值均为设计稿 px，代码中需带后缀 `.w` / `.h` / `.sp` / `.r`。颜色以 Flutter `Color(0xFFRRGGBB)` 形式给出。

---

## 1. 视觉主题与氛围

- **气质**：明亮、亲和，面向 C 端的电影票务 App。蓝色主色传递信任感，再用一组暖色/分类色支撑「票券、评分、优惠」等场景。
- **表面（Surface）哲学**：浅色画布 `#F7F8FA` 上漂浮一组白色卡片，整体采用 16~24r 的大圆角 + 多层投影，呈现「电影票」般的实体质感。
- **密度**：中等。可点击目标普遍 `80.h`，左右页边距 `24.w`，纵向节奏 `16–24.h`。
- **层级手段**：颜色 + 投影。主操作 = 蓝色渐变胶囊 + 蓝光阴影；中性内容 = 白卡 / 灰底；信息态 = 主色的 `alpha 0.05 ~ 0.15` 软底。
- **暗色模式**：暂不支持，全部页面为浅色。唯一的深色表面是 `#000000`，专门用于 Apple / X 第三方登录按钮。

---

## 2. 颜色调色板与角色

### 2.1 品牌色 / 主色

| Token | Hex | 角色 |
|---|---|---|
| `brand.primary` | `#1989FA` | 默认品牌色。AppBar 背景、主 CTA、链接、聚焦边框、选中态。 |
| `brand.primaryGradientEnd` | `#069EF0` | 主渐变的浅色端，组成 `#1989FA → #069EF0` 标准蓝渐变。 |
| `brand.primaryDeep` | `#0E6FD8` | 在数据密集的场次卡片上用作深色端，与主色组渐变。 |
| `brand.primarySoft.05` | `#1989FA @ 5%` | Hero 区域大面积底色洗。 |
| `brand.primarySoft.10` | `#1989FA @ 10%` | 图标方块底、Tag 底、悬停洗色。 |
| `brand.primarySoft.12` | `#1989FA @ 12%` | "选中"胶囊底。 |
| `brand.primarySoft.30` | `#1989FA @ 30%` | 描边 / 聚焦环 / 发光阴影。 |

### 2.2 状态色 / 分类色

| Token | Hex | 角色 |
|---|---|---|
| `accent.warning` | `#FFA500` | 警示、库存紧张、次级强调。 |
| `accent.warningSoft` | `#FFA500 @ 10%` | 警示 Tag 底色。 |
| `accent.premium` | `#FFD700` | 评分星 / 高级身份，与 `#FFA500` 组渐变。 |
| `accent.danger` | `#FF6B6B` | 热门、特价、错误。 |
| `accent.dangerDeep` | `#EE5A6F` | 与 `accent.danger` 配合的深端。 |
| `accent.purple` | `#7232DD` | 次级分类标签（如非主流场次）。 |
| `accent.purpleSoft.12` | `#7232DD @ 12%` | 紫色 Tag 底。 |
| `accent.ticket` | `#667EEA` | 票券 / 钱包区域的靛蓝（刻意区别于主色）。 |

### 2.3 中性色 / 表面色

| Token | Hex | 角色 |
|---|---|---|
| `surface.canvas` | `#F7F8FA` | Scaffold 背景；同时用作输入框 `fillColor`。 |
| `surface.card` | `#FFFFFF` | 卡片、Dialog、Modal 背景。 |
| `surface.invert` | `#000000` | Apple / X 登录胶囊背景。 |
| `surface.dropdown` | `#323233` | 蓝色 AppBar 上的下拉菜单深色面。 |
| `text.primary` | `#323233` | 正文与标题。 |
| `text.secondary` | `#4A4A4A` | 长文段（协议表格正文）。 |
| `text.tertiary` | `#969799` | 占位、辅助说明、"or" 分割文字。 |
| `border.default` | `#E6E6E6` | 卡片描边、分割线。 |
| `border.subtle` | `#EEF0F3` | Markdown 横线。 |
| `border.table.outer` | `#E4E7EC` | 数据表外框。 |
| `border.table.inner` | `#F0F2F5` | 数据表内分隔线。 |
| `border.table.header` | `#DDE3EB` | 表头下方加重分割线。 |
| `surface.code` | `#F2F4F7` | 行内 `code` 胶囊底色。 |
| `surface.quote` | `#E8F4FF` | Markdown blockquote 底色。 |

> **硬性规定**：新增任何强调色，**必须先**在本节登记，然后再在组件里使用。禁止在 Widget 里临时写 hex。

---

## 3. 字体规则

### 3.1 字体家族

| 家族 | 来源 | 用法 |
|---|---|---|
| **系统默认** | iOS SF / Android Roboto / 中日韩字体回退 | 所有 CJK / 英文正文与标题。 |
| **Poppins** | 当前在 `confirmOrder.dart` 等处引用，但 `pubspec.yaml` 还**未注册**（上线前必须补） | 拉丁数字、金额、订单号、票号（`letterSpacing: 2`）。 |
| **iconfont** | `assets/icons/iconfont.ttf` | 自有图标字形。 |
| **monospace** | 平台默认 | 协议页 Markdown 中的行内 `code`。 |

### 3.2 字号梯度（`.sp`，750 设计稿）

| Token | 字号 | 字重 | 出现位置 |
|---|---|---|---|
| `display` | `40.sp` | w700 / bold | 协议 Markdown 中的 H1。 |
| `title.lg` | `36.sp` | w700 | 卡片大标题（如"登录"）、大号数字。 |
| `title.md` | `32.sp` | w600 | AppBar 标题、H3、主按钮文字。 |
| `title.sm` | `30.sp` | w600 | Markdown 中的 H4。 |
| `body.lg` | `28.sp` | w500 / w600 | 卡片正文、按钮文字、表格 / 协议段落（行高 1.7）。 |
| `body.md` | `24.sp` | w400 / w600 | 表单 label、菜单项、"忘记密码"、"还没账号"。 |
| `body.sm` | `22.sp` | w400 | 表格内容、说明文字。 |
| `caption` | `20.sp` | w400 / bold | 行内 code、小 Tag、icon 配文。 |
| `tiny` | `18.sp` | bold | 备用（如改造前 Google "G" 字母叠加层）。 |

### 3.3 行高与字距

- 协议正文段落：`height: 1.7`。
- 表格单元格段落：`height: 2.1`（更松，方便扫读）。
- 拉丁数字（Poppins）：`letterSpacing: 2`，用于票号 / 订单号。
- 标题段：`height: 1.3`。

---

## 4. 组件样式

### 4.1 按钮

#### 主操作 —— 渐变胶囊按钮

- 高度：`80.h`。
- 背景：`LinearGradient([#1989FA, #069EF0])`，`centerLeft → centerRight`。
- 圆角：`16.r`。
- 阴影：`#1989FA @ 30%`，blur `12`，offset `(0, 6)` —— 标志性的蓝光。
- 内容：前置 Material icon（白色 `32.sp`）+ `12.w` 间隔 + 文字 `28.sp` w600 白。
- 点击层：包一层 `Material(transparent) → InkWell(borderRadius: 16.r)`。

#### 次级 / 第三级胶囊（如"忘记密码"）

- 背景：`LinearGradient([#1989FA @ 10%, #069EF0 @ 10%])`，左→右。
- 边框：`1px solid #1989FA @ 30%`。
- 圆角：`25.r`（全圆胶囊）。
- 内边距：`32.w × 16.h`。
- 阴影：`#1989FA @ 10%`，blur `8`，offset `(0, 2)`。
- 文字：`#1989FA`，`24.sp` w600。

#### 第三方登录按钮

- 共性：`height: 80.h`，`radius: 16.r`，软阴影 `Black @ 5–8%`，blur `8`，offset `(0, 2)`。
- **Google**：表面 `#FFFFFF`，`1px #E6E6E6` 描边，**必须**使用官方 `assets/icons/social/google.svg`（`36.w`）。文字 `#323233` w500。
- **Apple**：表面 `#000000`，`assets/icons/social/apple.svg`（`32.w`）。文字白色 w600。
- **X (Twitter)**：表面 `#000000`，`assets/icons/social/x.svg`（`28.w`）。文字白色 w600。
- 严禁用 Material `Icons.apple`、Unicode 字符 `𝕏`、或手搓的渐变 G 字母替代品牌 SVG。

### 4.2 输入框（`TextField`）

- 外层阴影：`Black @ 5%`，blur `8`，offset `(0, 2)`。
- 填充色：`#F7F8FA`；圆角 `16.r`；**默认无描边**（`BorderSide.none`）。
- 聚焦描边：`2px #1989FA`，圆角 `16.r`。
- Label：`#969799`，`24.sp`。
- 输入文字：`#323233`，`28.sp`。
- 前置图标：包在 `margin 12.w` + `padding 10.w` 的方块里，背景 `#1989FA @ 10%`，圆角 `8.r`；图标本体 `28.sp` `#1989FA`。
- 内容内边距：`20.w × 20.h`。

### 4.3 卡片

- 背景：`#FFFFFF`。
- 圆角：Hero/表单卡 `24.r`；列表卡 `16.r`。
- 内边距：表单 `32.w`；紧凑列表 `16.w`。
- 阴影组合：
  - 表单 / Hero 卡：`Black @ 8%`，blur `20`，offset `(0, 8)`。
  - 列表卡：`Black @ 5–8%`，blur `8–12`，offset `(0, 2)–(0, 4)`。

### 4.4 Tag / Chip

- 标准样式：着色胶囊 —— 背景 `<accent> @ 10–12%`，可选 `1px <accent> @ 30%` 描边，圆角 `8.r`，内边距 `8.w × 4.h`。
- 示例：
  - 主色 Chip：`#1989FA @ 12%` 底 + `#1989FA @ 30%` 边 + `#1989FA` 字。
  - 紫色 Chip：`#7232DD @ 12%` 底 + `#7232DD @ 30%` 边 + `#7232DD` 字。
  - 警示 Chip：`#FFA500 @ 10%` 底 + `#FFA500` 字（无边）。

### 4.5 分割线

- 极细线：`1.h × #E6E6E6`。
- 带文字的分隔（如"or"）：线 + `16.w` 间距 + `#969799 24.sp` 文字 + 线。

### 4.6 AppBar

- 背景 `#1989FA`。
- 标题 `32.sp` 白色 w600。
- 可选左侧品牌图标：圆角方块 `padding 6.w`，底 `white @ 20%`，圆角 `8.r`，内置白色 `Icons.movie`。
- 右侧操作区：白色图标 + 下拉菜单使用 `#323233` 深色面。

### 4.7 Markdown（协议 / 政策类长文）

- 背景：纯白。
- 段落：`28.sp` `#323233`，`height 1.7`。
- 标题上下内边距：`8/14`、`28/14`、`22/10`、`18/8`。
- Blockquote：`#E8F4FF` 底，圆角 `8.r`，内边距 `18.w`。
- 行内 `code`：底 `#F2F4F7`，圆角 `6.r`，内边距 `6 × 2`，等宽字体，`#323233`。
- 表格：外圆角 `10.r`，外框 `#E4E7EC 1px`，内框 `#F0F2F5 1px`，表头底 `#F7F8FA` 配 `#DDE3EB` 下分割线；表头字 w600 `#323233`，正文字 `#4A4A4A`；列数 > 3 时水平滚动；列宽夹取 `120.w ~ 190.w`。
- 空单元格占位：`—`，`22.sp`，灰 500。

### 4.8 Dialog / Loading

- 加载弹窗：全屏、透明背景，居中白色 `CircularProgressIndicator`，`barrierDismissible: false`。
- 错误提示一律走 `ToastService.showError(...)` —— **不要**直接弹原生 `SnackBar` 或 `Dialog`。

---

## 5. 布局原则

### 5.1 间距尺度（`.w` / `.h`）

`4 · 8 · 12 · 16 · 20 · 24 · 32 · 40`

超出该尺度即为 code smell。

### 5.2 页面节奏

- 左右页边距：`24.w`。
- 页顶到首个 Hero 元素：`40.h`。
- 卡内分节间距：`24.h → 32.h → 40.h`（强调度递增）。
- 同行元素间隙（icon ↔ label）：`8.w`（紧凑）/ `12.w`（默认）/ `16.w`（宽松）。

### 5.3 圆角尺度（`.r`）

`4 · 6 · 8 · 10 · 12 · 16 · 24 · 25`，其中 `25.r` 专用于全圆胶囊按钮。

### 5.4 栅格

- 移动端单列布局，无正式栅格。需要分配宽度时用 `Expanded` / `Flex`。
- Markdown 表格：`FixedColumnWidth` + 内容溢出时水平滚动。

---

## 6. 深度与层级（阴影）

三档常规阴影 + 两档品牌发光阴影。

| 等级 | 颜色 | blur | offset | 用途 |
|---|---|---|---|---|
| `E1 / 极细影` | `Black @ 5%` | `8` | `(0, 2)` | 输入框外层、列表卡、社交登录按钮。 |
| `E2 / 软影` | `Black @ 8%` | `12` | `(0, 4)` | 品牌图标方块、中等突出的卡片。 |
| `E3 / 提升影` | `Black @ 8%` | `20` | `(0, 8)` | 表单 / Hero 卡。 |
| `Eglow / 主光晕` | `#1989FA @ 30%` | `12` | `(0, 6)` | 主 CTA。 |
| `Eglow.soft` | `#1989FA @ 10%` | `8` | `(0, 2)` | 第三级胶囊、强调 Chip。 |

> 单个元素最多叠 **2** 层阴影。需要更强的层级感时，请优先用更亮的背景着色而不是再加一层投影。

---

## 7. Do / Don't

**Do**
- 主色只用 `Color(0xFF1989FA)`。需要强调时配合 `#1989FA → #069EF0` 渐变。
- 所有面向用户的字符串都走 `S.of(context).xxx`，禁止裸写中文 / 日文 / 英文（仅 `agreement_service.dart` 中作为兜底数据的 Markdown blob 例外）。
- 所有尺寸数值都通过 `flutter_screenutil`（`.w` / `.h` / `.sp` / `.r`）。Widget 代码里不应出现 `16.0` 之类的裸 `double`。
- Google / Apple / X 品牌一律使用 `SvgPicture.asset('assets/icons/social/*.svg')`，遵守各家的安全间距和颜色规则。
- 临时反馈一律走 `ToastService.showError / showSuccess`。
- 第三方登录密钥从 `lib/config/auth_config.dart` 读取（内部用 `String.fromEnvironment(...)` 注入），**不要**硬编码在源文件里。

**Don't**
- 不要引入非本调色板组合出的渐变。
- 不要再用 `LinearGradient + 'G' Text` 拼 Google 四色 G —— 必须使用 SVG。
- 不要在 "Sign in with Apple" 上用 Material `Icons.apple`；iOS 端如要严格合规，优先使用 `sign_in_with_apple` 包的官方 `SignInWithAppleButton`。
- 不要用 Unicode 字符 `𝕏` 表达 X 品牌（不同系统字体渲染差异极大）—— 一律使用 `assets/icons/social/x.svg`。
- 正文字重不要超过 `w600`。`w700` 仅留给 H1 与卡内大标题。
- 单屏不要出现两个主 CTA。需要第二动作就降级为第三级描边胶囊。
- Apple 黑与品牌蓝两个大色面紧贴时必须留 `16.h` 间距。

---

## 8. 响应式行为

本 App 是单方向手机端产品，所谓"响应式"指**密度变化**而非断点。

- **设计基准**：750 × 1334 设计 px（约 iPhone 8 Plus）。`flutter_screenutil` 会按机型宽度线性缩放。
- **最小可点击目标**：主操作 `80.h`，图标按钮 `64.h`，不低于 `44.h`（Apple HIG / Material 可访问性）。
- **长内容页**：表单用 `SingleChildScrollView`，列表用 `ListView.builder`。嵌套横向滚动（Markdown 表格）必须设置 `physics: ClampingScrollPhysics()`，避免 iOS 的橡皮筋效果抢走外层滚动。
- **状态栏**：AppBar 自身背景决定状态栏样式 —— `#1989FA` 上用白色图标，白底页面用深色图标。
- **安全区**：所有全屏 `Scaffold` 必须留出底部 Home Indicator 的安全区（用 `SafeArea` 或足够的底部内边距）。
- **平板 / 横屏**：暂不在范围内。布局允许被拉伸，但不再额外定义断点。

---

## 9. Agent Prompt 指南

### 9.1 快查色表

```
brand           : 0xFF1989FA
brand-gradient  : 0xFF1989FA → 0xFF069EF0
brand-deep      : 0xFF0E6FD8
canvas          : 0xFFF7F8FA
card            : 0xFFFFFFFF
text/primary    : 0xFF323233
text/secondary  : 0xFF4A4A4A
text/hint       : 0xFF969799
border          : 0xFFE6E6E6
warning         : 0xFFFFA500
premium         : 0xFFFFD700
danger          : 0xFFFF6B6B
purple          : 0xFF7232DD
ticket          : 0xFF667EEA
```

### 9.2 可直接复用的 prompt

- **新页面**：
  > "按 `app/DESIGN.md` 的 Otaku Movie 设计系统实现一个 Flutter 页面：Scaffold 背景 `#F7F8FA`，使用 `CustomAppBar`，背景色 `#1989FA`，主体内容放在 `#FFFFFF` 卡片中，圆角 `24.r`、阴影 E3。所有数值通过 `flutter_screenutil`。所有面向用户的字符串走 `S.of(context).*`，需要新文案时在 `app/lib/l10n/intl_{zh,en,ja}.arb` 与对应的 `generated/` 文件同步补 key。"

- **新主按钮**：
  > "实现一个主操作按钮：高 `80.h`，圆角 `16.r`，线性渐变 `#1989FA → #069EF0`，阴影 `#1989FA @ 30%`，`blur 12 / offset (0, 6)`。前置 Material icon `32.sp` 白色，文字 `28.sp` w600 白色。"

- **新输入框**：
  > "实现一个 `TextField`：填充色 `#F7F8FA`，默认无边框，圆角 `16.r`，聚焦时 `2px #1989FA` 描边。Label `#969799 24.sp`，文字 `#323233 28.sp`。前置图标放进一个 `40.w × 40.h` 的方块容器（margin `12.w`，padding `10.w`，背景 `#1989FA @ 10%`，圆角 `8.r`）。"

- **新社交登录**：
  > "新增一个第三方登录按钮，使用 `SvgPicture.asset('assets/icons/social/<google|apple|x>.svg')`。容器 `80.h`、圆角 `16.r`；Google 表面 `#FFFFFF` 配 `#E6E6E6` 描边，Apple / X 表面 `#000000`。文字取自 `S.of(context).login_<google|apple|x>Login`，错误提示用 `S.of(context).login_<google|apple|x>LoginFailed`。"

- **新 Markdown 长文（协议类）**：
  > "使用 `flutter_markdown`，复用 `agreement_page.dart` 中的 `MarkdownStyleSheet`：段落 `28.sp #323233 height 1.7`；H1–H4 字号 `40/36/32/30`；blockquote 底 `#E8F4FF`、圆角 `8.r`；行内 code 底 `#F2F4F7`、圆角 `6.r`。对于宽表格，调用 `_buildTable` 并启用水平滚动，外框 `#E4E7EC`、内框 `#F0F2F5`、表头底 `#F7F8FA`。"

### 9.3 Agent 可参考的锚点文件

- 颜色 / 间距 / 阴影实例：`app/lib/pages/user/login.dart`、`app/lib/pages/agreement/agreement_page.dart`、`app/lib/pages/movie/ShowTimeDetail.dart`。
- 国际化 key 与调用方式：`app/lib/l10n/intl_*.arb`、`app/lib/generated/l10n.dart`，统一通过 `S.of(context).<key>` 使用。
- 第三方登录配置：`app/lib/config/auth_config.dart`。
- 资源根目录：`assets/icons/`（通用）、`assets/icons/pay/`（支付）、`assets/icons/social/`（Google / Apple / X）、`assets/image/`。
