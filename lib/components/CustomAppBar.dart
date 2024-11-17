import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final Color backgroundColor;
  final TextStyle titleTextStyle;
  final TabBar? bottom; // Make it nullable

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
      title: this.title,
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
    // Define the height for the TabBar if it's present
    double height = kToolbarHeight;
    if (bottom != null) {
      // If you want to adjust the TabBar height manually, set it here
      height +=
          48.0; // Default TabBar height is around 48 pixels, adjust if needed
    }
    return Size.fromHeight(height);
  }
}
