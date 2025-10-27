import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../generated/l10n.dart';

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
        upperBound: 0.5,
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150), // 减少动画时间
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              // margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: (isActive || hasSelection) ? Color(0xFFFF6B6B) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: (isActive || hasSelection)
                      ? const Color(0xFFFF6B6B).withOpacity(0.3) 
                      : Colors.black.withOpacity(0.05),
                    blurRadius: (isActive || hasSelection) ? 8 : 4,
                    offset: Offset(0, (isActive || hasSelection) ? 3 : 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      filter.title,
                      style: TextStyle(
                        fontWeight: (isActive || hasSelection) ? FontWeight.w700 : FontWeight.w600,
                        color: (isActive || hasSelection) ? Colors.white : const Color(0xFF323233),
                        fontSize: 26.sp,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (display.isNotEmpty) ...[
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        display,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: (isActive || hasSelection) ? Colors.white : const Color(0xFFFF6B6B),
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(width: 4.w),
                  AnimatedBuilder(
                    animation: _arrowControllers[index],
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _arrowControllers[index].value * 3.14159 * 2,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 28.sp,
                          color: (isActive || hasSelection) ? Colors.white : Colors.grey.shade600,
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
      List<String> selectedIds = [];
      if (selected1 != null) selectedIds.add(selected1!);
      if (selected2 != null) selectedIds.add(selected2!);
      if (selected3 != null) selectedIds.add(selected3!);
      
      selected[filter.key] = selectedIds;
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
      // 嵌套筛选至少需要选择到第二级
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

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 遮罩只覆盖筛选框下方的区域，不遮挡header和筛选框
            Positioned(
              left: 0,
              top: offset.dy + size.height,
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
                                  title: Text(value.name,
                                      style: TextStyle(
                                          fontSize: 28.sp,
                                          color: isSelected ? Colors.red : Colors.black87)),
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
                    title: Text(item.name, style: TextStyle(color: isSelected ? Colors.red : Colors.black)),
                    onTap: () {
                      _overlayRebuild?.call(() {
                        selected1 = item.id;
                        selected2 = null;
                        selected3 = null;
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
                          title: Text(item.name, style: TextStyle(color: isSelected ? Colors.red : Colors.black)),
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

