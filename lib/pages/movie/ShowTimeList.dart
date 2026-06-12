import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/analytics/analytics.dart';
import 'package:otaku_movie/analytics/events.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/FilterBar.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/area_response.dart';
import 'package:otaku_movie/response/cinema/brand_response.dart';
import 'package:otaku_movie/response/cinema/cinema_spec_response.dart';
import 'package:otaku_movie/response/movie/show_time.dart';
import 'package:otaku_movie/response/language/language_response.dart';
import 'package:otaku_movie/response/cinema/cinema_movie_show_time_detail_response.dart';
import 'package:otaku_movie/utils/location_util.dart';
import 'package:otaku_movie/service/favorite_cinema_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:get/get.dart';
import 'package:otaku_movie/components/dict.dart';
import 'package:otaku_movie/controller/DictController.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/controller/TimeFormatController.dart';
import 'package:otaku_movie/response/dict_response.dart';
import 'package:otaku_movie/utils/area_i18n_util.dart';
import 'package:otaku_movie/utils/date_format_util.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/utils/toast.dart';

class ShowTimeList extends StatefulWidget {
  final String? id;
  final String? movieName;
  final String? reReleaseId;

  const ShowTimeList({super.key, this.id, this.movieName, this.reReleaseId});

  @override
  State<ShowTimeList> createState() => _PageState();
}

class _PageState extends State<ShowTimeList> with TickerProviderStateMixin {
  TabController? _tabController; // 改为可空
  List<ShowTimeResponse> data = [];
  List<CinemaSpecResponse> cinemaSpec = [];
  List<BrandResponse> brandList = [];
  // 每个日期的全量摘要（cinemaCount / showTimeCount），由后端 summary 字段填充，
  // 用于顶部"X 家影院 · Y 场"显示，独立于分页结果。
  Map<String, ShowTimeSummary> _summaryByDate = {};
  List<AreaResponse> areaTreeList = [];
  List<LanguageResponse> languageList = []; // 添加字幕列表
  List<ShowTimeTag> showTimeTagList = []; // 添加上映标签列表
  // 该电影实际出现过的字幕语言 id / 上映标签 id（来自 /app/movie/showTimeFilters）。
  // null = 还没拉到 / 拉取失败：此时筛选项退化为显示全量字典，避免漏选。
  Set<int>? _availableSubtitleIds;
  Set<int>? _availableShowTimeTagIds;
  List<DictItemResponse> versionList = []; // 版本列表（字典 dubbingVersion）
  List<DictItemResponse> dimensionList = []; // 2D/3D 列表（字典 dimensionType）
  late DictController dictController; // 字典控制器
  late TimeFormatController timeFormatController;
  Worker? _timeFormatWorker;
  // 语言切换后，重新拉取「名称来自后端」的筛选项（tag/字幕等），使其跟随语言。
  Worker? _localeWorker;
  // 字典刷新后，同步本地的版本/维度列表（这两项的文案也跟随语言）。
  Worker? _dictWorker;
  int tabLength = 0;
  // 初值 true：进入页面第一帧就显示 loading，避免「空白一闪 → 转圈」的视觉跳变。
  // _loadInitialData 完成后会把它置回 false。
  bool loading = true;
  bool error = false;
  int currentPage = 1;
  bool loadFinished = false;
  static const int _pageSize = 10;
  Map<String, dynamic> filterParams = {};
  Placemark? location;
  Position? position;
  String? currentAddressFull;
  bool locationLoading = false;
  /// FilterBar 的版本号：默认地区从定位自动写入 filterParams 时 +1，
  /// 用 ValueKey 强制 FilterBar 重建一次，让它的 selected 同步 initialSelected。
  /// 用户后续手动改筛选时不再递增，避免 dropdown 状态被打断。
  int _filterBarVersion = 0;
  /// 是否已经基于当前定位尝试过自动选中地区——只跑一次，避免反复覆盖用户手动选择。
  bool _autoAreaApplied = false;
  TextEditingController searchController = TextEditingController(); // 搜索关键词控制器
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    // 购票漏斗入口：新开一条 flow，后续选座/票种/下单/支付都带同一 flow_id。
    Analytics.instance.startPurchaseFlow();
    Analytics.instance.logFunnel(Ev.showtimeListView, {
      P.movieId: widget.id,
      P.reReleaseId: widget.reReleaseId,
    });
    dictController = Get.find<DictController>();
    timeFormatController = Get.find<TimeFormatController>();
    _timeFormatWorker = ever<bool>(
      timeFormatController.use30HourFormat,
      (value) {
        if (!mounted) return;
        setState(() {});
        getData();
      },
    );
    // 监听语言切换：tag/字幕/品牌等筛选项的名称由后端按 Accept-Language 返回，
    // 页面只在 initState 拉过一次，切语言后需重新拉取才能跟随语言显示。
    if (Get.isRegistered<LanguageController>()) {
      _localeWorker = ever<Locale>(
        Get.find<LanguageController>().locale,
        (_) {
          if (!mounted) return;
          getCinemaSpec();
          getBrandList();
          getAreaTree();
          getLanguageList();
          getShowTimeTagList();
        },
      );
    }
    // 版本/维度来自字典：字典在语言切换后会重载，这里同步刷新本地副本。
    _dictWorker = ever(
      dictController.dict,
      (_) {
        if (!mounted) return;
        getVersionList();
      },
    );
    _loadInitialData();
  }

  @override
  void dispose() {
    _timeFormatWorker?.dispose();
    _localeWorker?.dispose();
    _dictWorker?.dispose();
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    _tabController = null;
    easyRefreshController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // 加载初始数据
  Future<void> _loadInitialData() async {
    // 开始时设置 loading 状态
    setState(() {
      loading = true;
      error = false;
    });

    // 先加载筛选数据
    await getCinemaSpec();
    await getBrandList();
    await getAreaTree();
    await getLanguageList();
    await getShowTimeTagList();
    await getShowTimeFilters();
    await getVersionList();

    // 用系统缓存的最后一次定位预填 position：
    //   - 命中缓存：首次 getData 直接带 lat/lng → 后端按距离排序 → 列表一次到位，
    //     精确定位回来后位置基本一致，refresh 不会引起明显跳动；
    //   - 没缓存（首次安装 / 拒权限 / 关定位）：position 仍为 null，按原流程走，
    //     后台精确定位完成后才会补一次 refresh（这种情况无法避免跳一次）。
    // 这里用快返回的 getLastKnownPosition，不弹权限框、不激活 GPS，几乎是即时的。
    // 定位插件在个别机型可能不返回；加超时兜底，避免卡在这里导致后续 getData 永不执行。
    final cachedPosition = await LocationUtil.getLastKnownPosition()
        .timeout(const Duration(seconds: 3), onTimeout: () => null);
    if (!mounted) return;
    if (cachedPosition != null) {
      // 仅写入 position，不做反向地理编码（地址那一栏可以等精确定位再填）。
      // 用 setState 是为了 _buildRequestData 读到新值；这一帧没有 UI 依赖 position。
      setState(() {
        position = cachedPosition;
      });
    }

    // 先加载数据（显示loading），然后再获取位置
    await getData();

    // 后台获取精确位置 + 反向地理编码；若位置变化命中地区或筛选条件，
    // getLocation 内部会再触发一次 getData(refresh: true)。
    getLocation();
  }

  Future<void> getAreaTree() async {
    try {
      final res = await ApiRequest().request(
        path: '/areas/tree',
        method: 'GET',
        fromJsonT: (json) {
          if (json is List<dynamic>) {
            return json.map((item) => AreaResponse.fromJson(item)).toList();
          }
        },
      );
      if (!mounted) return;
      if (res.data != null) {
        List<AreaResponse> list = res.data!;

        setState(() {
          areaTreeList = list;
        });
        print(areaTreeList);
        // 地区树就绪——若此时已经定位完成，尝试自动选中当前所在地区
        _tryAutoSelectArea();
      }
    } catch (e) {
      print('获取地区树失败: $e');
    }
  }

  Future<void> getCinemaSpec() async {
    try {
      final res = await ApiRequest().request(
        path: '/cinema/spec/list',
        method: 'POST',
        data: {
          'page': 1,
          'pageSize': 30,
        },
        fromJsonT: (json) {
          return ApiPaginationResponse<CinemaSpecResponse>.fromJson(
            json,
            (data) => CinemaSpecResponse.fromJson(data as Map<String, dynamic>),
          );
        },
      );
      if (!mounted) return;
      if (res.data?.list != null) {
        List<CinemaSpecResponse> list = res.data!.list!;

        setState(() {
          cinemaSpec = list;
        });
        print(cinemaSpec);
      }
    } catch (e) {
      print('获取影厅规格失败: $e');
    }
  }

  Future<void> getBrandList() async {
    try {
      final res = await ApiRequest().request(
        path: '/brand/list',
        method: 'POST',
        data: {
          'page': 1,
          'pageSize': 100,
        },
        fromJsonT: (json) {
          return ApiPaginationResponse<BrandResponse>.fromJson(
            json,
            (data) => BrandResponse.fromJson(data as Map<String, dynamic>),
          );
        },
      );
      if (!mounted) return;
      final list = res.data?.list ?? [];
      setState(() {
        brandList = list;
      });
    } catch (e) {
      print('获取品牌列表失败: $e');
    }
  }

  Future<void> getLanguageList() async {
    try {
      final res = await ApiRequest().request(
        path: '/language/list',
        method: 'POST',
        data: {
          'page': 1,
          'pageSize': 30,
        },
        fromJsonT: (json) {
          return ApiPaginationResponse<LanguageResponse>.fromJson(
            json,
            (data) => LanguageResponse.fromJson(data as Map<String, dynamic>),
          );
        },
      );
      if (!mounted) return;
      if (res.data?.list != null) {
        List<LanguageResponse> list = res.data!.list!;

        setState(() {
          languageList = list;
        });
        print('字幕列表: $languageList');
      }
    } catch (e) {
      print('获取字幕列表失败: $e');
    }
  }

  Future<void> getShowTimeTagList() async {
    try {
      final res = await ApiRequest().request(
        path: '/showTimeTag/list',
        method: 'POST',
        data: {
          'page': 1,
          'pageSize': 30,
        },
        fromJsonT: (json) {
          return ApiPaginationResponse<ShowTimeTag>.fromJson(
            json,
            (data) => ShowTimeTag.fromJson(data as Map<String, dynamic>),
          );
        },
      );
      if (!mounted) return;
      if (res.data?.list != null) {
        List<ShowTimeTag> list = res.data!.list!;

        setState(() {
          showTimeTagList = list;
        });
        print('上映标签列表: $showTimeTagList');
      }
    } catch (error) {
      print('获取上映标签列表失败: $error');
    }
  }

  /// 拉取该电影实际出现过的字幕语言 / 上映标签 id，用于把筛选项收敛到「真正有的」。
  /// 仅按 movieId(+reReleaseId) 查询，不随其它筛选联动；失败时保持 null（显示全量）。
  Future<void> getShowTimeFilters() async {
    final movieId = int.tryParse((widget.id ?? '').trim());
    if (movieId == null) return;
    final data = <String, dynamic>{'movieId': movieId};
    final rrId = int.tryParse((widget.reReleaseId ?? '').trim());
    if (rrId != null) data['reReleaseId'] = rrId;

    try {
      final res = await ApiRequest().request(
        path: '/app/movie/showTimeFilters',
        method: 'POST',
        data: data,
        fromJsonT: (json) => json,
      );
      if (!mounted) return;
      final m = res.data;
      if (m is Map) {
        Set<int> toIntSet(dynamic v) => (v is List)
            ? v
                .whereType<num>()
                .map((e) => e.toInt())
                .toSet()
            : <int>{};
        setState(() {
          _availableSubtitleIds = toIntSet(m['subtitleIds']);
          _availableShowTimeTagIds = toIntSet(m['showTimeTagIds']);
        });
      }
    } catch (error) {
      print('获取场次筛选项失败: $error');
    }
  }

  Future<void> getVersionList() async {
    if (!mounted) return;
    setState(() {
      if (dictController.dict.value['dubbingVersion'] != null) {
        versionList = dictController.dict.value['dubbingVersion']!;
      }
      if (dictController.dict.value['dimensionType'] != null) {
        dimensionList = dictController.dict.value['dimensionType']!;
      }
    });
  }

  Future<void> getLocation() async {
    try {
      if (mounted) {
        setState(() {
          locationLoading = true;
        });
      }
      final current = await LocationUtil.getCurrentPosition(
          accuracy: LocationAccuracy.high);
      if (current == null) {
        // 获取不到位置，不设置 loading = false，让后续逻辑处理
        return;
      }
      // 用结构化（Nominatim/日文）反编码拿行政区划，保证「地区」能匹配到后端地区树；
      // placemarkFromCoordinates 在部分机型会失败返回 null，导致地区选不中。
      final place = await LocationUtil.reverseGeocodeAdmin(current);
      final full =
          await LocationUtil.reverseGeocodeTextLocalized(context, current);
      if (!mounted) return;
      setState(() {
        location = place;
        position = current;
        currentAddressFull = full;
      });
      // 定位就绪——若此时地区树已经加载完毕，尝试自动选中当前所在地区
      // （注意 _tryAutoSelectArea 内部已经会调一次 getData(refresh: true)）
      _tryAutoSelectArea();
      if (!_autoAreaApplied || filterParams['areaId'] == null) {
        // 没自动选地区时也要刷新，以便距离展示
        getData(refresh: true);
      }
    } catch (e) {
      print('Error getting location: $e');
      // 获取位置失败，不阻止数据加载
    } finally {
      if (mounted) {
        setState(() {
          locationLoading = false;
        });
      }
    }
  }

  /// 规范化地区名以便跨语种 / 带后缀匹配：
  ///   - 去掉空白、转小写
  ///   - 去掉日文行政区划后缀（都/府/県/道/市/区/町/村）
  ///   - 去掉英文 "prefecture"、中文「县」「市」之类
  ///
  /// 用于 Placemark.administrativeArea / locality 与 areaTreeList[*].name 的模糊匹配。
  String _normalizeAreaName(String? s) {
    if (s == null) return '';
    return s
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'都|府|県|道|州|市|区|町|村|县'), '')
        .replaceAll('prefecture', '')
        .replaceAll(RegExp(r'\s+'), '');
  }

  bool _areaMatches(AreaResponse area, String? raw) {
    if (raw == null) return false;
    final r = _normalizeAreaName(raw);
    if (r.isEmpty) return false;
    for (final cand in [area.name, area.nameKana]) {
      final c = _normalizeAreaName(cand);
      if (c.isEmpty) continue;
      if (c == r || c.contains(r) || r.contains(c)) return true;
    }
    return false;
  }

  /// 仅在 `filterParams['areaId']` 还没有值时（即用户未手动选过），
  /// 用当前 Placemark 在 areaTreeList 里逐级模糊匹配出 [regionId, prefectureId, cityId?]
  /// 并写入 filterParams，触发一次刷新。
  void _tryAutoSelectArea() {
    if (_autoAreaApplied) return;
    if (!mounted) return;
    if (location == null) return;
    if (areaTreeList.isEmpty) return;
    final existing = filterParams['areaId'];
    final hasUserSelection = existing is List
        ? existing.where((e) => (e?.toString() ?? '').isNotEmpty).isNotEmpty
        : (existing?.toString().isNotEmpty ?? false);
    if (hasUserSelection) {
      _autoAreaApplied = true;
      return;
    }

    final p = location!;
    AreaResponse? regionMatch;
    AreaResponse? prefectureMatch;
    for (final region in areaTreeList) {
      for (final pref in region.children ?? <AreaResponse>[]) {
        if (_areaMatches(pref, p.administrativeArea)) {
          regionMatch = region;
          prefectureMatch = pref;
          break;
        }
      }
      if (prefectureMatch != null) break;
    }
    if (regionMatch == null || prefectureMatch == null) {
      // 拿不到精确匹配时不强行预选，避免误导
      _autoAreaApplied = true;
      return;
    }

    // 自动选区只到 2 级（地区 + 都道府県）即可，不再下钻到市区町村，
    // 避免定位到具体区后把范围收得太窄、漏掉同都府县其他区的场次。
    final ids = <String>[
      '${regionMatch.id}',
      '${prefectureMatch.id}',
    ];
    _autoAreaApplied = true;
    setState(() {
      filterParams['areaId'] = ids;
      // 让 FilterBar 重建一次，吸收新的 initialSelected
      _filterBarVersion++;
    });
    getData(refresh: true);
  }

  /// 从 filterParams 中获取第一个值并转换为整数
  int? _getIntFromFilter(String key) {
    final value = filterParams[key];
    if (value is List && value.isNotEmpty) {
      final str = value[0]?.toString() ?? '';
      if (str.isNotEmpty && str != '') {
        return int.tryParse(str);
      }
    } else if (value != null) {
      final str = value.toString();
      if (str.isNotEmpty && str != '') {
        return int.tryParse(str);
      }
    }
    return null;
  }

  /// 从 filterParams 中获取列表值
  List<int>? _getIntListFromFilter(String key) {
    final value = filterParams[key];
    if (value is List && value.isNotEmpty) {
      final list = value
          .where((item) =>
              item != null &&
              item.toString().isNotEmpty &&
              item.toString() != '')
          .map((item) => int.tryParse(item.toString()))
          .whereType<int>()
          .toList();
      return list.isNotEmpty ? list : null;
    }
    return null;
  }

  /// 构建请求参数
  Map<String, dynamic> _buildRequestData({int page = 1}) {
    final requestData = <String, dynamic>{
      "movieId": int.parse(widget.id!),
      "page": page,
      "pageSize": _pageSize,
    };

    final rrId = int.tryParse((widget.reReleaseId ?? '').trim());
    if (rrId != null) {
      requestData["reReleaseId"] = rrId;
    }

    // 地区筛选
    final areaIdList = filterParams['areaId'] ?? [];
    if (areaIdList.isNotEmpty) {
      final regionId = int.tryParse(areaIdList[0]?.toString() ?? '');
      if (regionId != null) requestData["regionId"] = regionId;

      if (areaIdList.length > 1) {
        final prefectureId = int.tryParse(areaIdList[1]?.toString() ?? '');
        if (prefectureId != null) requestData["prefectureId"] = prefectureId;
      }

      if (areaIdList.length > 2) {
        final cityId = int.tryParse(areaIdList[2]?.toString() ?? '');
        if (cityId != null) requestData["cityId"] = cityId;
      }
    }

    // 筛选条件
    final subtitleId = _getIntFromFilter('subtitleId');
    if (subtitleId != null) requestData["subtitleId"] = subtitleId;

    final specId = _getIntListFromFilter('specId');
    if (specId != null) requestData["specId"] = specId;

    final brandId = _getIntFromFilter('brandId');
    if (brandId != null) requestData["brandId"] = [brandId];

    final showTimeTagId = _getIntFromFilter('showTimeTagId');
    if (showTimeTagId != null) requestData["showTimeTagId"] = showTimeTagId;

    final dimensionType = _getIntFromFilter('dimensionType');
    if (dimensionType != null) requestData["dimensionType"] = dimensionType;

    final versionCode = _getIntFromFilter('versionCode');
    if (versionCode != null) requestData["versionCode"] = versionCode;

    // 搜索关键词
    final keyword = searchController.text.trim();
    if (keyword.isNotEmpty) {
      requestData["keyword"] = keyword;
    }

    // 开场时间范围筛选
    final timeRange = filterParams['timeRange'];
    if (timeRange is List && timeRange.length == 2) {
      final startTime = timeRange[0]?.toString();
      final endTime = timeRange[1]?.toString();

      if (startTime != null && startTime.isNotEmpty) {
        requestData["startTimeFrom"] = startTime;
      }
      if (endTime != null && endTime.isNotEmpty) {
        requestData["startTimeTo"] = endTime;
      }
    }

    // 30小时制开关统一使用全局偏好。
    if (timeFormatController.use30HourFormat.value) {
      requestData["use30HourFormat"] = true;
    }

    // 经纬度参数（用于附近影院查询）
    if (position != null) {
      requestData['latitude'] = position!.latitude;
      requestData['longitude'] = position!.longitude;
    }

    return requestData;
  }

  Future<void> getData(
      {int page = 1, bool refresh = false, bool silent = false}) async {
    // 加载更多时若已无更多数据，直接结束
    if (page > 1 && loadFinished) {
      easyRefreshController.finishLoad(IndicatorResult.noMore, true);
      return;
    }

    // 记录调用接口前的tab日期，用于接口返回后恢复tab
    String? previousTabDate;
    if (_tabController != null &&
        _tabController!.index >= 0 &&
        _tabController!.index < data.length &&
        data[_tabController!.index].date != null) {
      previousTabDate = data[_tabController!.index].date;
    }

    // 首次加载 / 筛选切换会显示整页 loading；下拉刷新与加载更多由 EasyRefresh 的头/尾指示器提示。
    // silent=true（如切换日期 tab 时）保留当前列表静默刷新，避免整页转圈造成的闪烁。
    final showFullScreenLoading = page == 1 && !refresh && !silent;
    if (showFullScreenLoading && mounted) {
      setState(() {
        loading = true;
        error = false;
      });
    }

    try {
      // 放进 try：_buildRequestData 内有 int.parse(widget.id!) 等，
      // 若 id 异常会抛错；放在 try 外会绕过下面的 catch，导致 loading 永不关闭。
      final requestData = _buildRequestData(page: page);

      final res = await ApiRequest().request(
        path: '/app/movie/showTime',
        method: 'POST',
        data: requestData,
        fromJsonT: (json) {
          // 新响应：{ data: [...], summary: [...] }
          if (json is Map<String, dynamic>) {
            final dataList = (json['data'] as List<dynamic>? ?? [])
                .map((e) =>
                    ShowTimeResponse.fromJson(e as Map<String, dynamic>))
                .toList();
            final summaryList = (json['summary'] as List<dynamic>? ?? [])
                .map((e) =>
                    ShowTimeSummary.fromJson(e as Map<String, dynamic>))
                .toList();
            return ShowTimeListResult(data: dataList, summary: summaryList);
          }
          // 兼容旧响应：直接是 List
          if (json is List<dynamic>) {
            return ShowTimeListResult(
              data: json
                  .map((e) =>
                      ShowTimeResponse.fromJson(e as Map<String, dynamic>))
                  .toList(),
              summary: const [],
            );
          }
          return ShowTimeListResult.empty();
        },
      );

      final ShowTimeListResult result = res.data ?? ShowTimeListResult.empty();
      final list = result.data;
      // 摘要数据每页都会带，覆盖即可（筛选条件不变时数字稳定）
      if (result.summary.isNotEmpty) {
        _summaryByDate = {
          for (final s in result.summary)
            if (s.date != null) s.date!: s,
        };
      } else if (page == 1) {
        // 旧响应或后端没返回 summary：清空缓存，让摘要条退化到本地累加。
        _summaryByDate = {};
      }

      // 计算距离并按距离排序（影响排序，必须在合并前完成）
      if (position != null && list.isNotEmpty) {
        _computeDistancesForList(list);
      }

      if (!mounted) return;

      // 后端按"影院"分页（每页 _pageSize 家影院），但接口返回的是「按日期分组」
      // 的数组。判断"是否还有下一页"必须看本次返回的 **去重 cinema id 数**，
      // 而不是 list.length（list.length 是日期数，最多 7 天，几乎永远 < pageSize，
      // 会被误判成 noMore，下一页永远拉不到）。
      final cinemaIdSet = <int>{};
      for (final entry in list) {
        for (final c in (entry.data ?? [])) {
          final id = c.cinemaId;
          if (id != null) cinemaIdSet.add(id);
        }
      }
      final cinemaCount = cinemaIdSet.length;

      if (page == 1) {
        // 首次加载 / 下拉刷新 / 筛选切换：替换数据
        setState(() {
          data = list;
          tabLength = data.length;
          currentPage = 1;
          loadFinished = cinemaCount < _pageSize;
          loading = false;
          error = false;
        });

        _rebuildTabController(previousTabDate);

        if (refresh) {
          easyRefreshController.finishRefresh(IndicatorResult.success, true);
        }
      } else {
        // 加载更多：合并到现有数据，并按日期 + cinemaId 去重
        final mergedCount = _mergePagedData(list);
        // 到底条件：本页返回的影院数 < pageSize；或者 mergedCount==0（极少见的
        // 兜底，避免分页边界时无限循环拉同一页）。
        final reachedEnd = cinemaCount < _pageSize || mergedCount == 0;

        setState(() {
          tabLength = data.length;
          currentPage = page;
          loadFinished = reachedEnd;
          error = false;
        });

        // 若日期 tab 数量发生变化，重建 TabController 以保持选中项
        if (_tabController == null || _tabController!.length != tabLength) {
          _rebuildTabController(previousTabDate);
        }

        easyRefreshController.finishLoad(
          reachedEnd ? IndicatorResult.noMore : IndicatorResult.success,
          true,
        );
      }
    } catch (err) {
      print('获取数据失败: $err');
      if (!mounted) return;

      if (page == 1) {
        // 首次加载 / 下拉刷新失败：仅在没有缓存数据时显示错误页
        setState(() {
          loading = false;
          if (data.isEmpty) {
            error = true;
          }
        });
        if (refresh) {
          easyRefreshController.finishRefresh(IndicatorResult.fail, true);
        }
      } else {
        // 加载更多失败：保留已加载的内容，仅提示底部失败
        easyRefreshController.finishLoad(IndicatorResult.fail, true);
      }
    }
  }

  /// 把新加载的分页数据合并进 [data]：
  /// - 已存在的日期，按 `cinemaId` 去重后追加新的影院
  /// - 不存在的日期，整段 push 到末尾
  ///
  /// 返回本次「真正新增的影院条目数」，用于判定是否还有更多数据。
  int _mergePagedData(List<ShowTimeResponse> incoming) {
    int added = 0;
    for (final entry in incoming) {
      final existingIndex = data
          .indexWhere((item) => item.date != null && item.date == entry.date);
      if (existingIndex >= 0) {
        final existing = data[existingIndex];
        final existingIds = (existing.data ?? [])
            .map((c) => c.cinemaId)
            .whereType<int>()
            .toSet();
        final toAdd = (entry.data ?? []).where((c) {
          final id = c.cinemaId;
          return id == null || existingIds.add(id);
        }).toList();
        if (toAdd.isNotEmpty) {
          (existing.data ?? <Cinema>[]).addAll(toAdd);
          added += toAdd.length;
        }
      } else {
        data.add(entry);
        added += (entry.data?.length ?? 0);
      }
    }
    return added;
  }

  /// 根据当前 [data] 重建 TabController，并尽量保持原日期 tab 选中。
  void _rebuildTabController(String? previousTabDate) {
    if (!mounted) return;

    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    _tabController = null;

    if (data.isEmpty) {
      return;
    }

    int targetIndex = 0;
    if (previousTabDate != null) {
      final idx = data.indexWhere((item) => item.date == previousTabDate);
      if (idx >= 0) targetIndex = idx;
    }

    _tabController = TabController(
      length: data.length,
      vsync: this,
      initialIndex: targetIndex,
    );
    _tabController!.addListener(_onTabChanged);
  }

  // 计算距离并排序
  void _computeDistancesForList(List<ShowTimeResponse> responses) {
    if (position == null) {
      print('⚠️ _computeDistancesForList: position 为 null');
      return;
    }

    for (var response in responses) {
      if (response.data == null) continue;
      int computedCount = 0;
      for (var cinema in response.data!) {
        if (cinema.cinemaLatitude != null && cinema.cinemaLongitude != null) {
          final distance = LocationUtil.distanceBetweenMeters(
            position!,
            cinema.cinemaLatitude,
            cinema.cinemaLongitude,
          );
          if (distance != null) {
            cinema.distance = distance;
            computedCount++;
            print(
                '📍 影院 ${cinema.cinemaName}: 距离 ${distance.toStringAsFixed(0)}m (${cinema.cinemaLatitude}, ${cinema.cinemaLongitude})');
          } else {
            print('⚠️ 无法计算 ${cinema.cinemaName} 的距离');
          }
        } else {
          print(
              '⚠️ ${cinema.cinemaName} 缺少经纬度: lat=${cinema.cinemaLatitude}, lng=${cinema.cinemaLongitude}');
        }
      }
      print('✅ 已计算 ${computedCount}/${response.data!.length} 个影院的距离');

      // 收藏的影院优先置顶，其次再按距离升序（与后端收藏置顶口径一致）
      response.data!.sort((a, b) {
        final fa = a.favorite == true ? 0 : 1;
        final fb = b.favorite == true ? 0 : 1;
        if (fa != fb) return fa - fb;
        final distA = a.distance ?? double.infinity;
        final distB = b.distance ?? double.infinity;
        return distA.compareTo(distB);
      });
    }
  }

  List<Widget> generateTab() {
    final currentYear = DateTime.now().year;
    final List<String> weekList = [
      S.of(context).common_week_monday,
      S.of(context).common_week_tuesday,
      S.of(context).common_week_wednesday,
      S.of(context).common_week_thursday,
      S.of(context).common_week_friday,
      S.of(context).common_week_saturday,
      S.of(context).common_week_sunday,
    ];

    return data.map((item) {
      DateTime date = DateTime.parse(item.date!);
      List<String> dateParts = item.date!.split("-");

      // 如果是今年，只显示月/日；如果不是今年，显示年/月/日
      String formattedDate;
      if (date.year == currentYear) {
        formattedDate = "${dateParts[1]}/${dateParts[2]}"; // 月/日
      } else {
        formattedDate =
            "${dateParts[0]}/${dateParts[1]}/${dateParts[2]}"; // 年/月/日
      }

      // 日文「金曜日」去掉「曜日」只留单字（金/土/日…）；其他语言无此后缀，replaceAll 为空操作。
      final String weekLabel =
          weekList[date.weekday - 1].replaceAll('曜日', '');

      return Tab(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekLabel, // 星期
              style: TextStyle(fontSize: 30.sp, height: 1.1),
            ),
            SizedBox(height: 6.h),
            Text(
              formattedDate, // 日期格式为 "月/日"
              style: TextStyle(
                fontSize: 28.sp,
                height: 1.1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// Tab切换监听：更新时间范围筛选器的日期部分，保持时间不变，并重新加载数据
  void _onTabChanged() {
    if (_tabController == null) {
      return;
    }

    // 只在tab切换完成时执行（不是切换过程中）
    if (_tabController!.indexIsChanging) {
      return;
    }

    // tab 切换完成时触发一次重绘：
    // 让顶部摘要条（X 家影院 · Y 场）能感知到新 tab 的数据。
    if (mounted) {
      setState(() {});
    }

    // 检查是否有时间范围筛选
    final timeRange = filterParams['timeRange'];
    if (timeRange is List && timeRange.length >= 2) {
      try {
        final startTimeStr = timeRange[0]?.toString();
        final endTimeStr = timeRange[1]?.toString();

        if (startTimeStr != null &&
            startTimeStr.isNotEmpty &&
            endTimeStr != null &&
            endTimeStr.isNotEmpty) {
          // 解析当前时间范围
          final startDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').parse(startTimeStr);
          final endDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').parse(endTimeStr);

          // 获取新的基准日期
          final newBaseDate = _getCurrentTabDate();

          // 提取时间部分（小时、分钟、秒）
          final startTimeOnly =
              TimeOfDay(hour: startDateTime.hour, minute: startDateTime.minute);
          final endTimeOnly =
              TimeOfDay(hour: endDateTime.hour, minute: endDateTime.minute);
          final endSecond = endDateTime.second;

          // 构建新的日期时间（使用新日期 + 原时间）
          DateTime newStartDateTime;
          DateTime newEndDateTime;

          // 检查结束时间是否是下一天（30小时制）
          if (timeFormatController.use30HourFormat.value &&
              endDateTime.day > startDateTime.day) {
            // 结束时间是下一天，保持这个逻辑
            newStartDateTime = DateTime(
              newBaseDate.year,
              newBaseDate.month,
              newBaseDate.day,
              startTimeOnly.hour,
              startTimeOnly.minute,
            );
            newEndDateTime = DateTime(
              newBaseDate.year,
              newBaseDate.month,
              newBaseDate.day + 1,
              endTimeOnly.hour,
              endTimeOnly.minute,
              endSecond,
            );
          } else {
            // 同一天的情况
            newStartDateTime = DateTime(
              newBaseDate.year,
              newBaseDate.month,
              newBaseDate.day,
              startTimeOnly.hour,
              startTimeOnly.minute,
            );
            newEndDateTime = DateTime(
              newBaseDate.year,
              newBaseDate.month,
              newBaseDate.day,
              endTimeOnly.hour,
              endTimeOnly.minute,
              endSecond,
            );
          }

          // 更新时间范围
          final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
          setState(() {
            filterParams['timeRange'] = [
              dateFormat.format(newStartDateTime),
              dateFormat.format(newEndDateTime),
            ];
          });
        }
      } catch (e) {
        // 解析失败，忽略时间范围更新，但依然要重新加载数据
        print('更新时间范围失败: $e');
      }
      // 无论是否有时间范围筛选，tab切换时都重新加载数据。
      // 用 silent 静默刷新：保留当前列表，不整页转圈，避免切换日期时闪一下。
      getData(silent: true);
    }
  }

  /// 计算当前 tab（当日）下：可见影院数量与可见场次数量。
  ///
  /// 数据来源优先级：
  ///   1) 后端 `summary` 字段（全量、独立于分页）—— 准确，推荐使用；
  ///   2) 退化方案：本地累加已加载的 `data`，并过滤已禁用场次（open == false）。
  ///      仅当后端未返回 summary（兼容老接口）时使用。
  /// 若没有 tab/数据，返回 (0, 0)。
  ({int cinemaCount, int showTimeCount}) _getCurrentTabCounts() {
    if (_tabController == null ||
        _tabController!.index < 0 ||
        _tabController!.index >= data.length) {
      return (cinemaCount: 0, showTimeCount: 0);
    }
    final currentDate = data[_tabController!.index].date;

    // 优先：后端 summary
    if (currentDate != null && _summaryByDate.containsKey(currentDate)) {
      final s = _summaryByDate[currentDate]!;
      return (
        cinemaCount: s.cinemaCount ?? 0,
        showTimeCount: s.showTimeCount ?? 0,
      );
    }

    // 退化：本地累加（兼容旧后端响应）
    final cinemas = data[_tabController!.index].data ?? const <Cinema>[];
    int showTimeCount = 0;
    int cinemaCount = 0;
    for (final c in cinemas) {
      final visible = (c.showTimes ?? const <ShowTime>[])
          .where((s) => s.open != false)
          .length;
      if (visible > 0) {
        cinemaCount++;
        showTimeCount += visible;
      }
    }
    return (cinemaCount: cinemaCount, showTimeCount: showTimeCount);
  }

  /// 顶部摘要条：「X 家影院 · Y 场」+ 当前 Tab 日期（如果有）。
  /// 当没有数据时返回空 widget。
  /// 拼出"当前所在地"的简短文案（区/市级），用于回退展示。
  // ignore: unused_element
  String _currentLocalityText(BuildContext context) {
    if (location == null) return S.of(context).cinemaList_address;
    if (location!.subLocality != null && location!.subLocality!.isNotEmpty) {
      return location!.subLocality!;
    }
    if (location!.locality != null && location!.locality!.isNotEmpty) {
      return location!.locality!;
    }
    if (location!.administrativeArea != null &&
        location!.administrativeArea!.isNotEmpty) {
      return location!.administrativeArea!;
    }
    return S.of(context).cinemaList_address;
  }

  /// 按当前语言习惯拼出完整地址：
  ///   - zh：省/州 → 市 → 区/町 → 街道 → 邮编
  ///   - ja：邮编 → 都/道/府/県 → 市区町村 → 丁目番地
  ///   - en：街道 → 区/镇 → 市 → 省/州 → 邮编
  /// 优先使用 reverseGeocodeTextLocalized 拿到的整段 `currentAddressFull`
  /// （Nominatim 的 display_name），并去掉末尾国家名。
  // ignore: unused_element
  String _currentFullAddressText(BuildContext context) {
    if (location == null) return S.of(context).cinemaList_address;
    final parts = <String>[];
    void add(String? v) {
      if (v != null && v.trim().isNotEmpty) parts.add(v.trim());
    }
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'zh') {
      add(location!.administrativeArea);
      add(location!.locality);
      add(location!.subLocality);
      add(location!.street);
      add(location!.postalCode);
    } else if (lang == 'ja') {
      add(location!.postalCode);
      add(location!.administrativeArea);
      add(location!.locality);
      add(location!.subLocality);
      add(location!.street);
    } else {
      add(location!.street);
      add(location!.subLocality);
      add(location!.locality);
      add(location!.administrativeArea);
      add(location!.postalCode);
    }
    if (currentAddressFull != null && currentAddressFull!.isNotEmpty) {
      String text = currentAddressFull!;
      final country = location?.country;
      if (country != null && country.trim().isNotEmpty) {
        final trimmed = country.trim();
        text = text.replaceAll(
            RegExp(r"\s*,\s*" + RegExp.escape(trimmed) + r"\s*$"), '');
        text = text.replaceAll(
            RegExp(r"\s+" + RegExp.escape(trimmed) + r"\s*$"), '');
      }
      return text;
    }
    if (parts.isEmpty) return _currentLocalityText(context);
    return parts.join(' ');
  }

  /// 顶部「📍 当前所在地：xxx」条。
  /// 仅在反向地理编码完成（location != null）后显示；
  /// 定位失败 / 拒权限时返回空白，避免占位但毫无信息。
  // ignore: unused_element
  Widget _buildLocationBar() {
    if (location == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(
          left: 16.w, right: 16.w, top: 8.h, bottom: 4.h),
      child: Row(
        children: [
          Icon(
            Icons.my_location_rounded,
            size: 22.sp,
            color: const Color(0xFF1989FA),
          ),
          SizedBox(width: 6.w),
          Text(
            '${S.of(context).cinemaList_currentLocation}：',
            style: TextStyle(
              fontSize: 22.sp,
              color: const Color(0xFF646566),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              _currentFullAddressText(context),
              style: TextStyle(
                fontSize: 22.sp,
                color: const Color(0xFF323233),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar() {
    final counts = _getCurrentTabCounts();
    if (counts.cinemaCount == 0 && counts.showTimeCount == 0) {
      return const SizedBox.shrink();
    }
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(
          left: 16.w, right: 16.w, top: 4.h, bottom: 12.h),
      child: Row(
        children: [
          Icon(Icons.theaters_outlined,
              size: 24.sp, color: const Color(0xFF1989FA)),
          SizedBox(width: 8.w),
          Text(
            S.of(context).about_movieShowList_summary(
                counts.cinemaCount, counts.showTimeCount),
            style: TextStyle(
              fontSize: 22.sp,
              color: const Color(0xFF646566),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 获取当前 tab 对应的日期
  DateTime _getCurrentTabDate() {
    if (_tabController != null &&
        _tabController!.index >= 0 &&
        _tabController!.index < data.length &&
        data[_tabController!.index].date != null) {
      try {
        return DateTime.parse(data[_tabController!.index].date!);
      } catch (e) {
        // 解析失败，返回当前日期
        return DateTime.now();
      }
    }
    // 如果没有 tab 或数据为空，返回当前日期
    return DateTime.now();
  }

  /// 创建 Drawer 筛选项配置
  List<FilterOption> _buildDrawerFilters(BuildContext context) {
    final use30HourFormat = timeFormatController.use30HourFormat.value;

    return [
      // 时间范围筛选（统一跟随全局 24h/30h 偏好）
      FilterOption(
        key: 'timeRange',
        title: S.of(context).about_components_showTimeList_timeRange,
        type: FilterType.timeRange,
        use30HourFormat: use30HourFormat,
        values: [], // 时间范围不需要 values
      ),
      // 时间范围筛选（30小时制示例，可根据需要启用）
      // FilterOption(
      //   key: 'timeRange30h',
      //   title: '开场时间',
      //   type: 'timeRange',
      //   use30HourFormat: true, // 使用30小时制（0-5点显示为24-29点）
      //   values: [],
      // ),
      // FilterOption(
      //   key: 'use30HourFormat',
      //   title: '30小时制', // TODO: 添加国际化
      //   type: FilterType.switch_,
      //   icon: Icons.schedule_rounded,
      //   values: [], // Switch 类型不需要 values，只有选中和未选中两种状态
      // ),
      // Switch 开关示例（吹き替え版）
      // FilterOption(
      //   key: 'dubbingVersion',
      //   title: S.of(context).about_components_showTimeList_dubbingVersion,
      //   type: FilterType.switch_,
      //   values: [], // Switch 类型不需要 values，只有选中和未选中两种状态
      //   drawerDisplayConfig: DrawerFilterDisplayConfig(
      //     icon: Icons.record_voice_over_rounded,
      //     iconSize: 24.sp,
      //   ),
      // ),
      FilterOption(
        key: 'subtitleId',
        title: S.of(context).about_movieShowList_dropdown_subtitle,
        icon: Icons.subtitles_rounded,
        values: [
          // FilterValue(id: '', name: S.of(context).about_components_showTimeList_all), // 添加"全部"选项
          ...languageList
              .where((item) => item.name != null && item.name!.isNotEmpty)
              // 只保留该电影实际有的字幕语言（_availableSubtitleIds 为 null 时不过滤）。
              .where((item) =>
                  _availableSubtitleIds == null ||
                  (item.id != null &&
                      _availableSubtitleIds!.contains(item.id)))
              .map((item) {
            return FilterValue(id: item.id.toString(), name: item.name!);
          }).toList(),
        ],
      ),
      // 上映标签
      FilterOption(
        key: 'showTimeTagId',
        title: S.of(context).about_movieShowList_dropdown_tag,
        icon: Icons.local_activity_rounded,
        values: [
          FilterValue(
              id: '', name: S.of(context).about_components_showTimeList_all),
          ...showTimeTagList
              .where((item) => item.name != null && item.name!.isNotEmpty)
              // 只保留该电影实际有的上映标签（_availableShowTimeTagIds 为 null 时不过滤）。
              .where((item) =>
                  _availableShowTimeTagIds == null ||
                  (item.id != null &&
                      _availableShowTimeTagIds!.contains(item.id)))
              .map((item) =>
                  FilterValue(id: item.id.toString(), name: item.name!)),
        ],
      ),

      FilterOption(
        key: 'versionCode',
        title: S.of(context).about_movieShowList_dropdown_version,
        icon: Icons.movie_filter_rounded,
        type: FilterType.single, // 单选模式
        values: [
          FilterValue(
              id: '', name: S.of(context).about_components_showTimeList_all),
          ...versionList
              .where((item) => item.name != null && item.name!.isNotEmpty)
              .map((item) =>
                  FilterValue(id: item.code.toString(), name: item.name!)),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    FilterValue convertToFilterValue(dynamic item) {
      // 地区按当前语言「日文 + 翻译」并列显示（日语时只显示日文）：日文放 name、
      // 译名放 secondaryName，由 FilterBar 两端对齐渲染。name 仍为原始日文，不影响定位匹配。
      final ja = (item.name as String?)?.trim() ?? '';
      final translation = AreaI18nUtil.translation(
        context,
        name: item.name as String?,
        nameZh: item.nameZh as String?,
        nameEn: item.nameEn as String?,
      );
      return FilterValue(
        id: item.id.toString(),
        name: ja.isNotEmpty
            ? ja
            : S.of(context).about_components_showTimeList_unnamed,
        secondaryName: translation.isEmpty ? null : translation,
        children: (item.children != null && (item.children as List).isNotEmpty)
            ? (item.children as List)
                .where((child) =>
                    child.name != null && child.name.toString().isNotEmpty)
                .map((child) => convertToFilterValue(child))
                .toList()
            : null,
      );
    }

    if (loading) {
      return Scaffold(
        appBar: CustomAppBar(title: widget.movieName),
        body: AppErrorWidget(loading: loading, child: Container()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: CustomAppBar(
        title: widget.movieName,
        actions: [
          // 搜索图标按钮
          IconButton(
            icon: Icon(Icons.search, color: Colors.white, size: 42.sp),
            onPressed: () {
              GoRouter.of(context)
                  .pushNamed("home", queryParameters: {'tab': '2'});
            },
          ),
        ],
        bottom: (data.isNotEmpty && _tabController != null && mounted)
            ? TabBar(
                controller: _tabController!,
                tabs: generateTab(),
                isScrollable: true,
                // 去掉点击日期 tab 时的水波纹与高亮覆盖层
                splashFactory: NoSplash.splashFactory,
                overlayColor:
                    WidgetStateProperty.all<Color>(Colors.transparent),
                labelPadding:
                    EdgeInsets.symmetric(horizontal: 30.w, vertical: 0.h),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                labelStyle:
                    TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
                unselectedLabelStyle:
                    TextStyle(fontSize: 26.sp, fontWeight: FontWeight.normal),
                indicator: UnderlineTabIndicator(
                  borderSide: const BorderSide(width: 3, color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal: 20.w),
                ),
              )
            : null,
        backgroundColor: const Color(0xFF1989FA),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 36.sp, fontWeight: FontWeight.w600),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 筛选栏始终保留
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                top: 12.h, left: 16.w, right: 16.w, bottom: 12.h),
            child: FilterBar(
              // 当 _filterBarVersion 因为「定位自动选中地区」递增时，强制重建 FilterBar
              // 让它的内部 selected 重新读取最新 filterParams。
              key: ValueKey('filterBar_$_filterBarVersion'),
              style: FilterBarStyle(
                dropdownGap: 10.h,
                drawerWidth: 600.w, // 设置 drawer 宽度为 600.w（使用 screenutil 适配）
                iconSize: 24.sp,
                // 横滑模式下让每个按钮的横向间距小一点，更紧凑
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              // 顶部主筛选项 4 个，启用横向滚动避免文字被挤压
              scrollable: true,
              drawerFilters: _buildDrawerFilters(context),
              baseDate: _getCurrentTabDate(),
              filters: [
                FilterOption(
                  key: 'areaId',
                  title: S.of(context).about_movieShowList_dropdown_area,
                  type: FilterType.single, // 单选模式
                  nested: true,
                  icon: Icons.location_on_rounded,
                  values: [
                    FilterValue(
                        id: '',
                        name: S
                            .of(context)
                            .about_components_showTimeList_all), // 添加"全部"选项
                    ...areaTreeList
                        .where((item) =>
                            item.name != null && item.name!.isNotEmpty)
                        .map((item) => convertToFilterValue(item))
                        .toList(),
                  ],
                ),
                // 品牌（单选，cinema.brand_id = ?）
                FilterOption(
                  key: 'brandId',
                  title: S.of(context).about_movieShowList_dropdown_brand,
                  type: FilterType.single,
                  icon: Icons.business_rounded,
                  values: [
                    FilterValue(
                        id: '',
                        name: S.of(context).about_components_showTimeList_all),
                    ...brandList
                        .where((item) =>
                            item.id != null &&
                            item.name != null &&
                            item.name!.isNotEmpty)
                        .map((item) => FilterValue(
                            id: item.id.toString(), name: item.name!)),
                  ],
                ),
                FilterOption(
                  key: 'dimensionType',
                  title:
                      S.of(context).about_movieShowList_dropdown_dimensionType,
                  icon: Icons.visibility_rounded,
                  type: FilterType.single,
                  values: [
                    FilterValue(
                        id: '',
                        name: S.of(context).about_components_showTimeList_all),
                    ...dimensionList
                        .where((item) =>
                            item.name != null && item.name!.isNotEmpty)
                        .map((item) => FilterValue(
                            id: item.code.toString(), name: item.name!)),
                  ],
                ),
                FilterOption(
                  key: 'specId',
                  title: S.of(context).about_movieShowList_dropdown_screenSpec,
                  icon: Icons.movie_filter_rounded,
                  values: [
                    FilterValue(
                        id: '',
                        name: S
                            .of(context)
                            .about_components_showTimeList_all), // 添加"全部"选项
                    // 2D/3D 已在 V21 迁移中从 cinema_spec 字典移除（dimensionType 字典承担），
                    // 这里不再需要客户端过滤——直接展示后端返回的所有规格。
                    ...cinemaSpec
                        .where(
                            (item) => item.name != null && item.name!.isNotEmpty)
                        .map((item) => FilterValue(
                            id: item.id.toString(), name: item.name!)),
                  ],
                ),
              ],
              initialSelected: filterParams, // 只初始化时传递
              onConfirm: (selected) {
                setState(() {
                  filterParams = selected;
                });
                print(selected);
                print('--------------------------------');
                getData();
              },
            ),
          ),
          // 当前所在地（反向地理编码完成后显示）—— 暂时隐藏，
          // 保留 _buildLocationBar / _currentFullAddressText / _currentLocalityText
          // 这几个 helper，以后想开启时去掉这一行注释即可。
          // _buildLocationBar(),
          // 当前 tab（当日）的影院/场次数量摘要条
          _buildSummaryBar(),
          SizedBox(height: 10.h),
          Expanded(
            child: AppErrorWidget(
              loading: loading,
              error: error,
              onRetry: () => getData(refresh: true),
              child: EasyRefresh.builder(
                controller: easyRefreshController,
                header: customHeader(context),
                footer: customFooter(context),
                onRefresh: () async {
                  await getData(refresh: true);
                },
                onLoad: () async {
                  await getData(page: currentPage + 1);
                },
                childBuilder: (context, physics) {
                  if (data.isEmpty || _tabController == null || !mounted) {
                    // 没有数据时，使用 SingleChildScrollView 确保可以下拉刷新
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 300.h,
                        padding: EdgeInsets.symmetric(vertical: 100.h),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.movie_creation_outlined,
                                size: 64.sp,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                S
                                    .of(context)
                                    .about_components_showTimeList_noData,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  if (!mounted || _tabController == null) {
                    return const SizedBox.shrink();
                  }
                  return TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),
                    children: data.map((item) {
                      return ListView.builder(
                        physics: physics,
                        itemCount: item.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final children = item.data![index];
                          return GestureDetector(
                            onTap: () {
                              Analytics.instance.logFunnel(Ev.showtimeDetailView, {
                                P.movieId: widget.id,
                                P.cinemaId: children.cinemaId,
                              });
                              // 把当前选中的日期带过去，详情页据此把日期 tab 切到对应位置；
                              // 避免用户在 ShowTimeList 选了 6/04，进入详情后又跳回第 1 个 tab。
                              final currentDate = item.date;
                              context.pushNamed('showTimeDetail',
                                  pathParameters: {
                                    "id": '${widget.id}'
                                  },
                                  queryParameters: {
                                    "movieId": widget.id,
                                    "cinemaId": '${children.cinemaId}',
                                    if (currentDate != null && currentDate.isNotEmpty)
                                      "date": currentDate,
                                    if (widget.reReleaseId != null && widget.reReleaseId!.isNotEmpty)
                                      "reReleaseId": widget.reReleaseId!,
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          children.cinemaName ?? '',
                                          style: TextStyle(
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF323233),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      // 收藏星标：收藏的影院会在排片中置顶
                                      if (children.cinemaId != null)
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => _toggleFavorite(children),
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 8.w),
                                            child: Icon(
                                              children.favorite == true
                                                  ? Icons.star_rounded
                                                  : Icons.star_border_rounded,
                                              size: 40.sp,
                                              color: children.favorite == true
                                                  ? const Color(0xFFFFB300)
                                                  : Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                      // 当日该影院的可见场次数徽标
                                      // 与 _buildShowTimeInfo 的过滤口径一致（open != false）
                                      Builder(builder: (ctx) {
                                        final visibleCount = (children
                                                    .showTimes ??
                                                const <ShowTime>[])
                                            .where((s) => s.open != false)
                                            .length;
                                        if (visibleCount == 0) {
                                          return const SizedBox.shrink();
                                        }
                                        return Padding(
                                          padding:
                                              EdgeInsets.only(right: 8.w),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1989FA)
                                                  .withValues(alpha: 0.08),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .about_movieShowList_cinemaSessionCount(
                                                      visibleCount),
                                              style: TextStyle(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    const Color(0xFF1989FA),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                      // 特典标识（该影院下任意场次有特典时显示）
                                      if ((children.showTimes ?? [])
                                          .any((st) => st.hasBenefits == true))
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.w),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurple
                                                  .withValues(alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                              border: Border.all(
                                                  color: Colors.deepPurple
                                                      .withValues(alpha: 0.4)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('🎁',
                                                    style: TextStyle(
                                                        fontSize: 18.sp)),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  S
                                                      .of(context)
                                                      .about_components_showTimeList_benefitBadge,
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    color: Colors
                                                        .deepPurple.shade700,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      // 网友反馈：今日已领完（轻展示）
                                      if ((children.showTimes ?? []).any((st) =>
                                          st.benefitFeedbackSoldOut == true))
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.w),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: Colors.red
                                                  .withValues(alpha: 0.12),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('🔴',
                                                    style: TextStyle(
                                                        fontSize: 16.sp)),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  S
                                                      .of(context)
                                                      .showTime_benefit_feedback_soldOut,
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color:
                                                          Colors.red.shade700,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      SizedBox(width: 12.w),
                                      // 显示距离
                                      if (children.distance != null)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1989FA)
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.location_on_outlined,
                                                size: 16.sp,
                                                color: const Color(0xFF1989FA),
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                LocationUtil
                                                    .formatDistanceLocalized(
                                                        context,
                                                        children.distance!),
                                                style: TextStyle(
                                                  fontSize: 22.sp,
                                                  color:
                                                      const Color(0xFF1989FA),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20.sp,
                                        color: Colors.grey.shade400,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  // 点击地址打开谷歌地图（用地址搜索，不做地理编码）。
                                  // 内层 GestureDetector 会吃掉点击，不会冒泡到卡片的进详情。
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      openMap(
                                        latitude: children.cinemaLatitude,
                                        longitude: children.cinemaLongitude,
                                        address: children.cinemaAddress,
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.place_outlined,
                                          size: 24.sp,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 6.w),
                                        Expanded(
                                          child: Text(
                                            children.cinemaAddress ?? '',
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              color: Colors.grey.shade600,
                                              height: 1.4,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  // 场次信息（包含选座状态）
                                  _buildShowTimeInfo(children),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 获取版本名称
  /// 收藏 / 取消收藏排片中的影院。未登录则引导去登录页。
  Future<void> _toggleFavorite(Cinema cinema) async {
    final cinemaId = cinema.cinemaId;
    if (cinemaId == null) return;
    if (!await FavoriteCinemaService.instance.isLoggedIn()) {
      if (mounted) context.pushNamed('login');
      return;
    }
    final prev = cinema.favorite == true;
    setState(() => cinema.favorite = !prev);
    final result = await FavoriteCinemaService.instance.toggle(cinemaId);
    if (!mounted) return;
    setState(() => cinema.favorite = result ?? prev);
    if (result != null) {
      Analytics.instance.logEvent(Ev.cinemaFavoriteToggle, {
        P.cinemaId: cinemaId,
        P.type: result ? 'on' : 'off',
      });
    }
  }

  // 构建场次信息
  Widget _buildShowTimeInfo(Cinema children) {
    // 过滤已禁用的场次（open == false）
    final availableShowTimes =
        (children.showTimes ?? []).where((s) => s.open != false).toList();
    if (availableShowTimes.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 20.sp,
              color: Colors.grey.shade600,
            ),
            SizedBox(width: 8.w),
            Text(
              S.of(context).about_components_showTimeList_noShowTimeInfo,
              style: TextStyle(
                fontSize: 22.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // // 分割线
        // Container(
        //   height: 1.h,
        //   margin: EdgeInsets.only(bottom: 12.h),
        //   color: Colors.grey.shade200,
        // ),
        // 横向滚动的场次卡片：用 IntrinsicHeight + CrossAxisAlignment.stretch，
        // 让同一行所有卡片对齐到最高卡片的高度，避免底部 chip 行数不同导致参差不齐。
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: availableShowTimes.map((showTime) {
                return Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: _buildShowTimeCard(showTime),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // 构建场次卡片
  Widget _buildShowTimeCard(ShowTime showTime) {
    // 2D / 3D 已在 V21 迁移中从 cinema_spec 字典移除（dimensionType 字典承担），
    // 后端 specNames 不会再返回这两个值——直接原样渲染所有特殊规格（IMAX / MX4D / Dolby 等）。
    final filteredSpecNames = showTime.specNames ?? const <String>[];

    // 座位/售票状态决策：
    //   1) 自家有 seat 表数据（totalSeats > 0）→ 走"剩余座位 / 紧张 / 售罄"逻辑；
    //   2) 否则（外部预约场次：TOHO / T・ジョイ 等）→ 用爬虫透传的 saleStatus 字段；
    //   3) 两者都没有 → 不显示状态徽标，按"可购买"对待。
    final int availableSeats = showTime.availableSeats ?? 0;
    final int totalSeats = showTime.totalSeats ?? 0;
    final bool hasSeatInfo = totalSeats > 0;
    final String? saleStatus = showTime.saleStatus;

    Color seatStatusColor = Colors.transparent;
    String seatStatusText = '';
    IconData seatStatusIcon = Icons.event_seat;
    bool showStatusBadge = false;
    // 是否允许跳转影院官网/选座：pre_sale / sale_ended / closed / unknown 这几种官网都买不了，
    // 跳过去只会看到 ERR-2002 之类错误页，所以 app 端直接 toast 提示用户。
    bool isPurchasable = true;

    if (hasSeatInfo) {
      showStatusBadge = true;
      if (availableSeats == 0) {
        seatStatusColor = Colors.red;
        seatStatusText =
            S.of(context).about_components_showTimeList_seatStatus_soldOut;
      } else if (availableSeats <= totalSeats * 0.2) {
        seatStatusColor = Colors.orange;
        seatStatusText =
            S.of(context).about_components_showTimeList_seatStatus_limited;
      } else {
        seatStatusColor = Colors.green;
        seatStatusText =
            S.of(context).about_components_showTimeList_seatStatus_available;
      }
    } else if (saleStatus != null && saleStatus.isNotEmpty) {
      // 爬虫透传的售票状态（on_sale / few / sold_out / pre_sale / sale_ended / closed / unknown）
      switch (saleStatus) {
        case 'on_sale':
          showStatusBadge = true;
          seatStatusColor = Colors.green;
          seatStatusText = S
              .of(context)
              .about_components_showTimeList_seatStatus_available;
          break;
        case 'few':
          showStatusBadge = true;
          seatStatusColor = Colors.orange;
          seatStatusText =
              S.of(context).about_components_showTimeList_seatStatus_limited;
          break;
        case 'sold_out':
          showStatusBadge = true;
          seatStatusColor = Colors.red;
          seatStatusText =
              S.of(context).about_components_showTimeList_seatStatus_soldOut;
          // 已售罄，仍允许跳官网（用户可能想确认）
          break;
        case 'pre_sale':
          showStatusBadge = true;
          isPurchasable = false;
          seatStatusColor = const Color(0xFF1989FA);
          seatStatusIcon = Icons.schedule_outlined;
          seatStatusText =
              S.of(context).about_components_showTimeList_seatStatus_preSale;
          break;
        case 'sale_ended':
          showStatusBadge = true;
          isPurchasable = false;
          seatStatusColor = Colors.grey;
          seatStatusIcon = Icons.do_not_disturb_alt_outlined;
          seatStatusText = S
              .of(context)
              .about_components_showTimeList_seatStatus_saleEnded;
          break;
        case 'closed':
          showStatusBadge = true;
          isPurchasable = false;
          seatStatusColor = Colors.grey;
          seatStatusIcon = Icons.block_outlined;
          seatStatusText =
              S.of(context).about_components_showTimeList_seatStatus_closed;
          break;
        case 'unknown':
        default:
          // 状态未知：多数情况是"販売期間外/販売開始前/会員先行販売"——官网买不了，
          // 用灰色问号徽标显式提示，同时禁止跳转。
          showStatusBadge = true;
          isPurchasable = false;
          seatStatusColor = Colors.grey;
          seatStatusIcon = Icons.help_outline_rounded;
          seatStatusText =
              S.of(context).about_components_showTimeList_seatStatus_unknown;
          break;
      }
    }

    // 计算时长
    String? durationText;
    if (showTime.startTime != null && showTime.endTime != null) {
      final duration = showTime.endTime!.difference(showTime.startTime!);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (hours > 0) {
        durationText = S
            .of(context)
            .movieDetail_detail_duration_hoursMinutes(hours, minutes);
      } else {
        durationText =
            '${minutes}${S.of(context).movieDetail_detail_duration_minutes}';
      }
    }

    return GestureDetector(
      onTap: () {
        // 场次点击：result 记录这次点击的去向，便于分析「点了多少 / 多少不可购 / 多少跳官网」。
        final url = showTime.reservationUrl;
        final String clickResult = !isPurchasable
            ? 'not_purchasable'
            : (url != null && url.isNotEmpty ? 'open_url' : 'no_url');
        Analytics.instance.logFunnel(Ev.showtimeClick, {
          P.showtimeId: showTime.id,
          P.movieId: widget.id,
          P.saleStatus: saleStatus,
          P.type: clickResult,
        });
        // 官网未开放购票（pre_sale / sale_ended / closed / unknown）—— 不跳转，
        // 直接 toast 提示用户，避免跳到官网看到 ERR-2002 之类的错误页。
        if (!isPurchasable) {
          ToastService.showToast(
            seatStatusText.isNotEmpty
                ? '${S.of(context).about_components_showTimeList_notPurchasableHint}（$seatStatusText）'
                : S
                    .of(context)
                    .about_components_showTimeList_notPurchasableHint,
            type: ToastType.warning,
          );
          return;
        }
        if (url != null && url.isNotEmpty) {
          launchURL(url);
        } else {
          ToastService.showToast(
            S.of(context).showTimeDetail_noOnlineTicket,
            type: ToastType.warning,
          );
        }

        // 原选座页面跳转先保留，后续恢复自有选座时可直接启用。
        // if (showTime.id != null && showTime.theaterHallId != null) {
        //   context.pushNamed(
        //     'selectSeat',
        //     queryParameters: {
        //       "id": '${showTime.id}',
        //       "theaterHallId": '${showTime.theaterHallId}'
        //     }
        //   );
        // }
      },
      child: Container(
        width: 240.w,
        constraints: BoxConstraints(
          minHeight: 200.h, // 设置最小高度，确保卡片高度统一
        ),
        decoration: BoxDecoration(
          // 不可购买的场次用浅冷灰底，与可购买的白底形成明显对比；
          // 并去掉投影，让卡片看起来"不可点"
          color: isPurchasable ? Colors.white : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(16.r),
          border: isPurchasable
              ? null
              : Border.all(
                  color: const Color(0xFFE3E5EA),
                  width: 1,
                ),
          boxShadow: isPurchasable
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10.r,
                    offset: Offset(0, 4.r),
                  ),
                ]
              : null,
        ),
        margin: EdgeInsets.only(bottom: 10.h),
        // 不再用 mainAxisSize.min——交由父级 IntrinsicHeight 决定高度，
        // 内容从顶部往下排，多余的高度自动留白在底部，保证同一行卡片视觉对齐。
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 顶部时间区域（带渐变背景）
            // 可购买：蓝色渐变 + 黑色时间；不可购买：灰色渐变 + 灰色时间字
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isPurchasable
                      ? [
                          const Color(0xFF1989FA).withValues(alpha: 0.1),
                          const Color(0xFF1989FA).withValues(alpha: 0.05),
                        ]
                      : [
                          const Color(0xFFE9EBEE),
                          const Color(0xFFF1F3F5),
                        ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 开始时间和座位状态（同一行，右对齐）
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Obx(() => Text(
                              DateFormatUtil.formatShowTime(
                                dateTime: showTime.startTime,
                                use30HourFormat:
                                    timeFormatController.use30HourFormat.value,
                                baseDate: _getCurrentTabDate(),
                              ),
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w700,
                                color: isPurchasable
                                    ? Colors.black
                                    : const Color(0xFFB0B5BD),
                                height: 1.2,
                                decoration: isPurchasable
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough,
                                decorationColor: const Color(0xFFB0B5BD),
                                decorationThickness: 1.5,
                              ),
                            )),
                      ),
                      // 座位/售票状态徽标：
                      //   - 可购买：仅 icon 方块，节省空间；
                      //   - 不可购买：扩展为「icon + 文字」胶囊，让用户一眼看出原因。
                      if (showStatusBadge)
                        Container(
                          margin: EdgeInsets.only(left: 12.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: isPurchasable ? 0 : 8.w,
                              vertical: 0),
                          decoration: BoxDecoration(
                            color: seatStatusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: seatStatusColor.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Icon(
                                  seatStatusIcon,
                                  size: 24.sp,
                                  color: seatStatusColor,
                                ),
                              ),
                              if (!isPurchasable && seatStatusText.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(right: 4.w),
                                  child: Text(
                                    seatStatusText,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: seatStatusColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // 结束时间和时长
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 结束时间（左对齐）
                      Obx(() => Text(
                            DateFormatUtil.formatShowTime(
                              dateTime: showTime.endTime,
                              use30HourFormat:
                                  timeFormatController.use30HourFormat.value,
                              baseDate: _getCurrentTabDate(),
                            ),
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: isPurchasable
                                  ? Colors.grey.shade600
                                  : const Color(0xFFC3C8D0),
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      // 时长（右对齐）
                      if (durationText != null)
                        Text(
                          durationText,
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // 中间内容区域
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 规格+2D/3D、版本、字幕信息（合并到同一行 Wrap）
                  if (filteredSpecNames.isNotEmpty ||
                      showTime.dimensionType != null ||
                      showTime.versionCode != null ||
                      (showTime.subtitleNames != null &&
                          showTime.subtitleNames!.isNotEmpty))
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // 规格信息：规格名在前、2D/3D 在后，合并为一块如 "IMAX 3D"
                        if (filteredSpecNames.isNotEmpty)
                          ...filteredSpecNames.map((name) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1989FA)
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: const Color(0xFF1989FA)
                                        .withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: const Color(0xFF1989FA),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (showTime.dimensionType != null) ...[
                                      SizedBox(width: 4.w),
                                      Dict(
                                        code: showTime.dimensionType,
                                        name: 'dimensionType',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: const Color(0xFF1989FA),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ))
                        else if (showTime.dimensionType != null)
                          // 仅有 2D/3D 无规格时单独显示（字典 dimensionType）
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7232DD)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: const Color(0xFF7232DD)
                                    .withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Dict(
                                  code: showTime.dimensionType,
                                  name: 'dimensionType',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: const Color(0xFF7232DD),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // 版本信息（如果顶部没有显示，则在这里显示）
                        if (showTime.versionCode != null)
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: double.infinity, // 限制最大宽度，避免过长
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Colors.orange.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Dict(
                                    code: showTime.versionCode,
                                    name: 'dubbingVersion',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // 字幕版徽标：直接显示具体字幕语言（如「English字幕」「日本語字幕」），
                        // 多语言时用「、」连接。点击仍弹 Tooltip 说明是原声 + 字幕版。
                        if (showTime.subtitleNames != null &&
                            showTime.subtitleNames!.isNotEmpty)
                          Tooltip(
                            message: S
                                .of(context)
                                .about_components_showTimeList_subtitleHint(
                                    showTime.subtitleNames!.join('、')),
                            triggerMode: TooltipTriggerMode.tap,
                            preferBelow: true,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE91E63)
                                    .withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: const Color(0xFFE91E63)
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    S
                                        .of(context)
                                        .about_components_showTimeList_subtitleChipWith(
                                            showTime.subtitleNames!.join('、')),
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: const Color(0xFFE91E63),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
