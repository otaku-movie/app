import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../generated/l10n.dart';
import 'DrawerFilterChip.dart';

class FilterValue {
  final String id;
  final String name;
  final List<FilterValue>? children;
  final int? count; // 数量

  FilterValue({required this.id, required this.name, this.children, this.count});
}

/// 筛选类型枚举
enum FilterType {
  /// 普通按钮（多选）
  normal,
  /// 普通按钮（单选）
  single,
  /// 时间范围筛选（使用滑块选择时间范围）
  timeRange,
  /// 开关类型（Switch，只有选中和未选中两种状态）
  switch_,
}

/// Drawer 筛选项的显示配置
class DrawerFilterDisplayConfig {
  /// 标题文字（如果为 null，则使用 FilterOption 的 title）
  final String? title;
  /// 图标（如果为 null，则使用 FilterOption 的 icon）
  final IconData? icon;
  /// 标题文字样式
  final TextStyle? titleStyle;
  /// 图标大小
  final double? iconSize;
  /// 图标颜色（如果为 null，则使用默认颜色）
  final Color? iconColor;
  /// 图标背景颜色（仅用于 Switch 类型）
  final Color? iconBackgroundColor;

  const DrawerFilterDisplayConfig({
    this.title,
    this.icon,
    this.titleStyle,
    this.iconSize,
    this.iconColor,
    this.iconBackgroundColor,
  });
}

class FilterOption {
  final String key;
  final String title;
  final List<FilterValue> values;
  final bool nested;
  final IconData? icon;
  final FilterType? type; // 筛选类型：normal 多选，single 单选，timeRange 时间范围，switch_ 开关，null 默认为 normal（多选）
  final bool? use30HourFormat; // 时间范围筛选是否使用30小时制（默认false，即24小时制）
  /// Switch 类型：选中时的值（如果为 null，则使用布尔值 true）
  final String? switchOnValue;
  /// Switch 类型：未选中时的值（如果为 null，则使用布尔值 false）
  final String? switchOffValue;
  /// Drawer 筛选项的显示配置（仅用于 drawer 中的筛选项）
  final DrawerFilterDisplayConfig? drawerDisplayConfig;

  FilterOption({
    required this.key,
    required this.title,
    List<FilterValue>? values,
    this.nested = false,
    this.icon,
    this.type,
    this.use30HourFormat,
    this.switchOnValue,
    this.switchOffValue,
    this.drawerDisplayConfig,
  }) : values = values ?? []; // Switch 类型可以为空
  
  /// 判断是否为多选模式
  bool get isMultiSelect {
    return type != FilterType.single;
  }
}

class FilterBarStyle {
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final double? borderRadius;
  final double? borderWidth;
  final double? iconSize;
  final Color? selectedIconColor;
  final Color? unselectedIconColor;
  final double? textSize;
  final FontWeight? selectedTextWeight;
  final FontWeight? unselectedTextWeight;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? selectedArrowColor;
  final Color? unselectedArrowColor;
  final double? arrowSize;
  final Color? badgeBackgroundColor;
  final Color? selectedBadgeBackgroundColor;
  final Color? badgeTextColor;
  final Color? selectedBadgeTextColor;
  final double? badgeTextSize;
  final double? badgeBorderRadius;
  final double? dropdownGap;
  final double? drawerWidth; // Drawer 宽度，如果为 null 则使用默认值（屏幕宽度的80%，最大600）
  final double? drawerTopOffset; // Drawer top 偏移量，用于调整 drawer 顶部位置，默认 0
  final Color? drawerSelectedColor; // Drawer 选中颜色，默认蓝色

  const FilterBarStyle({
    this.height,
    this.padding,
    this.margin,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.borderRadius,
    this.borderWidth,
    this.iconSize,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.textSize,
    this.selectedTextWeight,
    this.unselectedTextWeight,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.selectedArrowColor,
    this.unselectedArrowColor,
    this.arrowSize,
    this.badgeBackgroundColor,
    this.selectedBadgeBackgroundColor,
    this.badgeTextColor,
    this.selectedBadgeTextColor,
    this.badgeTextSize,
    this.badgeBorderRadius,
    this.dropdownGap,
    this.drawerWidth,
    this.drawerTopOffset,
    this.drawerSelectedColor,
  });
}

class FilterBar extends StatefulWidget {
  final List<FilterOption> filters;
  final Map<String, dynamic> initialSelected;
  final void Function(Map<String, dynamic> selected) onConfirm;
  final FilterBarStyle? style;
  /// 放到抽屉里的筛选项列表
  final List<FilterOption>? drawerFilters;
  /// 基准日期，用于时间范围筛选（默认为当前日期）
  final DateTime? baseDate;

  const FilterBar({
    super.key,
    required this.filters,
    this.initialSelected = const {},
    required this.onConfirm,
    this.style,
    this.drawerFilters,
    this.baseDate,
  });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> with TickerProviderStateMixin {
  late Map<String, dynamic> selected;
  OverlayEntry? _overlayEntry;
  late List<GlobalKey> _filterKeys;
  List<String> _tempSelected = [];
  int? _activeFilterIndex;
  late List<AnimationController> _arrowControllers;
  void Function(void Function())? _overlayRebuild;
  bool _isConfirming = false; // 添加确认状态标志

  // 三级选中ID
  String? selected1;
  String? selected2;
  String? selected3;
  TabController? _nestedTabController;

  // Drawer 相关
  bool _isDrawerOpen = false;
  OverlayEntry? _drawerOverlayEntry;
  GlobalKey _drawerButtonKey = GlobalKey();
  Map<String, dynamic> _drawerSelected = {}; // Drawer 中的临时选中状态

  @override
  void initState() {
    super.initState();
    selected = Map.from(widget.initialSelected);
    for (var filter in widget.filters) {
      selected.putIfAbsent(filter.key, () => []);
    }
    // 初始化 drawer 筛选项的选中状态
    if (widget.drawerFilters != null) {
      for (var filter in widget.drawerFilters!) {
        selected.putIfAbsent(filter.key, () => []);
      }
    }
    _filterKeys = List.generate(widget.filters.length, (_) => GlobalKey());
    _arrowControllers = List.generate(
      widget.filters.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150), // 减少动画时间
        lowerBound: 0,
        upperBound: 1, // 旋转180度
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerFilters = widget.drawerFilters ?? [];
    final drawerFilterKeys = drawerFilters.map((f) => f.key).toSet();

    return PopScope(
      canPop: _overlayEntry == null && !_isDrawerOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (_overlayEntry != null) {
            _hideDropdown();
          } else if (_isDrawerOpen) {
            _closeDrawer();
          }
        }
      },
      child: Row(
        children: [
          // 主筛选栏的筛选项（排除 drawer 中的筛选项）
          ...List.generate(widget.filters.length, (index) {
            final filter = widget.filters[index];
            // 如果这个筛选项在 drawer 中，跳过
            if (drawerFilterKeys.contains(filter.key)) {
              return const SizedBox.shrink();
            }
            final display = _getDisplayText(filter);
            final isActive = _activeFilterIndex == index;
            final hasSelection = display.isNotEmpty;

            return Expanded(
              child: GestureDetector(
                key: _filterKeys[index],
                onTap: () {
                  if (_overlayEntry != null) {
                    if (_activeFilterIndex == index) {
                      _hideDropdown();
                    } else {
                      if (mounted) {
                        setState(() {
                          _activeFilterIndex = index;
                          // 根据是否多选处理初始值
                          final currentValue = selected[filter.key];
                          if (filter.isMultiSelect) {
                            _tempSelected = List.from(currentValue ?? []);
                          } else {
                            // 单选模式：从单个值转换为数组格式
                            if (currentValue != null && currentValue is! List) {
                              _tempSelected = [currentValue.toString()];
                            } else if (currentValue is List && currentValue.isNotEmpty) {
                              _tempSelected = [currentValue.first.toString()];
                            } else {
                              _tempSelected = [];
                            }
                          }
                          for (int i = 0; i < _arrowControllers.length; i++) {
                            if (i == index) {
                              _arrowControllers[i].forward();
                            } else {
                              _arrowControllers[i].reverse();
                            }
                          }
                        });
                      }
                      _overlayRebuild?.call(() {});
                    }
                  } else {
                    _showDropdown(filter, index);
                  }
                },
                child: _buildFilterButton(filter, index, isActive, hasSelection, display),
              ),
            );
          }),
          // Drawer 按钮（如果有抽屉筛选项）
          if (drawerFilters.isNotEmpty)
            _buildDrawerButton(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 清理下拉菜单，但不调用setState
    if (_activeFilterIndex != null && _activeFilterIndex! < _arrowControllers.length) {
      _arrowControllers[_activeFilterIndex!].reverse();
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
    _activeFilterIndex = null;
    
    _overlayRebuild = null; // 清除回调引用，防止内存泄漏
    _nestedTabController?.dispose();
    _nestedTabController = null;
    for (var c in _arrowControllers) {
      c.dispose();
    }
    _drawerOverlayEntry?.remove();
    _drawerOverlayEntry = null;
    super.dispose();
  }

  void _showDropdown(FilterOption filter, int index) {
    // 立即更新状态，提供即时反馈
    if (!mounted) return;
    final currentValue = selected[filter.key];
    if (filter.isMultiSelect) {
      // 多选模式：保持数组格式
      _tempSelected = List.from(currentValue ?? []);
    } else {
      // 单选模式：从单个值转换为数组格式（用于下拉菜单内部处理）
      if (currentValue != null && currentValue is! List) {
        _tempSelected = [currentValue.toString()];
      } else if (currentValue is List && currentValue.isNotEmpty) {
        // 兼容旧数据格式（数组），取第一个值
        _tempSelected = [currentValue.first.toString()];
      } else {
        _tempSelected = [];
      }
    }
    _activeFilterIndex = index;
    _arrowControllers[index].forward();

    // 立即更新UI状态
    if (mounted) {
      setState(() {});
    }

    // 使用微任务而不是PostFrameCallback，更快响应
    Future.microtask(() {
      if (!mounted) return;
      
      final key = _filterKeys[index];
      final ctx = key.currentContext;
      if (ctx == null) return;
      final renderBox = ctx.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      if (filter.nested) {
        // ⚠️ 清空旧状态
        selected1 = null;
        selected2 = null;
        selected3 = null;

        // ⚠️ 查找已有选中项（如果有）
        final currentValue = selected[filter.key];
        String? lastId;
        if (filter.isMultiSelect) {
          // 多选模式：从数组中取最后一个
          if (currentValue is List && currentValue.isNotEmpty) {
            lastId = currentValue.last.toString();
          }
        } else {
          // 单选模式：从单个值获取
          if (currentValue != null && currentValue is! List) {
            lastId = currentValue.toString();
          } else if (currentValue is List && currentValue.isNotEmpty) {
            // 兼容旧数据格式
            lastId = currentValue.first.toString();
          }
        }
        if (lastId != null) {
          _resolveSelectedIds(filter.values, lastId);
        }

        // ⚠️ 新建 TabController，并强制 index = 0
        _nestedTabController?.dispose();
        _nestedTabController = TabController(length: 3, vsync: this, initialIndex: 0);
        _nestedTabController?.addListener(() {
          if (mounted) {
            _overlayRebuild?.call(() {});
          }
        });
      }

      _overlayEntry = _createOverlayEntry(filter, offset, size, index);
      Overlay.of(context).insert(_overlayEntry!);
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _confirmSelection(FilterOption filter) {
    if (_isConfirming) return; // 防止重复确认
    _isConfirming = true;
    
    if (filter.nested) {
      // 嵌套筛选确认逻辑
      // 如果第一级选择了"全部"（id为空），清空该筛选
      if (selected1 != null && selected1 == '') {
        selected[filter.key] = [];
      } else {
        List<String> selectedIds = [];
        if (selected1 != null) selectedIds.add(selected1!);
        if (selected2 != null) selectedIds.add(selected2!);
        if (selected3 != null) selectedIds.add(selected3!);
        
        selected[filter.key] = selectedIds;
      }
    } else {
      // 普通筛选确认逻辑
      if (filter.isMultiSelect) {
        selected[filter.key] = List<String>.from(_tempSelected);
      } else {
        // 单选模式：返回单个值（字符串）或 null
        selected[filter.key] = _tempSelected.isNotEmpty ? _tempSelected.first : null;
      }
    }
    
    // 先隐藏下拉菜单，避免闪烁
    _hideDropdown();
    
    // 延迟执行回调，确保UI更新完成后再触发父组件状态更新
    Future.microtask(() {
      widget.onConfirm(selected);
      _isConfirming = false; // 重置确认状态
    });
  }

  bool _canConfirm(FilterOption filter) {
    if (filter.nested) {
      // 嵌套筛选：如果第一级选择了"全部"（id为空），可以直接确认
      if (selected1 != null && selected1 == '') {
        return true;
      }
      // 否则至少需要选择到第二级
      return selected2 != null;
    } else {
      // 普通筛选至少需要选择一个选项
      return _tempSelected.isNotEmpty;
    }
  }

  void _resolveSelectedIds(List<FilterValue> values, String targetId) {
    for (var v1 in values) {
      if (v1.id == targetId) {
        selected1 = v1.id;
        selected2 = null;
        selected3 = null;
        return;
      }
      if (v1.children != null) {
        for (var v2 in v1.children!) {
          if (v2.id == targetId) {
            selected1 = v1.id;
            selected2 = v2.id;
            selected3 = null;
            return;
          }
          if (v2.children != null) {
            for (var v3 in v2.children!) {
              if (v3.id == targetId) {
                selected1 = v1.id;
                selected2 = v2.id;
                selected3 = v3.id;
                return;
              }
            }
          }
        }
      }
    }
    // 如果没找到，清空
    selected1 = selected2 = selected3 = null;
  }

  void _hideDropdown() {
    if (_activeFilterIndex != null && _activeFilterIndex! < _arrowControllers.length) {
      _arrowControllers[_activeFilterIndex!].reverse();
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
    _activeFilterIndex = null;
    // 只在必要时调用setState，避免不必要的重建
    if (mounted) {
      setState(() {});
    }
  }

  OverlayEntry _createOverlayEntry(FilterOption filter, Offset offset, Size size, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final style = widget.style ?? const FilterBarStyle();
    final gap = style.dropdownGap ?? 8.h; // 弹出层与筛选按钮之间的间距，可从外部控制

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 遮罩只覆盖筛选框下方的区域，不遮挡header和筛选框
            Positioned(
              left: 0,
              top: offset.dy + size.height + gap,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _hideDropdown,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),
            // 弹窗内容
            Positioned(
              left: 0,
              top: offset.dy + size.height + gap,
              width: screenWidth,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                    minHeight: 100,
                  ),
                  child: StatefulBuilder(
                    builder: (context, overlaySetState) {
                      _overlayRebuild = (fn) {
                        if (mounted) {
                          overlaySetState(fn);
                        }
                      };
                      final activeFilter = widget.filters[_activeFilterIndex ?? index];

                      if (activeFilter.nested) {
                        return _buildNestedFilterPopup(activeFilter);
                      }

                      // 普通单级筛选弹窗
                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: activeFilter.values.map((value) {
                                final isSelected = _tempSelected.contains(value.id);
                                return ListTile(
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(value.name,
                                            style: TextStyle(
                                                fontSize: 28.sp,
                                                color: isSelected ? const Color(0xFF1989FA) : Colors.black87)),
                                      ),
                                      if (value.count != null) ...[
                                        SizedBox(width: 8.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Text(
                                            '${value.count}',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF1989FA)) : null,
                                  onTap: () {
                                    _overlayRebuild?.call(() {
                                      if (activeFilter.isMultiSelect) {
                                        isSelected ? _tempSelected.remove(value.id) : _tempSelected.add(value.id);
                                      } else {
                                        _tempSelected = [value.id];
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey.shade200),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.grey.shade200,
                                      foregroundColor: Colors.black87,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.r),
                                      ),
                                    ),
                                    onPressed: () {
                                      _overlayRebuild?.call(() => _tempSelected.clear());
                                    },
                                    child: Text(S.of(context).common_components_filterBar_reset),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _canConfirm(activeFilter) ? const Color(0xFF1989FA) : Colors.grey.shade300,
                                      foregroundColor: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.r),
                                      ),
                                    ),
                                    onPressed: _canConfirm(activeFilter) ? () => _confirmSelection(activeFilter) : null,
                                    child: Text(S.of(context).common_components_filterBar_confirm),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildNestedFilterPopup(FilterOption filter) {
  final level1List = filter.values;
  final level2List = (selected1 != null)
      ? level1List.firstWhere((e) => e.id == selected1).children ?? []
      : [];
  final level3List = (selected2 != null)
      ? level2List.firstWhere((e) => e.id == selected2).children ?? []
      : [];

  bool hasLevel2 = level2List.isNotEmpty;
  bool hasLevel3 = level3List.isNotEmpty;

  return Column(
    children: [
      if (_nestedTabController != null) ...[
        TabBar(
          controller: _nestedTabController,
          isScrollable: true,
          labelColor: const Color(0xFF1989FA),
          unselectedLabelColor: Colors.black,
          indicatorColor: const Color(0xFF1989FA),
          indicatorWeight: 3,
          dividerColor: Colors.grey.shade200,
          onTap: (index) {
            // 禁止点击未解锁的Tab
            if (index == 1 && (!hasLevel2 || selected1 == null)) {
              _nestedTabController?.animateTo(0);
              return;
            }
            if (index == 2 && (!hasLevel3 || selected2 == null)) {
              _nestedTabController?.animateTo(hasLevel2 && selected1 != null ? 1 : 0);
              return;
            }
          },
          tabs: <Widget>[
            Tab(text: selected1 != null ? _getNameById(selected1!, filter.values) : S.of(context).common_components_filterBar_pleaseSelect),
            Tab(text: (selected2 != null && hasLevel2) ? _getNameById(selected2!, filter.values) : S.of(context).common_components_filterBar_pleaseSelect),
            Tab(text: (selected3 != null && hasLevel3) ? _getNameById(selected3!, filter.values) : S.of(context).common_components_filterBar_pleaseSelect),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _nestedTabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListView(
                children: level1List.map<Widget>((item) {
                  final isSelected = selected1 == item.id;
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(item.name, style: TextStyle(color: isSelected ? const Color(0xFF1989FA) : Colors.black)),
                        ),
                        if (item.count != null) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              '${item.count}',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    onTap: () {
                      _overlayRebuild?.call(() {
                        selected1 = item.id;
                        selected2 = null;
                        selected3 = null;
                        // 如果选择的是"全部"（id为空），直接确认
                        if (item.id == '') {
                          _confirmSelection(filter);
                          return;
                        }
                        _nestedTabController?.animateTo( hasLevel2 ? 1 : 0 );
                      });
                    },
                  );
                }).toList(),
              ),
              hasLevel2
                  ? ListView(
                      children: level2List.map<Widget>((item) {
                        final isSelected = selected2 == item.id;
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(item.name, style: TextStyle(color: isSelected ? const Color(0xFF1989FA) : Colors.black)),
                              ),
                              if (item.count != null) ...[
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    '${item.count}',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          onTap: () {
                            _overlayRebuild?.call(() {
                              selected2 = item.id;
                              selected3 = null;
                              _nestedTabController?.animateTo(hasLevel3 ? 2 : 1);
                            });
                          },
                        );
                      }).toList(),
                    )
                  : Center(child: Text(S.of(context).common_components_filterBar_noData)),
              hasLevel3
                  ? ListView(
                      children: level3List.map<Widget>((item) {
                        final isSelected = selected3 == item.id;
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(item.name, style: TextStyle(color: isSelected ? const Color(0xFF1989FA) : Colors.black)),
                              ),
                              if (item.count != null) ...[
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    '${item.count}',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          onTap: () {
                            _overlayRebuild?.call(() {
                              selected3 = item.id;
                            });
                          },
                        );
                      }).toList(),
                    )
                  : Center(child: Text(S.of(context).common_components_filterBar_noData)),
            ],
          ),
        ),
      ] else ...[
        // 如果TabController还没有初始化，显示加载状态
        Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
      Divider(height: 1, color: Colors.grey.shade200),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
                onPressed: () {
                  _overlayRebuild?.call(() {
                    selected1 = null;
                    selected2 = null;
                    selected3 = null;
                  });
                },
                child: Text(S.of(context).common_components_filterBar_reset),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canConfirm(filter) ? const Color(0xFF1989FA) : Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
                onPressed: _canConfirm(filter) ? () => _confirmSelection(filter) : null,
                child: Text(S.of(context).common_components_filterBar_confirm),
              ),
            )
          ],
        ),
      )
    ],
  );
}

  String? _getNameById(String id, List<FilterValue> list) {
    for (final item in list) {
      if (item.id == id) return item.name;
      if (item.children != null) {
        final name = _getNameById(id, item.children!);
        if (name != null) return name;
      }
    }
    return null;
  }

  String _getDisplayText(FilterOption filter) {
  if (!filter.nested) {
    final currentValue = selected[filter.key];
    List<String> ids;
    
    if (filter.isMultiSelect) {
      // 多选模式：保持数组格式
      ids = currentValue is List ? List<String>.from(currentValue) : [];
    } else {
      // 单选模式：从单个值转换为数组格式
      if (currentValue != null && currentValue is! List) {
        ids = [currentValue.toString()];
      } else if (currentValue is List && currentValue.isNotEmpty) {
        // 兼容旧数据格式
        ids = [currentValue.first.toString()];
      } else {
        ids = [];
      }
    }
    
    // 如果选择的是空字符串（全部），不显示文本
    if (ids.isEmpty || (ids.length == 1 && ids.first == '')) {
      return '';
    }
    final names = filter.values
        .expand((v) => _flatten(v))
        .where((v) => ids.contains(v.id) && v.id != '') // 排除"全部"选项
        .map((v) => v.name)
        .toList();
    return names.join(', ');
  }

  // 嵌套筛选，直接从 selected[filter.key] 取
  final ids = selected[filter.key] ?? [];
  // 如果数组为空或第一个元素是空字符串（全部），不显示文本
  if (ids.isEmpty || (ids.isNotEmpty && ids.first == '')) {
    return '';
  }
  // 优先显示最后一级（最具体的级别）
  if (ids.length >= 3) {
    return _getNameById(ids[2], filter.values) ?? '';
  }
  if (ids.length == 2) {
    return _getNameById(ids[1], filter.values) ?? '';
  }
  // 只选一级时，显示一级名称
  if (ids.length == 1) {
    return _getNameById(ids[0], filter.values) ?? '';
  }
  return '';
}


  List<FilterValue> _flatten(FilterValue value) {
    final children = value.children ?? [];
    return [value, ...children.expand(_flatten)];
  }

  IconData _getFilterIcon(String key) {
    switch (key) {
      case 'areaId':
        return Icons.location_on_rounded;
      case 'brandId':
        return Icons.business_rounded;
      case 'specId':
        return Icons.movie_filter_rounded;
      case 'subtitleId':
        return Icons.subtitles_rounded;
      default:
        return Icons.tune_rounded;
    }
  }

  void _openDrawer() {
    if (_isDrawerOpen) return;
    // 初始化 drawer 的临时选中状态
    _drawerSelected = {};
    if (widget.drawerFilters != null) {
      for (var filter in widget.drawerFilters!) {
        final currentValue = selected[filter.key];
        if (filter.type == FilterType.switch_) {
          // Switch 类型：从 selected 中读取值，转换为数组格式
          if (currentValue == null) {
            // 没有值，默认为未选中
            final offValue = filter.switchOffValue ?? 'false';
            _drawerSelected[filter.key] = [offValue];
          } else if (currentValue is bool) {
            // 布尔值：true 转为 'true'，false 转为 'false' 或配置的 offValue
            if (currentValue) {
              final onValue = filter.switchOnValue ?? 'true';
              _drawerSelected[filter.key] = [onValue];
            } else {
              final offValue = filter.switchOffValue ?? 'false';
              _drawerSelected[filter.key] = [offValue];
            }
          } else {
            // 字符串值（配置的值）
            _drawerSelected[filter.key] = [currentValue.toString()];
          }
        } else if (filter.type == FilterType.timeRange) {
          // 时间范围筛选：如果没有值，根据默认值计算并保存初始值
          // 默认选中全天：30小时制是6-29（06:00-下一天05:59），24小时制是0-24（00:00-24:00）
          // 存储格式：数组包含两个元素，分别是开始时间和结束时间
          final use30HourFormat = filter.use30HourFormat ?? false;
          final baseDate = widget.baseDate ?? DateTime.now();
          final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
          
          DateTime startDateTime;
          DateTime endDateTime;
          
          if (use30HourFormat) {
            startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, 6, 0);
            endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day + 1, 5, 59, 59);
          } else {
            startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, 0, 0);
            endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, 23, 59, 59);
          }
          
          _drawerSelected[filter.key] = [
            dateFormat.format(startDateTime),
            dateFormat.format(endDateTime),
          ];
        } else {
          // 其他类型：根据是否多选处理
          if (filter.isMultiSelect) {
            // 多选模式：保持数组格式
            if (currentValue is List && currentValue.isNotEmpty) {
              _drawerSelected[filter.key] = List.from(currentValue);
            } else {
              _drawerSelected[filter.key] = [];
            }
          } else {
            // 单选模式：从单个值转换为数组格式（用于 drawer 内部处理）
            if (currentValue != null && currentValue is! List) {
              // 单个值，转换为数组
              _drawerSelected[filter.key] = [currentValue.toString()];
            } else if (currentValue is List && currentValue.isNotEmpty) {
              // 兼容旧数据格式（数组），取第一个值
              _drawerSelected[filter.key] = [currentValue.first.toString()];
            } else {
              // 没有值
              _drawerSelected[filter.key] = [];
            }
          }
        }
      }
    }
    
    setState(() {
      _isDrawerOpen = true;
    });
    
    // 使用微任务获取按钮位置
    Future.microtask(() {
      if (!mounted) return;
      
      final ctx = _drawerButtonKey.currentContext;
      if (ctx == null) return;
      final renderBox = ctx.findRenderObject() as RenderBox;
      final offset = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      
      _drawerOverlayEntry = _createDrawerOverlayEntry(offset, size);
      Overlay.of(context).insert(_drawerOverlayEntry!);
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _closeDrawer() {
    if (!_isDrawerOpen) return;
    _drawerOverlayEntry?.remove();
    _drawerOverlayEntry = null;
    setState(() {
      _isDrawerOpen = false;
    });
  }

  OverlayEntry _createDrawerOverlayEntry(Offset offset, Size size) {
    final drawerFilters = widget.drawerFilters ?? [];
    final screenWidth = MediaQuery.of(context).size.width;
    final style = widget.style ?? const FilterBarStyle();
    final gap = style.dropdownGap ?? 8.h; // 弹出层与筛选按钮之间的间距

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 遮罩只覆盖筛选框下方的区域，不遮挡header和筛选框
            Positioned(
              left: 0,
              top: offset.dy + size.height + gap,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _closeDrawer,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),
            // Drawer 内容
            Positioned(
              left: 0,
              top: offset.dy + size.height + gap,
              width: screenWidth,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.65,
                    minHeight: 200,
                  ),
                  child: StatefulBuilder(
                    builder: (context, overlaySetState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Drawer 内容
                          Flexible(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: drawerFilters.map((filter) {
                                final currentSelected = _drawerSelected[filter.key] ?? [];
                                final selectedList = currentSelected is List 
                                    ? List<String>.from(currentSelected) 
                                    : [currentSelected.toString()];
                                
                                return DrawerFilterChip(
                                  filter: filter,
                                  selectedIds: selectedList,
                                  style: widget.style,
                                  baseDate: widget.baseDate,
                                  onSelectionChanged: (newSelectedIds) {
                                    overlaySetState(() {
                                      _drawerSelected[filter.key] = newSelectedIds;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          // Drawer 底部按钮
                          Container(
                            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top: BorderSide(color: Colors.grey.shade200, width: 0.5),
                              ),
                            ),
                            child: SafeArea(
                              top: false,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black87,
                                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                                        padding: EdgeInsets.symmetric(vertical: 20.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                      ),
                                      onPressed: () {
                                        // 重置抽屉中的筛选项
                                        overlaySetState(() {
                                          if (widget.drawerFilters != null) {
                                            for (var filter in widget.drawerFilters!) {
                                              _drawerSelected[filter.key] = [];
                                            }
                                          }
                                        });
                                      },
                                      child: Text(
                                        S.of(context).common_components_filterBar_reset,
                                        style: TextStyle(
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF1989FA),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 20.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        // 将 drawer 中的选中状态应用到 selected
                                        if (widget.drawerFilters != null) {
                                          for (var filter in widget.drawerFilters!) {
                                            final drawerValue = _drawerSelected[filter.key];
                                            if (drawerValue != null) {
                                              if (filter.type == FilterType.switch_) {
                                                // Switch 类型：转换为单个值（bool 或配置的值）
                                                if (drawerValue is List && drawerValue.isNotEmpty) {
                                                  final value = drawerValue.first;
                                                  // 如果配置了值，使用配置的值（字符串）；否则转换为布尔值
                                                  if (filter.switchOnValue != null || filter.switchOffValue != null) {
                                                    selected[filter.key] = value;
                                                  } else {
                                                    // 没有配置值，使用布尔值
                                                    selected[filter.key] = value == 'true';
                                                  }
                                                } else {
                                                  // 空数组表示未选中
                                                  if (filter.switchOffValue != null) {
                                                    selected[filter.key] = filter.switchOffValue;
                                                  } else {
                                                    selected[filter.key] = false;
                                                  }
                                                }
                                              } else if (filter.type == FilterType.timeRange) {
                                                // 时间范围类型：保持数组格式
                                                selected[filter.key] = List.from(drawerValue);
                                              } else {
                                                // 其他类型：根据是否多选决定返回格式
                                                if (drawerValue is List) {
                                                  if (filter.isMultiSelect) {
                                                    // 多选模式：返回数组
                                                    if (drawerValue.isEmpty) {
                                                      selected[filter.key] = [];
                                                    } else {
                                                      selected[filter.key] = List.from(drawerValue);
                                                    }
                                                  } else {
                                                    // 单选模式：返回单个值（字符串）或 null
                                                    selected[filter.key] = drawerValue.isNotEmpty ? drawerValue.first : null;
                                                  }
                                                } else {
                                                  selected[filter.key] = drawerValue;
                                                }
                                              }
                                            } else {
                                              // 如果没有值，根据类型设置默认值
                                              if (filter.type == FilterType.switch_) {
                                                if (filter.switchOffValue != null) {
                                                  selected[filter.key] = filter.switchOffValue;
                                                } else {
                                                  selected[filter.key] = false;
                                                }
                                              } else {
                                                // 根据是否多选设置默认值
                                                if (filter.isMultiSelect) {
                                                  selected[filter.key] = [];
                                                } else {
                                                  selected[filter.key] = null;
                                                }
                                              }
                                            }
                                          }
                                        }
                                        widget.onConfirm(Map.from(selected));
                                        _closeDrawer();
                                      },
                                      child: Text(
                                        S.of(context).common_components_filterBar_confirm,
                                        style: TextStyle(
                                          fontSize: 30.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDrawerButton() {
    final style = widget.style ?? const FilterBarStyle();
    final height = style.height ?? 56.h;
    final margin = style.margin ?? EdgeInsets.symmetric(horizontal: 4.w);
    final borderRadius = style.borderRadius ?? 12.r;
    final borderWidth = style.borderWidth ?? 1.0;
    final unselectedBgColor = style.unselectedBackgroundColor ?? Colors.grey.shade50;
    final unselectedBorderColor = style.unselectedBorderColor ?? Colors.grey.shade200;
    final iconSize = style.iconSize ?? 22.sp;
    final unselectedIconColor = style.unselectedIconColor ?? const Color(0xFF646566);

    // 检查是否有抽屉筛选项被选中
    bool hasDrawerSelection = false;
    if (widget.drawerFilters != null) {
      for (var filter in widget.drawerFilters!) {
        final value = selected[filter.key];
        if (value != null && 
            (value is List ? value.isNotEmpty : value != '' && value != [])) {
          hasDrawerSelection = true;
          break;
        }
      }
    }

    return Container(
      key: _drawerButtonKey,
      margin: margin,
      child: GestureDetector(
        onTap: _openDrawer,
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: hasDrawerSelection ? (style.selectedBackgroundColor ?? const Color(0xFF1989FA)) : unselectedBgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: hasDrawerSelection ? (style.selectedBorderColor ?? const Color(0xFF1989FA)) : unselectedBorderColor,
              width: borderWidth,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: iconSize,
                color: hasDrawerSelection 
                  ? (style.selectedIconColor ?? Colors.white)
                  : unselectedIconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(FilterOption filter, int index, bool isActive, bool hasSelection, String display) {
    final style = widget.style ?? const FilterBarStyle();
    final isSelected = isActive || hasSelection;
    
    // 默认样式值
    final height = style.height ?? 56.h;
    final padding = style.padding ?? EdgeInsets.symmetric(horizontal: 20.w);
    final margin = style.margin ?? EdgeInsets.symmetric(horizontal: 4.w);
    final selectedBgColor = style.selectedBackgroundColor ?? const Color(0xFF1989FA);
    final unselectedBgColor = style.unselectedBackgroundColor ?? Colors.grey.shade50;
    final selectedBorderColor = style.selectedBorderColor ?? const Color(0xFF1989FA);
    final unselectedBorderColor = style.unselectedBorderColor ?? Colors.grey.shade200;
    final borderRadius = style.borderRadius ?? 12.r;
    final borderWidth = style.borderWidth ?? 1.0;
    final iconSize = style.iconSize ?? 22.sp;
    final selectedIconColor = style.selectedIconColor ?? Colors.white;
    final unselectedIconColor = style.unselectedIconColor ?? const Color(0xFF646566);
    final textSize = style.textSize ?? 26.sp;
    final selectedTextWeight = style.selectedTextWeight ?? FontWeight.w600;
    final unselectedTextWeight = style.unselectedTextWeight ?? FontWeight.w500;
    final selectedTextColor = style.selectedTextColor ?? Colors.white;
    final unselectedTextColor = style.unselectedTextColor ?? const Color(0xFF323233);
    final selectedArrowColor = style.selectedArrowColor ?? Colors.white;
    final unselectedArrowColor = style.unselectedArrowColor ?? const Color(0xFF969799);
    final arrowSize = style.arrowSize ?? 26.sp;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: isSelected ? selectedBgColor : unselectedBgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isSelected ? selectedBorderColor : unselectedBorderColor,
          width: borderWidth,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconSize > 0) ...[
            Icon(
              filter.icon ?? _getFilterIcon(filter.key),
              size: iconSize,
              color: isSelected ? selectedIconColor : unselectedIconColor,
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Text(
              display.isNotEmpty ? display : filter.title,
              style: TextStyle(
                fontWeight: isSelected ? selectedTextWeight : unselectedTextWeight,
                color: isSelected ? selectedTextColor : unselectedTextColor,
                fontSize: textSize,
                height: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 4.w),
          AnimatedBuilder(
            animation: _arrowControllers[index],
            builder: (context, child) {
              return Transform.rotate(
                angle: _arrowControllers[index].value * 3.14159,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: arrowSize,
                  color: isSelected ? selectedArrowColor : unselectedArrowColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

