import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Input extends StatefulWidget {
  final String placeholder;
  final String type;
  final TextEditingController controller; 
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final TextStyle? suffixStyle;
  final Color? suffixIconColor;
  final Widget? prefixIcon;
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
  final double? horizontalPadding;
  final bool? disabled;
  final Color? cursorColor;
  final TextStyle? placeholderStyle;
  final FocusNode? focusNode;

  const Input({
    super.key,
    this.type = 'text',
    this.placeholder = '',
    required this.controller,
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
    this.horizontalPadding,
    this.disabled,
    this.placeholderStyle,
    this.focusNode
  });

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // const double textHeight = 20.0;
    // double height = widget.height ?? 60.0;
    // double paddingVertical = (height - textHeight) / 2;

    // EdgeInsetsGeometry defaultContentPadding = widget.contentPadding ??
    //     EdgeInsets.symmetric(horizontal: 16.0, vertical: paddingVertical);

    return Theme(
      data: ThemeData(
        primaryColor: widget.focusColor ?? Colors.transparent,
      ),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: TextField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.type == 'password',
          style: widget.textStyle ??
              const TextStyle(color: Colors.black), // Default text style
          cursorColor: widget.cursorColor,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            suffixStyle: widget.suffixStyle,
            suffixIconColor: widget.suffixIconColor,
            hintText: widget.placeholder,
            hintStyle: widget.placeholderStyle ??
                const TextStyle(color: Colors.grey),
            filled: widget.backgroundColor != null,
            fillColor: widget.backgroundColor,
            contentPadding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 10.w),
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
            disabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(3),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: widget.onTap,
          onChanged: widget.onChange,
          onSubmitted: widget.onSubmit,
          enabled: widget.disabled != true,
        ),
      ),
    );
  }
}
