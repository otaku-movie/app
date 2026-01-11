import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'FilterBar.dart';

/// Drawer 中的筛选项组件
/// 显示标题和筛选选项，支持单选和多选
class DrawerFilterItem extends StatelessWidget {
  final FilterOption filter;
  final List<String> selectedIds;
  final void Function(List<String> newSelectedIds) onSelectionChanged;
  final FilterBarStyle? style;

  const DrawerFilterItem({
    super.key,
    required this.filter,
    required this.selectedIds,
    required this.onSelectionChanged,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            filter.title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          // 筛选项
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: filter.values.map((value) {
              final isSelected = selectedIds.contains(value.id);
              return _buildFilterChip(value, isSelected);
            }).toList(),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  /// 构建筛选标签
  Widget _buildFilterChip(FilterValue value, bool isSelected) {
    final selectedBgColor = style?.selectedBackgroundColor ?? const Color(0xFF1989FA);
    final selectedBorderColor = style?.selectedBorderColor ?? const Color(0xFF1989FA);
    final selectedTextColor = style?.selectedTextColor ?? Colors.white;

    return GestureDetector(
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? selectedBorderColor : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.name,
              style: TextStyle(
                fontSize: 26.sp,
                color: isSelected ? selectedTextColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (value.count != null) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${value.count}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
