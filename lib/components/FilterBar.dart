import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterValue {
  final String id;
  final String name;
  final List<FilterValue>? children;

  FilterValue({required this.id, required this.name, this.children});
}

class FilterOption {
  final String key;
  final String title;
  final List<FilterValue> values;
  final bool multi;
  final bool nested;

  FilterOption({
    required this.key,
    required this.title,
    required this.values,
    this.multi = true,
    this.nested = false,
  });
}

class FilterBar extends StatefulWidget {
  final List<FilterOption> filters;
  final Map<String, dynamic> initialSelected;
  final void Function(Map<String, dynamic> selected) onConfirm;

  const FilterBar({
    super.key,
    required this.filters,
    this.initialSelected = const {},
    required this.onConfirm,
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
        duration: const Duration(milliseconds: 200),
        lowerBound: 0,
        upperBound: 0.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.filters.length, (index) {
        final filter = widget.filters[index];
        final display = _getDisplayText(filter);
        final isActive = _activeFilterIndex == index;

        return Expanded(
          child: InkWell(
            key: _filterKeys[index],
            onTap: () {
              if (_overlayEntry != null) {
                if (_activeFilterIndex == index) {
                  _hideDropdown();
                } else {
                  setState(() {
                    _activeFilterIndex = index;
                    _tempSelected = List.from(selected[filter.key]!);
                    for (int i = 0; i < _arrowControllers.length; i++) {
                      if (i == index) {
                        _arrowControllers[i].forward();
                      } else {
                        _arrowControllers[i].reverse();
                      }
                    }
                  });
                  _overlayRebuild?.call(() {});
                }
              } else {
                _showDropdown(filter, index);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 15.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                color: isActive ? Colors.red.shade50 : Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    filter.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.red : Colors.black87,
                      fontSize: 28.sp,
                    ),
                  ),
                  if (display.isNotEmpty) ...[
                    SizedBox(width: 12.w),
                    Flexible(
                      child: Text(
                        display,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ],
                  AnimatedBuilder(
                    animation: _arrowControllers[index],
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _arrowControllers[index].value * 3.14159 * 2,
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: 32.sp,
                          color: isActive ? Colors.redAccent : Colors.black54,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    for (var c in _arrowControllers) {
      c.dispose();
    }
    _nestedTabController?.dispose();
    super.dispose();
  }

  void _showDropdown(FilterOption filter, int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tempSelected = List.from(selected[filter.key]!);
      _activeFilterIndex = index;
      _arrowControllers[index].forward();

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
        if (selected[filter.key]!.isNotEmpty) {
          String lastId = selected[filter.key]!.last;
          _resolveSelectedIds(filter.values, lastId);
        }

        // ⚠️ 新建 TabController，并强制 index = 0
        _nestedTabController?.dispose();
        _nestedTabController = TabController(length: 3, vsync: this, initialIndex: 0);
        _nestedTabController!.addListener(() {
          _overlayRebuild?.call(() {});
        });
      }

      _overlayEntry = _createOverlayEntry(filter, offset, size, index);
      Overlay.of(context).insert(_overlayEntry!);
      setState(() {});
    });
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
    if (_activeFilterIndex != null) {
      _arrowControllers[_activeFilterIndex!].reverse();
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
    _activeFilterIndex = null;
    setState(() {});
  }

  OverlayEntry _createOverlayEntry(FilterOption filter, Offset offset, Size size, int index) {
    final screenWidth = MediaQuery.of(context).size.width;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              top: offset.dy + size.height,
              child: GestureDetector(
                onTap: _hideDropdown,
                child: Container(color: Colors.black.withOpacity(0.5)),
              ),
            ),
            Positioned(
              left: 0,
              top: offset.dy + size.height,
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
                    builder: (context, setState) {
                      _overlayRebuild = setState;
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
                                  title: Text(value.name,
                                      style: TextStyle(
                                          fontSize: 28.sp,
                                          color: isSelected ? Colors.red : Colors.black87)),
                                  trailing: isSelected ? const Icon(Icons.check, color: Colors.red) : null,
                                  onTap: () {
                                    _overlayRebuild!(() {
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
                                      _overlayRebuild!(() => _tempSelected.clear());
                                    },
                                    child: Text('重置'),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.r),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (activeFilter.multi) {
                                        selected[activeFilter.key] = List<String>.from(_tempSelected ?? []);
                                      } else {
                                        selected[activeFilter.key] = _tempSelected;
                                      }
                                      widget.onConfirm(selected);
                                      _hideDropdown();
                                    },
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
            _nestedTabController!.animateTo(0);
            return;
          }
          if (index == 2 && (!hasLevel3 || selected2 == null)) {
            _nestedTabController!.animateTo(hasLevel2 && selected1 != null ? 1 : 0);
            return;
          }
        },
        tabs: <Widget>[
          Tab(text: selected1 != null ? _getNameById(selected1!, filter.values) : '请选择'),
          Tab(text: (selected2 != null && hasLevel2) ? _getNameById(selected2!, filter.values) : '请选择'),
          Tab(text: (selected3 != null && hasLevel3) ? _getNameById(selected3!, filter.values) : '请选择'),
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
                  title: Text(item.name, style: TextStyle(color: isSelected ? Colors.red : Colors.black)),
                  onTap: () {
                    _overlayRebuild?.call(() {
                      selected1 = item.id;
                      selected2 = null;
                      selected3 = null;
                      _nestedTabController!.animateTo( hasLevel2 ? 1 : 0 );
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
                        title: Text(item.name, style: TextStyle(color: isSelected ? Colors.red : Colors.black)),
                        onTap: () {
                          _overlayRebuild?.call(() {
                            selected2 = item.id;
                            selected3 = null;
                            _nestedTabController!.animateTo(hasLevel3 ? 2 : 1);
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
                        title: Text(item.name, style: TextStyle(color: isSelected ? Colors.red : Colors.black)),
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
                child: Text('重置'),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
                onPressed: (selected2 != null)
                    ? () {
                        List<String> selectedIds = [];
                        if (selected1 != null) selectedIds.add(selected1!);
                        if (selected2 != null) selectedIds.add(selected2!);
                        if (selected3 != null) selectedIds.add(selected3!);

                        selected[filter.key] = selectedIds;
                        widget.onConfirm(selected);
                        _hideDropdown();
                      }
                    : null,
                child: const Text('确认'),
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
    final names = filter.values
        .expand((v) => _flatten(v))
        .where((v) => ids.contains(v.id))
        .map((v) => v.name)
        .toList();
    return names.join(', ');
  }

  // 嵌套筛选，直接从 selected[filter.key] 取
  final ids = selected[filter.key] ?? [];
  if (ids.length >= 3) {
    return _getNameById(ids[2], filter.values) ?? '';
  }
  if (ids.length == 2) {
    return _getNameById(ids[1], filter.values) ?? '';
  }
  // 只选一级时不显示
  return '';
}


  List<FilterValue> _flatten(FilterValue value) {
    final children = value.children ?? [];
    return [value, ...children.expand(_flatten)];
  }
}

