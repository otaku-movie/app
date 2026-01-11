import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'FilterBar.dart';

/// Drawer 中的筛选项组件（Switch 样式）
/// 使用 Switch 显示筛选选项，支持开关切换
class DrawerFilterListTile extends StatelessWidget {
  final FilterOption filter;
  final List<String> selectedIds;
  final void Function(List<String> newSelectedIds) onSelectionChanged;
  final FilterBarStyle? style;

  const DrawerFilterListTile({
    super.key,
    required this.filter,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final selectedBgColor = style?.selectedBackgroundColor ?? const Color(0xFF1989FA);
    
    // 判断是否为开关类型（只有两个选项，且一个是"全部"或空字符串）
    final isSwitchType = filter.values.length == 2 && 
        filter.values.any((v) => v.id == '' || v.name.contains('全部')) &&
        filter.values.any((v) => v.id != '' && !v.name.contains('全部'));
    
    if (isSwitchType) {
      // Switch 开关样式
      final switchValue = filter.values.firstWhere(
        (v) => v.id != '' && !v.name.contains('全部'),
        orElse: () => filter.values.first,
      );
      final isOn = selectedIds.contains(switchValue.id);
      
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              if (filter.icon != null) ...[
                Icon(
                  filter.icon,
                  size: 28.sp,
                  color: Colors.black87,
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: Text(
                  switchValue.name,
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Switch(
                value: isOn,
                onChanged: (bool value) {
                  final newSelectedIds = <String>[];
                  if (value) {
                    newSelectedIds.add(switchValue.id);
                  }
                  onSelectionChanged(newSelectedIds);
                },
                activeColor: selectedBgColor,
              ),
            ],
          ),
        ),
      );
    }
    
    // 多选项列表样式
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Container(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 12.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          child: Row(
            children: [
              if (filter.icon != null) ...[
                Icon(
                  filter.icon,
                  size: 26.sp,
                  color: Colors.black87,
                ),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: Text(
                  filter.title,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        // 筛选项列表
        ...filter.values.map((value) {
          final isSelected = selectedIds.contains(value.id);
          return _buildListTile(value, isSelected, selectedBgColor);
        }).toList(),
        SizedBox(height: 12.h),
      ],
    );
  }

  /// 构建列表项
  Widget _buildListTile(FilterValue value, bool isSelected, Color selectedColor) {
    return InkWell(
      onTap: () {
        final newSelectedIds = List<String>.from(selectedIds);
        
        if (filter.isMultiSelect) {
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
        
        onSelectionChanged(newSelectedIds);
      },
      child: Container(
        color: isSelected ? selectedColor.withValues(alpha: 0.08) : Colors.transparent,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          dense: false,
          leading: filter.isMultiSelect
              ? Checkbox(
                  value: isSelected,
                  onChanged: (bool? checked) {
                    final newSelectedIds = List<String>.from(selectedIds);
                    
                    if (checked == true) {
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
                    } else {
                      newSelectedIds.remove(value.id);
                    }
                    
                    onSelectionChanged(newSelectedIds);
                  },
                  activeColor: selectedColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )
              : Radio<String>(
                  value: value.id,
                  groupValue: selectedIds.isNotEmpty ? selectedIds.first : null,
                  onChanged: (String? selectedId) {
                    final newSelectedIds = <String>[];
                    if (selectedId != null && selectedId != '') {
                      newSelectedIds.add(selectedId);
                    }
                    onSelectionChanged(newSelectedIds);
                  },
                  activeColor: selectedColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
          title: Text(
            value.name,
            style: TextStyle(
              fontSize: 30.sp,
              color: isSelected ? selectedColor : Colors.black87,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              height: 1.4,
            ),
          ),
          trailing: value.count != null
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedColor.withValues(alpha: 0.15)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    '${value.count}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: isSelected ? selectedColor : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
