import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/pages/movie/confirmOrder.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final Color backgroundColor;
  final TextStyle? titleTextStyle;
  final PreferredSizeWidget? bottom; // Make it nullable

  const CustomAppBar({
    super.key, 
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackButtonPressed,
    this.titleTextStyle,
    this.backgroundColor = Colors.blue,
    this.bottom, // Initialize bottom here
  });

  @override
  Widget build(BuildContext context) {
    RouteMatchList  routeMatchList = GoRouter.of(context).routerDelegate.currentConfiguration;

    return AppBar(
      title: title is String 
        ? Text(title as String, style: titleTextStyle ?? TextStyle(color: Colors.white, fontSize: 34.sp)) 
        : title,
      leading: showBackButton && routeMatchList.routes.length > 1
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // List<RouteBase> routes = routeMatchList.routes;
                Navigator.of(context).pop();
                // GoRouter.of(context).pop();
                // context.pop();
              },
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
