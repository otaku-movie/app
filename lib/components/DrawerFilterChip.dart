import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../generated/l10n.dart';
import 'FilterBar.dart';

/// Drawer 中的筛选项组件（Chip 按钮样式）
/// 使用按钮样式显示筛选选项，支持单选和多选、时间范围、Switch
class DrawerFilterChip extends StatefulWidget {
  final FilterOption filter;
  final List<String> selectedIds;
  final void Function(List<String> newSelectedIds) onSelectionChanged;
  final FilterBarStyle? style;
  /// 基准日期，用于时间范围筛选（默认为当前日期）
  final DateTime? baseDate;

  const DrawerFilterChip({
    super.key,
    required this.filter,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.style,
    this.baseDate,
  });

  @override
  State<DrawerFilterChip> createState() => _DrawerFilterChipState();
}

class _DrawerFilterChipState extends State<DrawerFilterChip> {
  late RangeValues _timeRangeValues;
  late bool _use30HourFormat;
  late double _maxHour;

  @override
  void initState() {
    super.initState();
    // 判断是否使用30小时制
    _use30HourFormat = widget.filter.use30HourFormat ?? false;
    _maxHour = _use30HourFormat ? 29 : 24; // 30小时制是6-29，24小时制是0-24
    
    // 初始化时间范围：从 selectedIds 中解析，如果没有则使用默认值
    // 存储格式：数组包含两个元素，分别是开始时间和结束时间（yyyy-MM-dd HH:mm:ss）
    if (widget.filter.type == FilterType.timeRange && widget.selectedIds.isNotEmpty) {
      try {
        DateTime? startDateTime;
        DateTime? endDateTime;
        
        // 如果数组有两个元素，分别解析开始时间和结束时间
        if (widget.selectedIds.length >= 2) {
          try {
            startDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.selectedIds[0]);
            endDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.selectedIds[1]);
          } catch (e) {
            // 解析失败，使用默认值
          }
        } else if (widget.selectedIds.length == 1) {
          // 兼容旧格式：单个字符串，格式为 yyyy-MM-dd HH:mm:ss-yyyy-MM-dd HH:mm:ss
          final selectedValue = widget.selectedIds.first;
          if (selectedValue.contains(' ') && selectedValue.length > 19) {
            final dateTimeStr = selectedValue.split(RegExp(r'-(?=\d{4}-\d{2}-\d{2})'));
            if (dateTimeStr.length == 2) {
              try {
                startDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeStr[0].trim());
                endDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTimeStr[1].trim());
              } catch (e) {
                // 解析失败，使用默认值
              }
            }
          }
        }
        
        // 如果成功解析了完整日期时间格式，转换为滑块值
        if (startDateTime != null && endDateTime != null) {
          // 使用 baseDate 来判断是否是下一天，而不是 DateTime.now()
          final baseDate = widget.baseDate ?? DateTime.now();
          final today = DateTime(baseDate.year, baseDate.month, baseDate.day);
          
          double startHour;
          double endHour;
          
          if (_use30HourFormat) {
            // 30小时制处理
            // 判断 startDateTime 是否是下一天（大于等于明天的00:00）
            if (startDateTime.year > today.year || 
                (startDateTime.year == today.year && startDateTime.month > today.month) ||
                (startDateTime.year == today.year && startDateTime.month == today.month && startDateTime.day > today.day)) {
              // 下一天的00:00-05:59，转换为24-29
              final hour = startDateTime.hour;
              final minute = startDateTime.minute;
              startHour = 24 + hour + (minute / 60);
            } else {
              // 当天的06:00-23:59，转换为6-23
              final hour = startDateTime.hour;
              final minute = startDateTime.minute;
              startHour = hour + (minute / 60);
              if (startHour < 6) startHour = 6; // 确保不小于6
            }
            
            // 判断 endDateTime 是否是下一天
            final endIsNextDay = endDateTime.year > today.year || 
                (endDateTime.year == today.year && endDateTime.month > today.month) ||
                (endDateTime.year == today.year && endDateTime.month == today.month && endDateTime.day > today.day);
            
            if (endIsNextDay) {
              // 下一天的00:00-05:59，转换为24-29
              final hour = endDateTime.hour;
              final minute = endDateTime.minute;
              final second = endDateTime.second;
              // 如果是 05:59:59，表示全天（29）
              if (hour == 5 && minute == 59 && second == 59) {
                endHour = 29.0;
              } else {
                endHour = 24 + hour + (minute / 60) + (second / 3600);
              }
              if (endHour > 29) endHour = 29; // 确保不大于29
            } else {
              // 当天的06:00-23:59，转换为6-23
              final hour = endDateTime.hour;
              final minute = endDateTime.minute;
              endHour = hour + (minute / 60);
              if (endHour < 6) endHour = 6; // 确保不小于6
              // 如果结束时间在当天但应该是全天，检查是否是23:59:59
              if (hour == 23 && minute == 59) {
                // 可能是24小时制的全天，但在30小时制中应该是29
                // 这里保持原逻辑，因为30小时制中当天的23:59应该对应23，而不是29
              }
            }
            
            // 确保 startHour <= endHour
            if (startHour > endHour) {
              // 如果开始时间大于结束时间，可能是跨天的情况，交换它们
              final temp = startHour;
              startHour = endHour;
              endHour = temp;
            }
            // 确保值在有效范围内
            if (startHour < 6) startHour = 6;
            if (startHour > 29) startHour = 29;
            if (endHour < 6) endHour = 6;
            if (endHour > 29) endHour = 29;
            if (startHour > endHour) {
              // 如果仍然不满足，使用默认值
              startHour = 6.0;
              endHour = 29.0;
            }
          } else {
            // 24小时制处理
            final hour = startDateTime.hour;
            final minute = startDateTime.minute;
            startHour = hour + (minute / 60);
            
            final endHourInt = endDateTime.hour;
            final endMinute = endDateTime.minute;
            if (endHourInt == 23 && endMinute == 59) {
              endHour = 24; // 23:59:59 表示全天
            } else {
              endHour = endHourInt + (endMinute / 60);
            }
            
            // 确保 startHour <= endHour
            if (startHour > endHour) {
              // 如果开始时间大于结束时间，可能是跨天的情况，交换它们
              final temp = startHour;
              startHour = endHour;
              endHour = temp;
            }
            // 确保值在有效范围内
            if (startHour < 0) startHour = 0;
            if (startHour > 24) startHour = 24;
            if (endHour < 0) endHour = 0;
            if (endHour > 24) endHour = 24;
            if (startHour > endHour) {
              // 如果仍然不满足，使用默认值
              startHour = 0.0;
              endHour = 24.0;
            }
          }
          
          _timeRangeValues = RangeValues(startHour, endHour);
        } else {
          // 不是完整日期时间格式或解析失败，使用默认值
          // 默认选中全天：30小时制是6-29（06:00-下一天05:59），24小时制是0-24（00:00-24:00）
          _timeRangeValues = RangeValues(_use30HourFormat ? 6.0 : 0.0, _maxHour);
        }
      } catch (e) {
        _timeRangeValues = RangeValues(_use30HourFormat ? 6.0 : 0.0, _maxHour);
      }
    } else {
      // 默认选中全天：30小时制是6-29（06:00-下一天05:59），24小时制是0-24（00:00-24:00）
      _timeRangeValues = RangeValues(_use30HourFormat ? 6.0 : 0.0, _maxHour);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    const primaryColor = Color(0xFF1989FA);
    // 优先使用 drawerSelectedColor，否则使用默认蓝色
    final selectedColor = widget.style?.drawerSelectedColor ?? primaryColor;
    
    // 时间范围类型
    if (widget.filter.type == FilterType.timeRange) {
      return _buildTimeRangeFilter(selectedColor);
    }
    
    // Switch 类型
    if (widget.filter.type == FilterType.switch_) {
      return _buildSwitchFilter(selectedColor);
    }
    
    // 普通按钮类型
    return _buildChipFilter(selectedColor);
  }

  /// 构建时间范围筛选
  Widget _buildTimeRangeFilter(Color selectedColor) {
    // 格式化显示时间（考虑30小时制）
    final displayStart = _formatTimeForDisplay(_timeRangeValues.start);
    final displayEnd = _formatTimeForDisplay(_timeRangeValues.end);
    final isAllDay = ((_use30HourFormat && _timeRangeValues.start == 6 && _timeRangeValues.end == 29) || 
                      (!_use30HourFormat && _timeRangeValues.start == 0 && _timeRangeValues.end == 24));
    
    final timeText = isAllDay
        ? S.of(context).common_components_filterBar_allDay
        : '$displayStart - $displayEnd';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和当前值
          Container(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 16.h),
            child: Row(
              children: [
                Text(
                  widget.filter.drawerDisplayConfig?.title ?? widget.filter.title,
                  style: widget.filter.drawerDisplayConfig?.titleStyle ?? TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: selectedColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: selectedColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    timeText,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w500,
                      color: selectedColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 时间范围滑块
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 12.h),
            child: Theme(
              data: Theme.of(context).copyWith(
                sliderTheme: SliderTheme.of(context).copyWith(
                  trackHeight: 6.h,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 18.r,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 20.r,
                  ),
                  activeTrackColor: selectedColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  thumbColor: Colors.white,
                  overlayColor: selectedColor.withValues(alpha: 0.2),
                ),
              ),
              child: RangeSlider(
                values: _timeRangeValues,
                min: _use30HourFormat ? 6 : 0,
                max: _maxHour,
                divisions: (_maxHour - (_use30HourFormat ? 6 : 0)).toInt(),
                onChanged: (RangeValues values) {
                  // 确保 start <= end
                  final start = values.start <= values.end ? values.start : values.end;
                  final end = values.start <= values.end ? values.end : values.start;
                  setState(() {
                    _timeRangeValues = RangeValues(start, end);
                  });
                  // 转换为完整的日期时间格式传递给后端
                  // 存储格式：数组包含两个元素，分别是开始时间和结束时间
                  final baseDate = widget.baseDate ?? DateTime.now();
                  final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
                  
                  DateTime startDateTime;
                  DateTime endDateTime;
                  
                  if (_use30HourFormat) {
                    // 30小时制处理
                    if (start >= 24) {
                      final hour = (start - 24).toInt();
                      final minute = ((start - start.toInt()) * 60).toInt();
                      startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day + 1, hour, minute);
                    } else {
                      final hour = start.toInt();
                      final minute = ((start - start.toInt()) * 60).toInt();
                      startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
                    }
                    
                    if (end >= 24) {
                      if (end == 29) {
                        endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day + 1, 5, 59, 59);
                      } else {
                        final hour = (end - 24).toInt();
                        final minute = ((end - end.toInt()) * 60).toInt();
                        endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day + 1, hour, minute);
                      }
                    } else {
                      final hour = end.toInt();
                      final minute = ((end - end.toInt()) * 60).toInt();
                      endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
                    }
                  } else {
                    // 24小时制处理
                    if (end == 24) {
                      final hour = start.toInt();
                      final minute = ((start - start.toInt()) * 60).toInt();
                      startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
                      endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, 23, 59, 59);
                    } else {
                      final startHourInt = start.toInt();
                      final startMinute = ((start - start.toInt()) * 60).toInt();
                      final endHourInt = end.toInt();
                      final endMinute = ((end - end.toInt()) * 60).toInt();
                      startDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, startHourInt, startMinute);
                      endDateTime = DateTime(baseDate.year, baseDate.month, baseDate.day, endHourInt, endMinute);
                    }
                  }
                  
                  widget.onSelectionChanged([
                    dateFormat.format(startDateTime),
                    dateFormat.format(endDateTime),
                  ]);
                },
              ),
            ),
          ),
          // 当前选中的时间值（小字显示）
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: selectedColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    displayStart,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                      color: selectedColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    '-',
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: selectedColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    displayEnd,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                      color: selectedColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 时间标签（起始和结束）
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _use30HourFormat ? '06:00:00' : '00:00',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  _use30HourFormat ? '29:59:59' : '24:00',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  /// 格式化时间（小时转时间字符串，用于显示）
  /// 30小时制：滑块值6-23正常显示，24-29显示为24:00-29:59
  String _formatTimeForDisplay(double hour) {
    int displayHour = hour.toInt();
    
    // 30小时制：滑块值6-23正常显示，24-29显示为24-29
    // 不需要转换，因为滑块值已经是正确的显示值
    
    final m = ((hour - hour.toInt()) * 60).toInt();
    return '${displayHour.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }


  /// 构建 Switch 筛选
  Widget _buildSwitchFilter(Color selectedColor) {
    // 判断是否选中：根据配置的值或布尔值判断
    final bool isOn;
    if (widget.filter.switchOnValue != null) {
      // 使用配置的值
      isOn = widget.selectedIds.isNotEmpty && widget.selectedIds.first == widget.filter.switchOnValue;
    } else {
      // 使用布尔值：检查是否包含 true（作为字符串）
      isOn = widget.selectedIds.isNotEmpty && widget.selectedIds.first == 'true';
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h),
        child: Row(
          children: [
            if ((widget.filter.drawerDisplayConfig?.icon ?? widget.filter.icon) != null) ...[
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: widget.filter.drawerDisplayConfig?.iconBackgroundColor ?? 
                         (isOn ? selectedColor.withValues(alpha: 0.1) : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  widget.filter.drawerDisplayConfig?.icon ?? widget.filter.icon,
                  size: widget.filter.drawerDisplayConfig?.iconSize ?? 24.sp,
                  color: widget.filter.drawerDisplayConfig?.iconColor ?? 
                         (isOn ? selectedColor : Colors.grey.shade600),
                ),
              ),
              SizedBox(width: 16.w),
            ],
            Expanded(
              child: Text(
                widget.filter.drawerDisplayConfig?.title ?? widget.filter.title,
                style: widget.filter.drawerDisplayConfig?.titleStyle ?? TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            _CustomSwitch(
              value: isOn,
              onChanged: (bool value) {
                // 返回单个值（字符串形式），后续在 FilterBar 中会转换为对应的类型
                if (value) {
                  // 选中：如果配置了 onValue，使用配置的值；否则使用 'true'
                  final onValue = widget.filter.switchOnValue ?? 'true';
                  widget.onSelectionChanged([onValue]);
                } else {
                  // 未选中：如果配置了 offValue，使用配置的值；否则使用 'false'
                  final offValue = widget.filter.switchOffValue ?? 'false';
                  widget.onSelectionChanged([offValue]);
                }
              },
              activeColor: selectedColor,
              size: 0.9, // 自定义大小
            ),
          ],
        ),
      ),
    );
  }

  /// 构建普通按钮筛选
  Widget _buildChipFilter(Color selectedColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Container(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 16.h),
            child: Row(
              children: [
                if ((widget.filter.drawerDisplayConfig?.icon ?? widget.filter.icon) != null) ...[
                  Icon(
                    widget.filter.drawerDisplayConfig?.icon ?? widget.filter.icon,
                    size: widget.filter.drawerDisplayConfig?.iconSize ?? 24.sp,
                    color: widget.filter.drawerDisplayConfig?.iconColor ?? Colors.black87,
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Text(
                    widget.filter.drawerDisplayConfig?.title ?? widget.filter.title,
                    style: widget.filter.drawerDisplayConfig?.titleStyle ?? TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 筛选项按钮
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
            child: Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              children: widget.filter.values.map((value) {
                final isSelected = widget.selectedIds.contains(value.id);
                return _buildFilterChip(value, isSelected, selectedColor);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建筛选按钮
  Widget _buildFilterChip(FilterValue value, bool isSelected, Color selectedColor) {
    return GestureDetector(
      onTap: () {
        final newSelectedIds = List<String>.from(widget.selectedIds);
        
        if (widget.filter.isMultiSelect) {
          // 多选模式
          if (isSelected) {
            newSelectedIds.remove(value.id);
          } else {
            if (value.id == '') {
              // 如果选择了"全部"，清空其他选项
              newSelectedIds.clear();
              newSelectedIds.add('');
            } else {
              // 如果选择了其他选项，移除"全部"
              newSelectedIds.remove('');
              if (!newSelectedIds.contains(value.id)) {
                newSelectedIds.add(value.id);
              }
            }
          }
        } else {
          // 单选模式：点击任何选项时，都只选中该选项
          newSelectedIds.clear();
          newSelectedIds.add(value.id);
        }
        
        widget.onSelectionChanged(newSelectedIds);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          value.name,
          style: TextStyle(
            fontSize: 28.sp,
            color: isSelected ? selectedColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// 自定义 Switch 组件，参考图片样式
/// 支持圆角矩形轨道、圆形滑块、加载状态、自定义图标等
class _CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;
  final double size; // 缩放比例
  final bool showLoading; // 是否显示加载状态
  final IconData? thumbIcon; // 滑块内的图标（如对勾）

  const _CustomSwitch({
    required this.value,
    this.onChanged,
    this.activeColor = const Color(0xFF1989FA),
    this.size = 1.0,
    this.showLoading = false,
    this.thumbIcon,
  });

  @override
  State<_CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<_CustomSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    if (widget.value) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onChanged != null;
    final trackWidth = 50.0 * widget.size;
    final trackHeight = 30.0 * widget.size;
    final thumbSize = 24.0 * widget.size;
    final thumbPadding = 3.0 * widget.size;

    return GestureDetector(
      onTap: isEnabled && !widget.showLoading
          ? () {
              widget.onChanged!(!widget.value);
            }
          : null,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final thumbPosition = _animation.value * (trackWidth - thumbSize - thumbPadding * 2);
          
          return Container(
            width: trackWidth,
            height: trackHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(trackHeight / 2),
              color: isEnabled
                  ? (widget.value
                      ? widget.activeColor
                      : Colors.grey.shade300)
                  : (widget.value
                      ? widget.activeColor.withValues(alpha: 0.5)
                      : Colors.grey.shade200),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: thumbPadding + thumbPosition,
                  top: thumbPadding,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: widget.showLoading
                        ? Center(
                            child: SizedBox(
                              width: thumbSize * 0.5,
                              height: thumbSize * 0.5,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.activeColor,
                                ),
                              ),
                            ),
                          )
                        : widget.thumbIcon != null && widget.value
                            ? Icon(
                                widget.thumbIcon,
                                size: thumbSize * 0.5,
                                color: widget.activeColor,
                              )
                            : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
