import 'package:flutter/material.dart';

class AppErrorWidget extends StatefulWidget {
  final bool loading;
  final bool error;
  final Widget child;

  const AppErrorWidget({
    super.key,
    this.loading = false,
    this.error = false, 
    required this.child,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<AppErrorWidget> {
  @override
  Widget build(BuildContext context) {
    
    if (widget.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } 
    
    if (widget.error) {
      return const Center(
        child: Text('error'),
      );
    }
    
    return widget.child;
  }
}