import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../generated/l10n.dart';

class FilterValue {
  final String id;
  final String name;
  final List<FilterValue>? children;
  final int? count; // 数量

  FilterValue({required this.id, required this.name, this.children, this.count});
}

class FilterOption {
  final String key;
  final String title;
  final List<FilterValue> values;
  final bool multi;
  final bool nested;
  final IconData? icon;

  FilterOption({
    required this.key,
    required this.title,
    required this.values,
    this.multi = true,
    this.nested = false,
    this.icon,
  });
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
  });
}

class FilterBar extends StatefulWidget {
  final List<FilterOption> filters;
  final Map<String, dynamic> initialSelected;
  final void Function(Map<String, dynamic> selected) onConfirm;
  final FilterBarStyle? style;

  const FilterBar({
    super.key,
    required this.filters,
    this.initialSelected = const {},
    required this.onConfirm,
    this.style,
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

  @override
  void initState() {
    super.initState();
    selected = Map.from(widget.initialSelected);
    for (var filter in widget.filters) {
      selected.putIfAbsent(filter.key, () => []);
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
    return PopScope(
      canPop: _overlayEntry == null,
      onPopInvoked: (didPop) {
        if (!didPop && _overlayEntry != null) {
          _hideDropdown();
        }
      },
      child: Row(
        children: List.generate(widget.filters.length, (index) {
        final filter = widget.filters[index];
        final display = _getDisplayText(filter);
        final isActive = _activeFilterIndex == index;
        final hasSelection = display.isNotEmpty; // 有选中值时高亮

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
                      _tempSelected = List.from(selected[filter.key] ?? []);
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
    super.dispose();
  }

  void _showDropdown(FilterOption filter, int index) {
    // 立即更新状态，提供即时反馈
    if (!mounted) return;
    _tempSelected = List.from(selected[filter.key] ?? []);
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
        if ((selected[filter.key] ?? []).isNotEmpty) {
          String lastId = (selected[filter.key] ?? []).last;
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
      if (filter.multi) {
        selected[filter.key] = List<String>.from(_tempSelected);
      } else {
        selected[filter.key] = _tempSelected;
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
                  color: Colors.black.withOpacity(0.3),
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
                                                color: isSelected ? Colors.red : Colors.black87)),
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
                                  trailing: isSelected ? const Icon(Icons.check, color: Colors.red) : null,
                                  onTap: () {
                                    _overlayRebuild?.call(() {
                                      if (activeFilter.multi) {
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
                                    child: Text('重置'),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _canConfirm(activeFilter) ? Colors.red : Colors.grey.shade300,
                                      foregroundColor: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.r),
                                      ),
                                    ),
                                    onPressed: _canConfirm(activeFilter) ? () => _confirmSelection(activeFilter) : null,
                                    child: Text('确认'),
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
          labelColor: Colors.red,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.red,
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
                          child: Text(item.name, style: TextStyle(color: isSelected ? Colors.red : Colors.black)),
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
                                child: Text(item.name, style: TextStyle(color: isSelected ? Colors.red : Colors.black)),
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
                  : Center(child: Text('暂无数据')),
              hasLevel3
                  ? ListView(
                      children: level3List.map<Widget>((item) {
                        final isSelected = selected3 == item.id;
                        return ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(item.name, style: TextStyle(color: isSelected ? Colors.red : Colors.black)),
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
                  : Center(child: Text('暂无数据')),
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
                  backgroundColor: _canConfirm(filter) ? Colors.red : Colors.grey.shade300,
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
    // 普通多选过滤，保留原逻辑
    final ids = selected[filter.key] ?? [];
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
    final badgeBgColor = style.badgeBackgroundColor ?? const Color(0xFF1989FA).withOpacity(0.1);
    final selectedBadgeBgColor = style.selectedBadgeBackgroundColor ?? Colors.white.withOpacity(0.2);
    final badgeTextColor = style.badgeTextColor ?? const Color(0xFF1989FA);
    final selectedBadgeTextColor = style.selectedBadgeTextColor ?? Colors.white;
    final badgeTextSize = style.badgeTextSize ?? 20.sp;
    final badgeBorderRadius = style.badgeBorderRadius ?? 8.r;

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

