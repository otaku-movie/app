import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Input extends StatefulWidget {
  final String placeholder;
  final String type;
  final TextInputType? keyboardType;
  final Icon? suffixIcon;
  final TextStyle? suffixStyle;
  final Color? suffixIconColor;
  final Icon? prefixIcon;
  final Color? focusColor;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onSubmit;
  final void Function()? onTap;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;
  final bool? disabled;
  final Color? cursorColor;
  final TextStyle? placeholderStyle; // Add this for placeholder styling

  const Input({
    super.key,
    this.type = 'text',
    this.placeholder = '',
    this.cursorColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.suffixStyle,
    this.prefixIcon,
    this.keyboardType,
    this.border,
    this.borderRadius,
    this.backgroundColor,
    this.focusColor,
    this.onChange,
    this.onSubmit,
    this.onTap,
    this.width,
    this.height,
    this.textStyle,
    this.contentPadding,
    this.disabled,
    this.placeholderStyle, // Add this parameter
  }) : super();

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override

  @override
  void dispose() {
    // if (mounted) {
    //   FocusScope.of(context).unfocus();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.height ?? 60.0; // Default height if not provided
    double paddingVertical = (height - 20) / 2; // Calculate vertical padding

    // Default content padding with additional horizontal and vertical padding
    EdgeInsetsGeometry defaultContentPadding = widget.contentPadding ??
        EdgeInsets.symmetric(horizontal: 16.0, vertical: paddingVertical);

    return Theme(
      data: ThemeData(
        primaryColor: widget.focusColor ?? Colors.transparent,
      ),
      child: SizedBox(
        width: widget.width,
        height: height,
        child: TextField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.type == 'password',
          style: widget.textStyle ??
              const TextStyle(
                  color: Colors.black), // Default text style if not provided
          cursorColor: widget.cursorColor,
          textAlignVertical:
              TextAlignVertical.center, // Ensure text is vertically centered
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            suffixStyle: widget.suffixStyle,
            suffixIconColor: widget.suffixIconColor,
            hintText: widget.placeholder,
            hintStyle: widget.placeholderStyle ??
                const TextStyle(color: Colors.grey), // Apply placeholder styling
            enabled: widget.disabled != true,
            disabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(3),
              borderSide: BorderSide.none,
            ),
            filled: widget.backgroundColor != null,
            fillColor: widget.backgroundColor,
            contentPadding: defaultContentPadding, // Apply content padding
            focusedBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(3),
              borderSide: widget.border ??
                  const BorderSide(color: Colors.transparent, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(3),
              borderSide: widget.border ??
                  const BorderSide(color: Colors.transparent, width: 1),
            ),
          ),
          onTap: widget.onTap,
          onChanged: widget.onChange,
          onSubmitted: widget.onSubmit,
        ),
      ),
    );
  }
}
