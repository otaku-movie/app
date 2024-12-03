import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final Color backgroundColor;
  final TextStyle titleTextStyle;
  final PreferredSizeWidget? bottom; // Make it nullable

  const CustomAppBar({super.key, 
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackButtonPressed,
    this.backgroundColor = Colors.blue,
    this.titleTextStyle = const TextStyle(color: Colors.white, fontSize: 20),
    this.bottom, // Initialize bottom here
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: titleTextStyle.color),
              onPressed:
                  onBackButtonPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      bottom: bottom, // Use bottom here
    );
  }

  @override
  Size get preferredSize {
    double height = kToolbarHeight;
    if (bottom != null) {
      height += bottom!.preferredSize.height; // 动态获取 bottom 的高度
    }
    return Size.fromHeight(height);
  }

}
